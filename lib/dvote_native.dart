import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

///////////////////////////////////////////////////////////////////////////////
// C bindings
///////////////////////////////////////////////////////////////////////////////

// char *digest_hex_claim(const char *hex_claim_ptr);
// char *digest_string_claim(const char *str_claim_ptr);
// void free_cstr(char *string);

///////////////////////////////////////////////////////////////////////////////
// Typedef's
///////////////////////////////////////////////////////////////////////////////

typedef DigestHexClaimFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DigestHexClaimFuncNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef DigestStringClaim = Pointer<Utf8> Function(Pointer<Utf8>);
typedef DigestStringClaimNative = Pointer<Utf8> Function(Pointer<Utf8>);

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

final FreeStringFunc _freeCString = nativeDvote
    .lookup<NativeFunction<FreeStringFuncNative>>("free_cstr")
    .asFunction();

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

String digestHexClaim(String claimData) {
  if (nativeDvote == null) throw Exception("The library is not initialized");
  final claimDataPtr = Utf8.toUtf8(claimData);

  // The actual native call
  final hashPtr = _digestHexClaim(claimDataPtr);
  final hashStr = Utf8.fromUtf8(hashPtr);

  // Free the string pointer, as we already have
  // an owned String to return
  _freeCString(hashPtr);

  if (hashStr.startsWith("ERROR: ")) throw Exception(hashStr.substring(7));
  return hashStr;
}

String digestStringClaim(String claimData) {
  if (nativeDvote == null) throw Exception("The library is not initialized");
  final claimDataPtr = Utf8.toUtf8(claimData);

  // The actual native call
  final hashPtr = _digestStringClaim(claimDataPtr);
  final hashStr = Utf8.fromUtf8(hashPtr);

  // Free the string pointer, as we already have
  // an owned String to return
  _freeCString(hashPtr);

  if (hashStr.startsWith("ERROR: ")) throw Exception(hashStr.substring(7));
  return hashStr;
}
