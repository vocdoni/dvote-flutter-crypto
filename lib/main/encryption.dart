import 'dart:typed_data';
import 'package:dvote_crypto/util/asyncify.dart';

// import '../dart/encryption.dart'
//     if (dart.library.io) '../native/encryption.dart' as implementation;
import '../dart/encryption.dart' as implementation;
// import '../native/encryption.dart' as implementation;

// All of the methods below provide two versions, a sync and an async one.
// Async versions allow to detach heavy computations from the UI thread.
// Both versions invoke the same helper functions at the bottom.

// /////////////////////////////////////////////////////////////////////////////
// HANDLERS
// /////////////////////////////////////////////////////////////////////////////

class Symmetric {
  /// Encrypts the given data using NaCl SecretBox and returns a Uint8List containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
  static Uint8List encryptRaw(Uint8List buffer, String passphrase) {
    return implementation.encryptSymmetricRaw(buffer, passphrase);
  }

  /// Encrypts the given data using NaCl SecretBox and returns a Uint8List Future containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
  static Future<Uint8List> encryptRawAsync(
      Uint8List buffer, String passphrase) {
    return runAsync<Uint8List, Uint8List Function(Uint8List, String)>(
        implementation.encryptSymmetricRaw, [buffer, passphrase]);
  }

  /// Encrypts the given data using NaCl SecretBox and returns a Base64 string containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
  static String encryptBytes(Uint8List buffer, String passphrase) {
    return implementation.encryptSymmetricBytes(buffer, passphrase);
  }

  /// Encrypts the given data using NaCl SecretBox and returns a Base64 string Future containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
  static Future<String> encryptBytesAsync(Uint8List buffer, String passphrase) {
    return runAsync<String, String Function(Uint8List, String)>(
        implementation.encryptSymmetricBytes, [buffer, passphrase]);
  }

  /// Encrypts the given string using NaCl SecretBox and returns a Base64 string containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes must contain the nonce, and the rest of the buffer needs to contain the cipher text.
  static String encryptString(String message, String passphrase) {
    return implementation.encryptSymmetricString(message, passphrase);
  }

  /// Encrypts the given string using NaCl SecretBox and returns a Base64 string Future containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes must contain the nonce, and the rest of the buffer needs to contain the cipher text.
  static Future<String> encryptStringAsync(String message, String passphrase) {
    return runAsync<String, String Function(String, String)>(
        implementation.encryptSymmetricString, [message, passphrase]);
  }

  /// Decrypts a byte array containing `nonce[24] + cipherText[]` using NaCl SecretBox:
  /// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
  static Uint8List decryptRaw(Uint8List encryptedBuffer, String passphrase) {
    return implementation.decryptSymmetricRaw(encryptedBuffer, passphrase);
  }

  /// Decrypts a byte array containing `nonce[24] + cipherText[]` using NaCl SecretBox:
  /// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
  static Future<Uint8List> decryptRawAsync(
      Uint8List encryptedBuffer, String passphrase) {
    return runAsync<Uint8List, Uint8List Function(Uint8List, String)>(
        implementation.decryptSymmetricRaw, [encryptedBuffer, passphrase]);
  }

  /// Decrypts a byte array containing `nonce[24] + cipherText[]` using NaCl SecretBox:
  /// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
  static Uint8List decryptBytes(String encryptedBase64, String passphrase) {
    return implementation.decryptSymmetricBytes(encryptedBase64, passphrase);
  }

  /// Decrypts a byte array containing `nonce[24] + cipherText[]` using NaCl SecretBox:
  /// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
  static Future<Uint8List> decryptBytesAsync(
      String encryptedBase64, String passphrase) {
    return runAsync<Uint8List, Uint8List Function(String, String)>(
        implementation.decryptSymmetricBytes, [encryptedBase64, passphrase]);
  }

  /// Decrypts a byte array containing `nonce[24] + cipherText[]` into a String using NaCl SecretBox:
  /// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
  static String decryptString(String encryptedBase64, String passphrase) {
    return implementation.decryptSymmetricString(encryptedBase64, passphrase);
  }

