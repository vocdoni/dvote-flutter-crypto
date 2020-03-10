// extern crate stderrlog;
extern crate za_prover;

use poseidon_rs::Poseidon;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use za_prover::groth16;
use za_prover::groth16::helper;

///////////////////////////////////////////////////////////////////////////////
// EXPORTED FUNCTIONS FUNCTIONS
///////////////////////////////////////////////////////////////////////////////

#[no_mangle]
pub extern "C" fn digest_string_claim(str_claim_ptr: *const c_char) -> *mut c_char {
    let str_claim = unsafe { CStr::from_ptr(str_claim_ptr) }
        .to_str()
        .expect("Invalid str_claim string");

    let hex_result = digest_string_claim_inner(str_claim);

    CString::new(hex_result).unwrap().into_raw()

    // NOTE: Caller must free() the resulting pointer
}

#[no_mangle]
pub extern "C" fn digest_hex_claim(hex_claim_ptr: *const c_char) -> *mut c_char {
    let hex_claim = unsafe { CStr::from_ptr(hex_claim_ptr) }
        .to_str()
        .expect("Invalid hex_claim string");

    let hex_result = digest_hex_claim_inner(hex_claim);

    CString::new(hex_result).unwrap().into_raw()

    // NOTE: Caller must free() the resulting pointer
}

#[no_mangle]
pub extern "C" fn generate_zk_proof(
    proving_key_path: *const c_char,
    inputs: *const c_char,
) -> *mut c_char {
    let proving_key_path = unsafe { CStr::from_ptr(proving_key_path) };
    let proving_key_path = proving_key_path
        .to_str()
        .expect("Could not parse proving_key_path");

    let inputs = unsafe { CStr::from_ptr(inputs) };
    let inputs = inputs.to_str().expect("Could not parse the inputs");

    match groth16::flatten_json("main", &inputs)
        .and_then(|inputs| helper::prove(&proving_key_path, inputs))
    {
        Ok(proof) => CString::new(proof).unwrap().into_raw(),
        Err(err) => CString::new(format!("ERROR: {:?}", err))
            .unwrap()
            .into_raw(),
    }
    // NOTE: Caller must free() the resulting pointer
}

///////////////////////////////////////////////////////////////////////////////
// INTERNAL HANDLERS
///////////////////////////////////////////////////////////////////////////////

fn digest_string_claim_inner(claim: &str) -> String {
    // Convert into a byte array
    let claim_bytes = claim.as_bytes().to_vec();

    // Hash
    let poseidon = Poseidon::new();
    let hash = match poseidon.hash_bytes(claim_bytes) {
        Ok(v) => v,
        Err(reason) => {
            return format!("ERROR: {}", reason);
        }
    };

    // Convert to base64
    let hex_hash = format!("{:064x}", hash); // pad the 32 bytes to the right
    let claim_bytes = match hex::decode(&hex_hash) {
        Ok(v) => v,
        Err(err) => {
            return format!(
                "ERROR: The given claim ({}) is not a valid hex string - {}",
                hex_hash, err
            );
        }
    };
    base64::encode(claim_bytes)
}

fn digest_hex_claim_inner(hex_claim: &str) -> String {
    // Decode hex into a byte array
    let hex_claim_clean: &str = if hex_claim.starts_with("0x") {
        &hex_claim[2..] // skip 0x
    } else {
        hex_claim
    };
    let claim_bytes = match hex::decode(hex_claim_clean) {
        Ok(v) => v,
        Err(err) => {
            return format!(
                "ERROR: The given claim ({}) is not a valid hex string - {}",
                hex_claim, err
            );
        }
    };

    // Hash
    let poseidon = Poseidon::new();
    let hash = match poseidon.hash_bytes(claim_bytes) {
        Ok(v) => v,
        Err(reason) => {
            return format!("ERROR: {}", reason);
        }
    };

    // Convert to base64
    let hex_hash = format!("{:064x}", hash); // pad the 32 bytes to the right
    let claim_bytes = match hex::decode(&hex_hash) {
        Ok(v) => v,
        Err(err) => {
            return format!(
                "ERROR: The given claim ({}) is not a valid hex string - {}",
                hex_hash, err
            );
        }
    };
    base64::encode(claim_bytes)
}

///////////////////////////////////////////////////////////////////////////////
// STRING FREE
///////////////////////////////////////////////////////////////////////////////

#[no_mangle]
pub extern "C" fn free_cstr(string: *mut c_char) {
    unsafe {
        if string.is_null() {
            return;
        }
        CString::from_raw(string)
    };
}

