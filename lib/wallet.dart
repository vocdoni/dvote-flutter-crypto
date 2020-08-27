import 'package:ffi/ffi.dart';
import './native-bridge/index.dart' as bridge;

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

class Wallet {
  /// Generates a random mnemonic of the given size
  static String generateMnemonic(int size) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

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
    final resultPtr = bridge.generateMnemonic(size);
    final result = Utf8.fromUtf8(resultPtr);

    if (result.startsWith("ERROR: ")) {
      final errMessage = "" + result.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final mnemonic = "" + result; // make a copy before freing
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return mnemonic;
  }

  /// Computes the private key derived from the given seed phrase and HD path
  static String computePrivateKey(String mnemonic, [String hdPath]) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

    final mnemonicPtr = Utf8.toUtf8(mnemonic);
    final hdPathPtr = Utf8.toUtf8(hdPath ?? "");

    // The actual native call
    final resultPtr = bridge.computePrivateKey(mnemonicPtr, hdPathPtr);
    final result = Utf8.fromUtf8(resultPtr);

    if (result.startsWith("ERROR: ")) {
      final errMessage = "" + result.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final privKey = "0x" + result; // make a copy before freing
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return privKey;
  }

  /// Computes the public key corresponding to the given private one
  static String computePublicKey(String hexPrivateKey,
      {bool uncompressed = false}) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

    final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

    // The actual native call
    final resultPtr = uncompressed
        ? bridge.computePublicKeyUncompressed(privKeyPtr)
        : bridge.computePublicKey(privKeyPtr);
    final result = Utf8.fromUtf8(resultPtr);

    if (result.startsWith("ERROR: ")) {
      final errMessage = "" + result.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final pubKey = "0x" + result; // make a copy before freing
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return pubKey;
  }

  /// Computes the address corresponding to the given private key
  static String computeAddress(String hexPrivateKey) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

    final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

    // The actual native call
    final resultPtr = bridge.computeAddress(privKeyPtr);
    final result = Utf8.fromUtf8(resultPtr);

    if (result.startsWith("ERROR: ")) {
      final errMessage = "" + result.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final address = "" + result; // make a copy before freing
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return address;
  }

  /// Computes the address corresponding to the given private key
  static String sign(String message, String hexPrivateKey) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

    final messagePtr = Utf8.toUtf8(message);
    final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

    // The actual native call
    final resultPtr = bridge.signMessage(messagePtr, privKeyPtr);
    final result = Utf8.fromUtf8(resultPtr);

    if (result.startsWith("ERROR: ")) {
      final errMessage = "" + result.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final signature = "0x" + result; // make a copy before freing
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return signature;
  }

  /// Computes the public key that signed the given messaga against the given signature
  static String recoverSigner(String hexSignature, String message) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

    final hexSignaturePtr = Utf8.toUtf8(hexSignature.replaceAll(r"^0x", ""));
    final messagePtr = Utf8.toUtf8(message);

    // The actual native call
    final resultPtr = bridge.recoverMessageSigner(hexSignaturePtr, messagePtr);
    final result = Utf8.fromUtf8(resultPtr);

    if (result.startsWith("ERROR: ")) {
      final errMessage = "" + result.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final pubKey = "0x" + result; // make a copy before freing
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return pubKey;
  }

  /// Checks whether the given signature corresponds to hexPublicKey for the given message
  static bool isValid(
      String hexSignature, String message, String hexPublicKey) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");

    final hexSignaturePtr = Utf8.toUtf8(hexSignature);
    final messagePtr = Utf8.toUtf8(message);
    final hexPublicKeyPtr = Utf8.toUtf8(hexPublicKey.replaceAll(r"^0x", ""));

    // The actual native call
    final validValue =
        bridge.isSignatureValid(hexSignaturePtr, messagePtr, hexPublicKeyPtr);

    return validValue != 0;
  }
}
