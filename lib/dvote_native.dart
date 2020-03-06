import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// void free_cstr(char *s);
// bool is_valid_signature(const char *signature_ptr, const char *msg_ptr, const char *public_key_ptr);
// char *recover_signature(const char *signature_ptr, const char *msg_ptr);
// char *sign_message(const char *msg_ptr, const char *hex_priv_key_ptr);

// Use typedef for more readable type definitions below

typedef SignMessageFunc = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef SignMessageFuncNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef RecoverSignatureFunc = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);
typedef RecoverSignatureFuncNative = Pointer<Utf8> Function(
    Pointer<Utf8>, Pointer<Utf8>);

typedef IsValidSignatureFunc = int Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);
typedef IsValidSignatureFuncNative = Int32 Function(
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>);

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

// Load the library

final DynamicLibrary nativeExampleLib = Platform.isAndroid
    ? DynamicLibrary.open("libdvote.so")
    : DynamicLibrary.process();

// Find the symbols we want to use

final SignMessageFunc _signMessage = nativeExampleLib
    .lookup<NativeFunction<SignMessageFuncNative>>("sign_message")
    .asFunction();

final RecoverSignatureFunc _recoverSignature = nativeExampleLib
    .lookup<NativeFunction<RecoverSignatureFuncNative>>("recover_signature")
    .asFunction();

final IsValidSignatureFunc _isValidSignature = nativeExampleLib
    .lookup<NativeFunction<IsValidSignatureFuncNative>>("is_valid_signature")
    .asFunction();

final FreeStringFunc _freeCString = nativeExampleLib
    .lookup<NativeFunction<FreeStringFuncNative>>("free_cstr")
    .asFunction();

String signString(String message, String hexPrivateKey) {
  if (nativeExampleLib == null)
    return "ERROR: The library is not initialized 🙁";

  print("- DVote bindings found 👍");
  print("  ${nativeExampleLib.toString()}"); // Instance info

  final argMessage = Utf8.toUtf8(message);
  final argHexPrivateKey = Utf8.toUtf8(hexPrivateKey);
  print(
      "- Calling sign_message with arguments:  $argMessage, $argHexPrivateKey");

  // The actual native call
  final resultPointer = _signMessage(argMessage, argHexPrivateKey);
  print("- Result pointer:  $resultPointer");

  final signatureStr = Utf8.fromUtf8(resultPointer);
  print("- Response string:  $signatureStr");

  // Free the string pointer, as we already have
  // an owned String to return
  print("- Freing the native char*");
  _freeCString(resultPointer);

  return signatureStr;
}
