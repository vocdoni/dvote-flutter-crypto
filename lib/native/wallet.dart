import 'package:ffi/ffi.dart';
import 'package:hex/hex.dart';
import 'dart:typed_data';
import '../constants.dart';
import './bridge.dart' as bridge;
import '../dart/wallet.dart' as fallback;

// /////////////////////////////////////////////////////////////////////////////
// IMPLEMENTATION
// /////////////////////////////////////////////////////////////////////////////

/// Generates a random mnemonic of the given size
String makeRandomMnemonic(int size) {
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

  return bridge.handleResultStringPointer(resultPtr);
}

/// Computes the private key derived from the given seed phrase and HD path
Uint8List privateKeyBytes(String mnemonic, [String hdPath = DEFAULT_HD_PATH]) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final mnemonicPtr = Utf8.toUtf8(mnemonic);
  final hdPathPtr = Utf8.toUtf8(hdPath ?? "");

  // The actual native call
  final resultPtr = bridge.computePrivateKey(mnemonicPtr, hdPathPtr);
  final result = bridge.handleResultStringPointer(resultPtr);

  // return HEX.decode(result.replaceAll(RegExp(r"^0x"), ""));
  return HEX.decode(result);
}

/// Computes the public key corresponding to the given private one
Uint8List publicKeyBytes(String hexPrivateKey, bool uncompressed) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

  // The actual native call
  final resultPtr = uncompressed
      ? bridge.computePublicKeyUncompressed(privKeyPtr)
      : bridge.computePublicKey(privKeyPtr);
  final result = bridge.handleResultStringPointer(resultPtr);

  // return HEX.decode(result.replaceAll(RegExp(r"^0x"), ""));
  return HEX.decode(result);
}

/// Computes the address corresponding to the given private key
String address(String hexPrivateKey) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final privKeyPtr = Utf8.toUtf8(hexPrivateKey.replaceAll(r"^0x", ""));

  // The actual native call
  final resultPtr = bridge.computeAddress(privKeyPtr);

  return bridge.handleResultStringPointer(resultPtr);
}

// NOT YET IMPLEMENTED IN RUST
// Falling back to Dart

bool isValidPrivateKey(Uint8List privKey) =>
    fallback.isValidPrivateKey(privKey);
