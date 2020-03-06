use ethkey::prelude::*;
use rustc_hex::ToHex;
// use rustc_hex::{FromHex, ToHex};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use tiny_keccak::{Hasher, Keccak};

pub enum Error {
    InvalidPrivateKey,
    InvalidPublicKey,
    SigningError,
    InvalidSignature,
}

// PUBLIC FUNCTIONS

#[no_mangle]
pub extern "C" fn sign_message(
    msg_ptr: *const c_char,
    hex_priv_key_ptr: *const c_char,
) -> *mut c_char {
    let message_str = unsafe { CStr::from_ptr(msg_ptr) }
        .to_str()
        .expect("Invalid message string");
    let hex_key_str = unsafe { CStr::from_ptr(hex_priv_key_ptr) }
        .to_str()
        .expect("Invalid hex key string");

    let key_bytes = &mut [0_u8; 32];

    match hex::decode_to_slice(hex_key_str, key_bytes) {
        Ok(_) => {}
        Err(_) => {
            return CString::new("Error: Invalid hex private key".to_owned())
                .unwrap()
                .into_raw()
        }
    }

    let signature = match sign_msg(message_str.as_bytes(), key_bytes) {
        Ok(sig) => sig,
        Err(Error::InvalidPrivateKey) => "Error: Invalid private key".to_owned(),
        Err(_) => "Error: Could not sign the message".to_owned(),
    };

    CString::new(signature).unwrap().into_raw()

    // NOTE: Caller must free() the resulting pointer
}

#[no_mangle]
pub extern "C" fn recover_signature(
    signature_ptr: *const c_char,
    msg_ptr: *const c_char,
) -> *mut c_char {
    let signature_ptr = unsafe { CStr::from_ptr(signature_ptr) }
        .to_str()
        .expect("Invalid signature string");
    let message_str = unsafe { CStr::from_ptr(msg_ptr) }
        .to_str()
        .expect("Invalid message string");

    let signature_bytes = &mut [0_u8; 32 + 32 + 1];
    match hex::decode_to_slice(signature_ptr, signature_bytes) {
        Ok(_) => {}
        Err(_) => {
            return CString::new("Error: Invalid hex signature".to_owned())
                .unwrap()
                .into_raw()
        }
    }

    let public_key = match recover_sig(signature_bytes, message_str.as_bytes()) {
        Ok(sig) => sig,
        Err(_) => "Error: Could not verify the message".to_owned(),
    };

    CString::new(public_key).unwrap().into_raw()

    // NOTE: Caller must free() the resulting pointer
}

#[no_mangle]
pub extern "C" fn is_valid_signature(
    signature_ptr: *const c_char,
    msg_ptr: *const c_char,
    public_key_ptr: *const c_char,
) -> bool {
    let signature_str = unsafe { CStr::from_ptr(signature_ptr) }
        .to_str()
        .expect("Invalid signature string");
    let message_str = unsafe { CStr::from_ptr(msg_ptr) }
        .to_str()
        .expect("Invalid message string");
    let mut hex_pub_key_str = unsafe { CStr::from_ptr(public_key_ptr) }
        .to_str()
        .expect("Invalid hex public key string");

    // SKIP "0x04"
    if hex_pub_key_str.len() == 132 && &hex_pub_key_str[0..4] == "0x04" {
        hex_pub_key_str = &hex_pub_key_str[4..];
    } else if hex_pub_key_str.len() == 130 && &hex_pub_key_str[0..4] == "04" {
        hex_pub_key_str = &hex_pub_key_str[2..];
    } else if hex_pub_key_str.len() != 128 {
        println!(
            "Error: Invalid public key supplied: {}\nPublic keys are expected to be a hex string in the expanded format. ",
            hex_pub_key_str
        );
        return false;
    }

    let public_key_bytes = &mut [0_u8; 64];
    match hex::decode_to_slice(hex_pub_key_str, public_key_bytes) {
        Ok(_) => {}
        Err(_) => return false,
    }

    let signature_bytes = &mut [0_u8; 32 + 32 + 1];
    match hex::decode_to_slice(signature_str, signature_bytes) {
        Ok(_) => {}
        Err(_) => return false,
    }

    let valid = match is_valid_sig(signature_bytes, message_str.as_bytes(), public_key_bytes) {
        Ok(v) => v,
        Err(Error::SigningError) => false,
        Err(_) => false,
    };

    valid

    // NOTE: Caller must free() the resulting pointer
}

// INTERNAL HANDLERS

