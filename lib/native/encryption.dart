import 'package:ffi/ffi.dart';
import 'dart:typed_data';
import './bridge.dart' as bridge;
import '../dart/encryption.dart' as fallback;

// ////////////////////////////////////////////////////////////////////////////
// / IMPLEMENTATION
// ////////////////////////////////////////////////////////////////////////////

/// Encrypts the given message with the given passphrase using SecretBox and returns a base64 encoded buffer containing `nonce[24] + cipherText[]`.
/// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
/// The 16 first bytes of the cipher text (containing zeroes) are trimmed out
String encryptSymmetricString(String message, String passphrase) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");
  final messagePtr = Utf8.toUtf8(message);
  final passphrasePtr = Utf8.toUtf8(passphrase);

  // The actual native call
  final resultPtr = bridge.encryptSymmetric(messagePtr, passphrasePtr);

  return bridge.handleResultStringPointer(resultPtr);
}

/// Decrypts the given base64 encoded buffer, containing `nonce[24] + cipherText[]` with the given passphrase using SecretBox
String decryptSymmetricString(String b64CipherBytes, String passphrase) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");
  final b64CipherBytesPtr = Utf8.toUtf8(b64CipherBytes);
  final passphrasePtr = Utf8.toUtf8(passphrase);

  // The actual native call
  final resultPtr = bridge.decryptSymmetric(b64CipherBytesPtr, passphrasePtr);

  return bridge.handleResultStringPointer(resultPtr);
}

// NOT YET IMPLEMENTED WITH BUFFERS IN RUST
// Falling back to Dart

Uint8List encryptSymmetricRaw(Uint8List buffer, String passphrase) =>
    fallback.encryptSymmetricRaw(buffer, passphrase);

String encryptSymmetricBytes(Uint8List buffer, String passphrase) =>
    fallback.encryptSymmetricBytes(buffer, passphrase);

Uint8List decryptSymmetricRaw(Uint8List encryptedBuffer, String passphrase) =>
    fallback.decryptSymmetricRaw(encryptedBuffer, passphrase);

Uint8List decryptSymmetricBytes(String encryptedBase64, String passphrase) =>
    fallback.decryptSymmetricBytes(encryptedBase64, passphrase);

Uint8List encryptAsymmetricRaw(Uint8List bytesPayload, String hexPublicKey) =>
    fallback.encryptAsymmetricRaw(bytesPayload, hexPublicKey);

String encryptAsymmetricBytes(Uint8List bytesPayload, String hexPublicKey) =>
    fallback.encryptAsymmetricBytes(bytesPayload, hexPublicKey);

String encryptAsymmetricString(String strPayload, String hexPublicKey) =>
    fallback.encryptAsymmetricString(strPayload, hexPublicKey);

Uint8List decryptAsymmetricRaw(
        Uint8List encryptedBytes, String hexPrivateKey) =>
    fallback.decryptAsymmetricRaw(encryptedBytes, hexPrivateKey);

Uint8List decryptAsymmetricBytes(
        String encryptedBase64, String hexPrivateKey) =>
    fallback.decryptAsymmetricBytes(encryptedBase64, hexPrivateKey);

String decryptAsymmetricString(String encryptedBase64, String hexPrivateKey) =>
    fallback.decryptAsymmetricString(encryptedBase64, hexPrivateKey);