  /// Decrypts a byte array containing `nonce[24] + cipherText[]` into a String Future using NaCl SecretBox:
  /// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
  static Future<String> decryptStringAsync(
      String encryptedBase64, String passphrase) {
    return runAsync<String, String Function(String, String)>(
        implementation.decryptSymmetricString, [encryptedBase64, passphrase]);
  }
}

class Asymmetric {
  /// Encrypts the given buffer using hexPublicKey and returns the resulting buffer
  static Uint8List encryptRaw(Uint8List payload, String hexPublicKey) {
    return implementation.encryptAsymmetricRaw(payload, hexPublicKey);
  }

  /// Encrypts the given buffer using hexPublicKey and returns the resulting buffer
  static Future<Uint8List> encryptRawAsync(
      Uint8List payload, String hexPublicKey) {
    return runAsync<Uint8List, Uint8List Function(Uint8List, String)>(
        implementation.encryptAsymmetricRaw, [payload, hexPublicKey]);
  }

  /// Encrypts the given buffer using hexPublicKey and returns a base64 string with the result
  static String encryptBytes(Uint8List payload, String hexPublicKey) {
    return implementation.encryptAsymmetricBytes(payload, hexPublicKey);
  }

  /// Encrypts the given buffer using hexPublicKey and returns a base64 string with the result
  static Future<String> encryptBytesAsync(
      Uint8List payload, String hexPublicKey) {
    return runAsync<String, String Function(Uint8List, String)>(
        implementation.encryptAsymmetricBytes, [payload, hexPublicKey]);
  }

  /// Encrypts the given string using hexPublicKey and returns a base64 string with the result
  static String encryptString(String message, String hexPublicKey) {
    return implementation.encryptAsymmetricString(message, hexPublicKey);
  }

  /// Encrypts the given string using hexPublicKey and returns a base64 string with the result
  static Future<String> encryptStringAsync(
      String message, String hexPublicKey) {
    return runAsync<String, String Function(String, String)>(
        implementation.encryptAsymmetricString, [message, hexPublicKey]);
  }

  /// Decrypts the given buffer using hexPublicKey and returns the resulting buffer
  static Uint8List decryptRaw(Uint8List encryptedBuffer, String hexPrivateKey) {
    return implementation.decryptAsymmetricRaw(encryptedBuffer, hexPrivateKey);
  }

  /// Decrypts the given buffer using hexPublicKey and returns the resulting buffer
  static Future<Uint8List> decryptRawAsync(
      Uint8List encryptedBuffer, String hexPrivateKey) {
    return runAsync<Uint8List, Uint8List Function(Uint8List, String)>(
        implementation.decryptAsymmetricRaw, [encryptedBuffer, hexPrivateKey]);
  }

  /// Decrypts the given base64 string using hexPublicKey and returns the original buffer
  static Uint8List decryptBytes(String encryptedBase64, String hexPrivateKey) {
    return implementation.decryptAsymmetricBytes(
        encryptedBase64, hexPrivateKey);
  }

  /// Decrypts the given base64 string using hexPublicKey and returns the original buffer
  static Future<Uint8List> decryptBytesAsync(
      String encryptedBase64, String hexPrivateKey) {
    return runAsync<Uint8List, Uint8List Function(String, String)>(
        implementation.decryptAsymmetricBytes,
        [encryptedBase64, hexPrivateKey]);
  }

  /// Decrypts the given base64 string using hexPublicKey and returns the original string
  static String decryptString(String encryptedBase64, String hexPrivateKey) {
    return implementation.decryptAsymmetricString(
        encryptedBase64, hexPrivateKey);
  }

  /// Decrypts the given base64 string using hexPublicKey and returns the original string
  static Future<String> decryptStringAsync(
      String encryptedBase64, String hexPrivateKey) {
    return runAsync<String, String Function(String, String)>(
        implementation.decryptAsymmetricString,
        [encryptedBase64, hexPrivateKey]);
  }
}
