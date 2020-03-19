import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

///////////////////////////////////////////////////////////////////////////////
// C bindings
///////////////////////////////////////////////////////////////////////////////

// char *digest_hex_claim(const char *hex_claim_ptr);
// char *digest_string_claim(const char *str_claim_ptr);
// void free_cstr(char *string);
// char *generate_zk_proof(const char *proving_key_path, const char *inputs);

///////////////////////////////////////////////////////////////////////////////
// Typedef's
///////////////////////////////////////////////////////////////////////////////

typedef DigestHexClaimFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DigestHexClaimFuncNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef DigestStringClaim = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DigestStringClaimNative = Pointer<Utf8> Function(Pointer<Utf8>);

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
