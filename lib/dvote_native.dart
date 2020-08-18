import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

///////////////////////////////////////////////////////////////////////////////
// C bindings
///////////////////////////////////////////////////////////////////////////////

// char *compute_address(const char *hex_private_key_ptr);
// char *compute_private_key(const char *mnemonic_ptr, const char *hd_path_ptr);
// char *compute_public_key(const char *hex_private_key_ptr);
// char *digest_hex_claim(const char *hex_claim_ptr);
// char *digest_string_claim(const char *str_claim_ptr);
// void free_cstr(char *string);
// char *generate_mnemonic(int32_t size);
// char *generate_zk_proof(const char *proving_key_path, const char *inputs);
// bool is_valid_signature(const char *hex_signature_ptr, const char *message_ptr, const char *hex_public_key_ptr);
// char *recover_message_signer(const char *hex_signature_ptr, const char *message_ptr);
// char *sign_message(const char *message_ptr, const char *hex_private_key_ptr);

///////////////////////////////////////////////////////////////////////////////
// Typedef's
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

typedef GenerateZkProof = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef GenerateZkProofNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

///////////////////////////////////////////////////////////////////////////////
// Load the library
///////////////////////////////////////////////////////////////////////////////

final DynamicLibrary nativeDvote = Platform.isAndroid
    ? DynamicLibrary.open("libdvote.so")
    : DynamicLibrary.process();

///////////////////////////////////////////////////////////////////////////////
// Locate the symbols we want to use
///////////////////////////////////////////////////////////////////////////////

final DigestHexClaimFunc _digestHexClaim = nativeDvote
    .lookup<NativeFunction<DigestHexClaimFuncNative>>("digest_hex_claim")
    .asFunction();

final DigestStringClaim _digestStringClaim = nativeDvote
    .lookup<NativeFunction<DigestStringClaimNative>>("digest_string_claim")
    .asFunction();

final GenerateMnemonic _generateMnemonic = nativeDvote
    .lookup<NativeFunction<GenerateMnemonicNative>>("generate_mnemonic")
    .asFunction();

final ComputePrivateKey _computePrivateKey = nativeDvote
    .lookup<NativeFunction<ComputePrivateKeyNative>>("compute_private_key")
    .asFunction();

final ComputePublicKey _computePublicKey = nativeDvote
    .lookup<NativeFunction<ComputePublicKeyNative>>("compute_public_key")
    .asFunction();

final ComputeAddress _computeAddress = nativeDvote
    .lookup<NativeFunction<ComputeAddressNative>>("compute_address")
    .asFunction();

final SignMessage _signMessage = nativeDvote
    .lookup<NativeFunction<SignMessageNative>>("sign_message")
    .asFunction();

final RecoverMessageSigner _recoverMessageSigner = nativeDvote
    .lookup<NativeFunction<RecoverMessageSignerNative>>(
        "recover_message_signer")
    .asFunction();

final IsSignatureValid _isSignatureValid = nativeDvote
    .lookup<NativeFunction<IsSignatureValidNative>>("is_valid_signature")
    .asFunction();

final GenerateZkProof _generateZkProof = nativeDvote
    .lookup<NativeFunction<GenerateZkProofNative>>("generate_zk_proof")
    .asFunction();

final FreeStringFunc _freeCString = nativeDvote
    .lookup<NativeFunction<FreeStringFuncNative>>("free_cstr")
    .asFunction();

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