fn sign_msg<'a>(message: &[u8], priv_key: &[u8]) -> Result<String, Error> {
    // hash the message
    let mut keccak256 = Keccak::v256();
    let mut message_hash = [0u8; 32];
    keccak256.update(&message);
    keccak256.finalize(&mut message_hash);

    // sign the keccak256 hash of the message
    let key = match SecretKey::from_raw(priv_key) {
        Ok(v) => v,
        Err(_) => return Err(Error::InvalidPrivateKey),
    };
    let signature = match key.sign(&message_hash) {
        Ok(v) => v,
        Err(_) => return Err(Error::SigningError),
    };
    // println!("{:?}", signature);

    let str_r = signature.r.to_hex::<String>();
    let str_s = signature.s.to_hex::<String>();
    let str_v = (&[signature.v] as &[u8]).to_hex::<String>();

    // TODO: Covert R/S/V into a padded hex string
    Ok(format!("{}{}{}", str_r, str_s, str_v).to_owned())
}

fn recover_sig(signature: &[u8], message: &[u8]) -> Result<String, Error> {
    // hash the message
    let mut keccak256 = Keccak::v256();
    let mut message_hash = [0u8; 32];
    keccak256.update(&message);
    keccak256.finalize(&mut message_hash);

    // Import the signature
    let mut _r: [u8; 32] = [0_u8; 32];
    let mut _s: [u8; 32] = [0_u8; 32];
    _r.copy_from_slice(&signature[0..32]);
    _s.copy_from_slice(&signature[32..64]);
    let mut _v: u8 = signature[64];

    let given_sig = Signature {
        r: _r,
        s: _s,
        v: _v,
    };
    // println!(
    //     " => MSG: {}, sig: {:?}",
    //     message.to_hex::<String>(),
    //     given_sig
    // );

    let public_key = match given_sig.recover(message) {
        Ok(v) => v,
        Err(_) => return Err(Error::InvalidSignature),
    };
    // println!(" => 3");

    let str_pubkey = "0x04".to_owned() + &public_key.bytes().to_hex::<String>();

    // public_key
    Ok(str_pubkey)
}

fn is_valid_sig(signature: &[u8], message: &[u8], public_key: &[u8]) -> Result<bool, Error> {
    // hash the message
    let mut keccak256 = Keccak::v256();
    let mut message_hash = [0u8; 32];
    keccak256.update(&message);
    keccak256.finalize(&mut message_hash);

    let pub_key = PublicKey::from_slice(public_key).unwrap();

    // Import the signature
    let mut _r: [u8; 32] = [0_u8; 32];
    let mut _s: [u8; 32] = [0_u8; 32];
    let mut _v: u8 = signature[65];
    _r.copy_from_slice(&signature[0..32]);
    _s.copy_from_slice(&signature[32..64]);

    let given_sig = Signature {
        r: _r,
        s: _s,
        v: _v,
    };

    // verify the signature
    let valid = match pub_key.verify(&given_sig, &message) {
        Ok(v) => v,
        Err(_) => return Err(Error::InvalidSignature),
    };
    Ok(valid)
}

// FREE

#[no_mangle]
pub extern "C" fn free_cstr(s: *mut c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        CString::from_raw(s)
    };
}

#[cfg(test)]
mod tests {
    use super::*;
    use rustc_hex::{FromHex, ToHex};

    #[test]
    fn should_sign() {
        let message = "Hello world".as_bytes();
        let secret: Vec<u8> = "4d5db4107d237df6a3d58ee5f70ae63d73d7658d4026f2eefd2f204c81682cb7"
            .from_hex()
            .unwrap();

        let signature = match sign_msg(message, &secret) {
            Ok(v) => v,
            Err(_) => {
                return assert_eq!("", "Signing failed");
            }
        };

        assert_eq!(&signature, "20e5910c20f6cef97cfde0a489c3499f36f22213066b2c0fcdf7ec7d75813e6a58adcf0ac53418f0cf185b9ce19745ad16ae471c53d9d07608d3600915a429a400");
    }

    #[test]
    fn should_recover() {
        let message = "Hello world".as_bytes();
        let secret: Vec<u8> = "4d5db4107d237df6a3d58ee5f70ae63d73d7658d4026f2eefd2f204c81682cb7"
            .from_hex()
            .unwrap();

        let key = SecretKey::from_raw(&secret).unwrap();
        let pub_key = key.public().bytes().to_hex::<String>();
        let signature = match sign_msg(message, &secret) {
            Ok(v) => v,
            Err(_) => {
                return assert_eq!("", "Signing failed");
            }
        };

        // check back

        let signature_bytes = &mut [0_u8; 32 + 32 + 1];
        // println!("SIG => {}", &signature);
        // println!("SIG => {}", signature_bytes.len());
        hex::decode_to_slice(signature, signature_bytes).unwrap();
        let recovered_pub_key = match recover_sig(signature_bytes, message) {
            Ok(v) => v,
            Err(_) => {
                return assert_eq!("", "Decoding failed");
            }
        };

        assert_eq!(&recovered_pub_key, "782cc7dd72426893ae0d71477e41c41b03249a2b72e78eefcfe0baa9df604a8f979ab94cd23d872dac7bfa8d07d8b76b26efcbede7079f1c5cacd88fe9858f6e");
        assert_eq!(&recovered_pub_key, &pub_key);
    }
}
