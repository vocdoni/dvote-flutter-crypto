import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

///////////////////////////////////////////////////////////////////////////////
// C bindings
///////////////////////////////////////////////////////////////////////////////

// char *compute_address(const char *hex_private_key_ptr);
// char *compute_private_key(const char *mnemonic_ptr, const char *hd_path_ptr);
// char *compute_public_key(const char *hex_private_key_ptr);
// char *compute_public_key_uncompressed(const char *hex_private_key_ptr);
// char *decrypt_symmetric(const char *base64_cipher_bytes_ptr, const char *passphrase_ptr);
// char *digest_hex_claim(const char *hex_claim_ptr);
// char *digest_string_claim(const char *str_claim_ptr);
// char *encrypt_symmetric(const char *message_ptr, const char *passphrase_ptr);
// void free_cstr(char *string);
// char *generate_mnemonic(int32_t size);
// char *generate_zk_proof(const char *proving_key_path, const char *inputs);
// bool is_valid(const char *hex_signature_ptr, const char *message_ptr, const char *hex_public_key_ptr);
// char *recover_signer(const char *hex_signature_ptr, const char *message_ptr);
// char *sign_message(const char *message_ptr, const char *hex_private_key_ptr);

///////////////////////////////////////////////////////////////////////////////
// Load the library
///////////////////////////////////////////////////////////////////////////////

final DynamicLibrary nativeDvote = Platform.isAndroid
    ? DynamicLibrary.open("libdvote.so")
    : DynamicLibrary.process();

///////////////////////////////////////////////////////////////////////////////
// Type definitions mapping
///////////////////////////////////////////////////////////////////////////////

typedef DigestHexClaimFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DigestHexClaimFuncNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef DigestStringClaim = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DigestStringClaimNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef GenerateMnemonic = Pointer<Utf8> Function(int);
typedef GenerateMnemonicNative = Pointer<Utf8> Function(Int32);

typedef ComputePrivateKey = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef ComputePrivateKeyNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef ComputePublicKey = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ComputePublicKeyNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef ComputePublicKeyUncompressed = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ComputePublicKeyUncompressedNative = Pointer<Utf8> Function(
    Pointer<Utf8>);

typedef ComputeAddress = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ComputeAddressNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef SignMessage = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef SignMessageNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef RecoverMessageSigner = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef RecoverMessageSignerNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef IsSignatureValid = int Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef IsSignatureValidNative = Int32 Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef EncryptSymmetric = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef EncryptSymmetricNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef DecryptSymmetric = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef DecryptSymmetricNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef GenerateZkProof = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef GenerateZkProofNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

///////////////////////////////////////////////////////////////////////////////
// Locate the symbols we want to use
///////////////////////////////////////////////////////////////////////////////

final DigestHexClaimFunc digestHexClaim = nativeDvote
    .lookup<NativeFunction<DigestHexClaimFuncNative>>("digest_hex_claim")
    .asFunction();

final DigestStringClaim digestStringClaim = nativeDvote
    .lookup<NativeFunction<DigestStringClaimNative>>("digest_string_claim")
    .asFunction();

final GenerateMnemonic generateMnemonic = nativeDvote
    .lookup<NativeFunction<GenerateMnemonicNative>>("generate_mnemonic")
    .asFunction();

final ComputePrivateKey computePrivateKey = nativeDvote
    .lookup<NativeFunction<ComputePrivateKeyNative>>("compute_private_key")
    .asFunction();

final ComputePublicKey computePublicKey = nativeDvote
    .lookup<NativeFunction<ComputePublicKeyNative>>("compute_public_key")
    .asFunction();

final ComputePublicKeyUncompressed computePublicKeyUncompressed = nativeDvote
    .lookup<NativeFunction<ComputePublicKeyUncompressedNative>>(
        "compute_public_key_uncompressed")
    .asFunction();

final ComputeAddress computeAddress = nativeDvote
    .lookup<NativeFunction<ComputeAddressNative>>("compute_address")
    .asFunction();

final SignMessage signMessage = nativeDvote
    .lookup<NativeFunction<SignMessageNative>>("sign_message")
    .asFunction();

final RecoverMessageSigner recoverMessageSigner = nativeDvote
    .lookup<NativeFunction<RecoverMessageSignerNative>>("recover_signer")
    .asFunction();

final IsSignatureValid isSignatureValid = nativeDvote
    .lookup<NativeFunction<IsSignatureValidNative>>("is_valid")
    .asFunction();

final EncryptSymmetric encryptSymmetric = nativeDvote
    .lookup<NativeFunction<EncryptSymmetricNative>>("encrypt_symmetric")
    .asFunction();

final DecryptSymmetric decryptSymmetric = nativeDvote
    .lookup<NativeFunction<DecryptSymmetricNative>>("decrypt_symmetric")
    .asFunction();

final GenerateZkProof generateZkProof = nativeDvote
    .lookup<NativeFunction<GenerateZkProofNative>>("generate_zk_proof")
    .asFunction();

final FreeStringFunc freeCString = nativeDvote
    .lookup<NativeFunction<FreeStringFuncNative>>("free_cstr")
    .asFunction();

///////////////////////////////////////////////////////////////////////////////
// Response handling
///////////////////////////////////////////////////////////////////////////////

/// Returns a copy of the string returned by the native function and frees the given pointer.
/// If the result contains an error, an Exception is raised.
String handleResultStringPointer(Pointer<Utf8> resultPtr) {
  final resultStr = Utf8.fromUtf8(resultPtr);

  if (resultStr.startsWith("ERROR: ")) {
    final errMessage = "" + resultStr.substring(7);
    // Free the string pointer
    freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final result = "" + resultStr;
  // Free the string pointer
  freeCString(resultPtr);
  return result;
}