/// Generates a Poseidon Hash of the given hex payload and returns it encoded in Base64
String digestHexClaim(String claimData) {
  if (nativeDvote == null) throw Exception("The library is not initialized");
  final claimDataPtr = Utf8.toUtf8(claimData);

  // The actual native call
  final resultPtr = _digestHexClaim(claimDataPtr);
  final hashStr = Utf8.fromUtf8(resultPtr);

  if (hashStr.startsWith("ERROR: ")) {
    final errMessage = "" + hashStr.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final hash = "" + hashStr;
  // Free the string pointer
  _freeCString(resultPtr);
  return hash;
}

/// Generates a Poseidon Hash of the given UTF8 string and returns it encoded in Base64
String digestStringClaim(String claimData) {
  if (nativeDvote == null) throw Exception("The library is not initialized");
  final claimDataPtr = Utf8.toUtf8(claimData);

  // The actual native call
  final resultPtr = _digestStringClaim(claimDataPtr);
  final hashStr = Utf8.fromUtf8(resultPtr);

  if (hashStr.startsWith("ERROR: ")) {
    final errMessage = "" + hashStr.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final hash = "" + hashStr;
  // Free the string pointer
  _freeCString(resultPtr);
  return hash;
}

/// Generates a random mnemonic of the given size
String generateMnemonic(int size) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  switch (size) {
    case 128:
    case 160:
    case 192:
    case 224:
    case 256:
      break;
    default:
      throw ArgumentError("Invalid key size");
  }

  // The actual native call
  final resultPtr = _generateMnemonic(size);
  final result = Utf8.fromUtf8(resultPtr);

  if (result.startsWith("ERROR: ")) {
    final errMessage = "" + result.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final mnemonic = "" + result; // make a copy before freing
  // Free the string pointer
  _freeCString(resultPtr);
  return mnemonic;
}

/// Computes the private key derived from the given seed phrase and HD path
String computePrivateKey(String mnemonic, [String hdPath]) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final mnemonicPtr = Utf8.toUtf8(mnemonic);
  final hdPathPtr = Utf8.toUtf8(hdPath ?? "");

  // The actual native call
  final resultPtr = _computePrivateKey(mnemonicPtr, hdPathPtr);
  final result = Utf8.fromUtf8(resultPtr);

  if (result.startsWith("ERROR: ")) {
    final errMessage = "" + result.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final privKey = "0x" + result; // make a copy before freing
  // Free the string pointer
  _freeCString(resultPtr);
  return privKey;
}

/// Computes the public key corresponding to the given private one
String computePublicKey(String hexPrivateKey) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

  // The actual native call
  final resultPtr = _computePublicKey(privKeyPtr);
  final result = Utf8.fromUtf8(resultPtr);

  if (result.startsWith("ERROR: ")) {
    final errMessage = "" + result.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final pubKey = "0x" + result; // make a copy before freing
  // Free the string pointer
  _freeCString(resultPtr);
  return pubKey;
}

/// Computes the address corresponding to the given private key
String computeAddress(String hexPrivateKey) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

  // The actual native call
  final resultPtr = _computeAddress(privKeyPtr);
  final result = Utf8.fromUtf8(resultPtr);

  if (result.startsWith("ERROR: ")) {
    final errMessage = "" + result.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final address = "" + result; // make a copy before freing
  // Free the string pointer
  _freeCString(resultPtr);
  return address;
}

/// Computes the address corresponding to the given private key
String signMessage(String message, String hexPrivateKey) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final messagePtr = Utf8.toUtf8(message);
  final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

  // The actual native call
  final resultPtr = _signMessage(messagePtr, privKeyPtr);
  final result = Utf8.fromUtf8(resultPtr);

  if (result.startsWith("ERROR: ")) {
    final errMessage = "" + result.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final signature = "0x" + result; // make a copy before freing
  // Free the string pointer
  _freeCString(resultPtr);
  return signature;
}

/// Computes the public key that signed the given messaga against the given signature
String recoverMessageSigner(String hexSignature, String message) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final hexSignaturePtr = Utf8.toUtf8(hexSignature.replaceAll(r"^0x", ""));
  final messagePtr = Utf8.toUtf8(message);

  // The actual native call
  final resultPtr = _recoverMessageSigner(hexSignaturePtr, messagePtr);
  final result = Utf8.fromUtf8(resultPtr);

  if (result.startsWith("ERROR: ")) {
    final errMessage = "" + result.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final pubKey = "0x" + result; // make a copy before freing
  // Free the string pointer
  _freeCString(resultPtr);
  return pubKey;
}

/// Verified that the
bool isSignatureValid(
    String hexSignature, String message, String hexPublicKey) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final hexSignaturePtr = Utf8.toUtf8(hexSignature);
  final messagePtr = Utf8.toUtf8(message);
  final hexPublicKeyPtr = Utf8.toUtf8(hexPublicKey.replaceAll(r"^0x", ""));

  // The actual native call
  final validValue =
      _isSignatureValid(hexSignaturePtr, messagePtr, hexPublicKeyPtr);

  return validValue != 0;
}

/// Computes the Zero Knowledge Proof for the given set of inputs using the Proving Key located at the given path.
/// Returns a string containing the data to ben sent to a verifier.
String generateZkProof(
    Map<String, dynamic> circuitInputs, String provingKeyPath) {
  if (nativeDvote == null) throw Exception("The library is not initialized");

  final strProvingKeyPath = Utf8.toUtf8(provingKeyPath);

  final strInputs = jsonEncode(circuitInputs);
  final strInputsParam = Utf8.toUtf8(strInputs);

  // The actual native call
  final resultPtr = _generateZkProof(strProvingKeyPath, strInputsParam);
  final zkProofStr = Utf8.fromUtf8(resultPtr);

  if (zkProofStr.startsWith("ERROR: ")) {
    final errMessage = "" + zkProofStr.substring(7);
    // Free the string pointer
    _freeCString(resultPtr);
    throw Exception(errMessage);
  }

  final hash = "" + zkProofStr;
  // Free the string pointer
  _freeCString(resultPtr);
  return hash;
}