///////////////////////////////////////////////////////////////////////////////
// TESTS
///////////////////////////////////////////////////////////////////////////////

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_hash_strings() {
        let str_claim = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
        let hex_hash = digest_string_claim_inner(str_claim);

        assert_eq!(hex_hash, "I2rUN6QzXXAgyyx/B/7CgLYH1YrIXtsIb61lXON1Xok=");
    }

    #[test]
    fn should_hash_hex_claims() {
        let hex_claim = "0x045a126cbbd3c66b6d542d40d91085e3f2b5db3bbc8cda0d59615deb08784e4f833e0bb082194790143c3d01cedb4a9663cb8c7bdaaad839cb794dd309213fcf30";
        let hex_hash = digest_hex_claim_inner(hex_claim);
        assert_eq!(hex_hash, "EB2a00pTkDYoqlnPUQ49D8wUZ41YPwEVpaoaLr2YY5w=");

        let hex_claim = "0x049969c7741ade2e9f89f81d12080651038838e8089682158f3d892e57609b64e2137463c816e4d52f6688d490c35a0b8e524ac6d9722eed2616dbcaf676fc2578";
        let hex_hash = digest_hex_claim_inner(hex_claim);
        assert_eq!(hex_hash, "HOONvrHcCA8KgfirpKKk1RuHUG3NZimRc+9NcJbJuI8=");

        let hex_claim = "0x049622878da186a8a31f4dc03454dbbc62365060458db174618218b51d5014fa56c8ea772234341ae326ce278091c39e30c02fa1f04792035d79311fe3283f1380";
        let hex_hash = digest_hex_claim_inner(hex_claim);
        assert_eq!(hex_hash, "KdzkitvXvJSqndKmRXAYBFZamdOrN+lFyEGKeYYGJeg=");

        let hex_claim = "0x0420606a7dcf293722f3eddc7dca0e2505c08d5099e3d495091782a107d006a7d64c3034184fb4cd59475e37bf40ca43e5e262be997bb74c45a9a723067505413e";
        let hex_hash = digest_hex_claim_inner(hex_claim);
        assert_eq!(hex_hash, "L3Y/6iJWtc6DyOS+Wad8tFlh8kiZO5BLCOhTHgSpIlc=");
    }

    #[test]
    fn should_match_string_and_hex() {
        let str_claim = "Hello";
        let hex_claim = "48656c6c6f"; // Hello
        let hex_hash1 = digest_string_claim_inner(str_claim);
        let hex_hash2 = digest_hex_claim_inner(hex_claim);
        assert_eq!(hex_hash1, hex_hash2);

        let str_claim = "Hello UTF8 ©âëíòÚ ✨";
        let hex_claim = "48656c6c6f205554463820c2a9c3a2c3abc3adc3b2c39a20e29ca8"; // Hello UTF8 ©âëíòÚ ✨
        let hex_hash1 = digest_string_claim_inner(str_claim);
        let hex_hash2 = digest_hex_claim_inner(hex_claim);
        assert_eq!(hex_hash1, hex_hash2);
    }

    #[test]
    fn should_hash_hex_with_0x() {
        let hex_hash1 = digest_hex_claim_inner(
            "48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f",
        );
        let hex_hash2 = digest_hex_claim_inner(
            "0x48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f48656c6c6f",
        );
        assert_eq!(hex_hash1, hex_hash2);

        let hex_hash1 = digest_hex_claim_inner(
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890",
        );
        let hex_hash2 = digest_hex_claim_inner(
            "0x12345678901234567890123456789012345678901234567890123456789012345678901234567890",
        );
        assert_eq!(hex_hash1, hex_hash2);

        let hex_hash1 = digest_hex_claim_inner(
            "01234567890123456789012345678901234567890123456789012345678901234567890123456789",
        );
        let hex_hash2 = digest_hex_claim_inner(
            "0x01234567890123456789012345678901234567890123456789012345678901234567890123456789",
        );
        assert_eq!(hex_hash1, hex_hash2);

        let hex_hash1 = digest_hex_claim_inner(
            "0000000000000000000000000000000000000000000000000000000000000000",
        );
        let hex_hash2 = digest_hex_claim_inner(
            "0x0000000000000000000000000000000000000000000000000000000000000000",
        );
        assert_eq!(hex_hash1, hex_hash2);

        let hex_hash1 = digest_hex_claim_inner(
            "8888888888888888888888888888888888888888888888888888888888888888",
        );
        let hex_hash2 = digest_hex_claim_inner(
            "0x8888888888888888888888888888888888888888888888888888888888888888",
        );
        assert_eq!(hex_hash1, hex_hash2);

        let hex_hash1 = digest_hex_claim_inner(
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
        );
        let hex_hash2 = digest_hex_claim_inner(
            "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
        );
        assert_eq!(hex_hash1, hex_hash2);

        let hex_hash1 = digest_hex_claim_inner("1234567890123456789012345678901234567890");
        let hex_hash2 = digest_hex_claim_inner("0x1234567890123456789012345678901234567890");
        assert_eq!(hex_hash1, hex_hash2);
    }
}
