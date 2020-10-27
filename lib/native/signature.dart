import 'package:ffi/ffi.dart';
import './bridge.dart' as bridge;

// ////////////////////////////////////////////////////////////////////////////
// / IMPLEMENTATION
// ////////////////////////////////////////////////////////////////////////////

/// Computes the address corresponding to the given private key
String signString(String message, String hexPrivateKey, int chainId) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final messagePtr = Utf8.toUtf8(message);
  final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

  // The actual native call
  final resultPtr = bridge.signMessage(messagePtr, privKeyPtr);

  return "0x" + bridge.handleResultStringPointer(resultPtr);
}

/// Computes the public key that signed the given messaga against the given signature
String recoverSignerPubKey(String hexSignature, String strMessage, int chainId) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final hexSignaturePtr = Utf8.toUtf8(hexSignature.replaceAll(r"^0x", ""));
  final messagePtr = Utf8.toUtf8(strMessage);

  // The actual native call
  final resultPtr = bridge.recoverMessageSigner(hexSignaturePtr, messagePtr);

  return "0x" + bridge.handleResultStringPointer(resultPtr);
}

/// Checks whether the given signature corresponds to hexPublicKey for the given message
bool isValidSignature(
    String hexSignature, String strMessage, String hexPublicKey, int chainId) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final hexSignaturePtr = Utf8.toUtf8(hexSignature);
  final messagePtr = Utf8.toUtf8(strMessage);
  final hexPublicKeyPtr = Utf8.toUtf8(hexPublicKey.replaceAll(r"^0x", ""));

  // The actual native call
  final validValue =
      bridge.isSignatureValid(hexSignaturePtr, messagePtr, hexPublicKeyPtr);

  return validValue != 0;
}
