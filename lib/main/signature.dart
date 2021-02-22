// import 'dart:typed_data';
import 'dart:typed_data';

import 'package:dvote_crypto/util/asyncify.dart';

// import '../dart/signature.dart' if (dart.library.io) '../native/signature.dart'
//     as implementation;
import '../dart/signature.dart' as implementation;
// import '../native/signature.dart' as implementation;

// /////////////////////////////////////////////////////////////////////////////
// HANDLERS
// /////////////////////////////////////////////////////////////////////////////

class Signature {
  /// Sign the given payload using the private key and return a hex signature
  static String signString(String payload, String hexPrivateKey,
      {int chainId}) {
    return implementation.signString(payload, hexPrivateKey, chainId);
  }

  /// Sign the given payload using the private key and return a hex signature
  static Future<String> signStringAsync(String payload, String hexPrivateKey,
      {int chainId}) {
    return runAsync<String, String Function(String, String, int)>(
        implementation.signString, [payload, hexPrivateKey, chainId]);
  }

  /// Sign the given payload using the private key and return a hex signature
  static String signBytes(Uint8List payload, String hexPrivateKey,
      {int chainId}) {
    return implementation.signBytes(payload, hexPrivateKey, chainId);
  }

  /// Sign the given payload using the private key and return a hex signature
  static Future<String> signBytesAsync(Uint8List payload, String hexPrivateKey,
      {int chainId}) {
    return runAsync<String, String Function(Uint8List, String, int)>(
        implementation.signBytes, [payload, hexPrivateKey, chainId]);
  }

  /// Recover the public key that signed the given message into the given signature
  static String recoverSignerPubKey(String hexSignature, String strPayload,
      {int chainId, bool uncompressed = false}) {
    if (uncompressed)
      return implementation.recoverExpandedSignerPubKey(
          hexSignature, strPayload, chainId);
    return implementation.recoverSignerPubKey(
        hexSignature, strPayload, chainId);
  }

  /// Recover the public key that signed the given message into the given signature
  static Future<String> recoverSignerPubKeyAsync(
      String hexSignature, String strPayload,
      {int chainId, bool uncompressed = false}) {
    if (uncompressed)
      return runAsync<String, String Function(String, String, int)>(
          implementation.recoverExpandedSignerPubKey,
          [hexSignature, strPayload, chainId]);
    return runAsync<String, String Function(String, String, int)>(
        implementation.recoverSignerPubKey,
        [hexSignature, strPayload, chainId]);
  }

  /// Check whether the given signature is valid and belongs to the given message and
  /// public key
  static bool isValidSignature(
      String hexSignature, String strPayload, String hexPublicKey,
      {int chainId}) {
    return implementation.isValidSignature(
        hexSignature, strPayload, hexPublicKey, chainId);
  }

  /// Check whether the given signature is valid and belongs to the given message and
  /// public key
  static Future<bool> isValidSignatureAsync(
      String hexSignature, String strPayload, String hexPublicKey,
      {int chainId}) {
    return runAsync<bool, bool Function(String, String, String, int)>(
        implementation.isValidSignature,
        [hexSignature, strPayload, hexPublicKey, chainId]);
  }
}
