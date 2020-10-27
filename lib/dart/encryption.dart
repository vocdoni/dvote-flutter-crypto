import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart'; // To hash the passphrase to a fixed length
import 'package:pinenacl/secret.dart'
    show SecretBox, SealedBox, PrivateKey, PublicKey, EncryptedMessage;

// /////////////////////////////////////////////////////////////////////////////
// IMPLEMENTATION
// /////////////////////////////////////////////////////////////////////////////

/// Encrypts the given data using NaCl SecretBox and returns a Uint8List containing `nonce[24] + cipherText[]`.
/// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
Uint8List encryptSymmetricRaw(Uint8List buffer, String passphrase) {
  final key = utf8.encode(passphrase);
  final keyDigest =
      sha256.convert(key); // Hash the passphrase to get a 32 byte key
  final box = SecretBox(keyDigest.bytes);
  final encrypted = box.encrypt(buffer);

  return Uint8List.fromList(encrypted.toList());
}

/// Encrypts the given data using NaCl SecretBox and returns a Base64 string containing `nonce[24] + cipherText[]`.
/// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
String encryptSymmetricBytes(Uint8List buffer, String passphrase) {
  final encryptedBuffer = encryptSymmetricRaw(buffer, passphrase);
  return base64.encode(encryptedBuffer);
}

/// Encrypts the given string using NaCl SecretBox and returns a Base64 string containing `nonce[24] + cipherText[]`.
/// The 24 first bytes must contain the nonce, and the rest of the buffer needs to contain the cipher text.
String encryptSymmetricString(String message, String passphrase) {
  final messageBytes = Uint8List.fromList(utf8.encode(message));
  final encryptedBuffer = encryptSymmetricRaw(messageBytes, passphrase);

  return base64.encode(encryptedBuffer);
}

/// Decrypts a byte array containing `nonce[24] + cipherText[]` using NaCl SecretBox:
/// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
Uint8List decryptSymmetricRaw(Uint8List encryptedBuffer, String passphrase) {
  final key = utf8.encode(passphrase);
  final keyDigest =
      sha256.convert(key); // Hash the passphrase to get a 32 byte key
  final box = SecretBox(keyDigest.bytes);

  final encrypted = EncryptedMessage(
      cipherText: encryptedBuffer.sublist(24),
      nonce: encryptedBuffer.sublist(0, 24));
  return box.decrypt(encrypted);
}

/// Decrypts a byte array containing `nonce[24] + cipherText[]` using NaCl SecretBox:
/// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
Uint8List decryptSymmetricBytes(String encryptedBase64, String passphrase) {
  final encryptedBuffer = base64.decode(encryptedBase64);
  return decryptSymmetricRaw(encryptedBuffer, passphrase);
}

/// Decrypts a byte array containing `nonce[24] + cipherText[]` into a String using NaCl SecretBox:
/// https://github.com/ilap/pinenacl-dart#a-secret-key-encryption-example
String decryptSymmetricString(String encryptedBase64, String passphrase) {
  final encryptedBuffer = base64.decode(encryptedBase64);
  final strBytes = decryptSymmetricRaw(encryptedBuffer, passphrase);

  return utf8.decode(strBytes);
}

// Asymmetric

Uint8List encryptAsymmetricRaw(Uint8List bytesPayload, String hexPublicKey) {
  final pubKey = PublicKey(hex.decode(hexPublicKey));
  final sealedBox = SealedBox(pubKey);

  return sealedBox.encrypt(bytesPayload);
}

String encryptAsymmetricBytes(Uint8List bytesPayload, String hexPublicKey) {
  final pubKey = PublicKey(hex.decode(hexPublicKey));
  final sealedBox = SealedBox(pubKey);

  final encrypted = sealedBox.encrypt(bytesPayload);
  return base64.encode(encrypted);
}

String encryptAsymmetricString(String strPayload, String hexPublicKey) {
  final pubKey = PublicKey(hex.decode(hexPublicKey));
  final sealedBox = SealedBox(pubKey);

  final encrypted = sealedBox.encrypt(utf8.encode(strPayload));
  return base64.encode(encrypted);
}

Uint8List decryptAsymmetricRaw(Uint8List encryptedBytes, String hexPrivateKey) {
  final privKeyBytes = hex.decode(hexPrivateKey);
  final privKey = PrivateKey(privKeyBytes);

  final unsealedBox = SealedBox(privKey);
  return unsealedBox.decrypt(encryptedBytes);
}

Uint8List decryptAsymmetricBytes(String encryptedBase64, String hexPrivateKey) {
  final encryptedBytes = base64.decode(encryptedBase64);

  final privKeyBytes = hex.decode(hexPrivateKey);
  final privKey = PrivateKey(privKeyBytes);

  final unsealedBox = SealedBox(privKey);
  return unsealedBox.decrypt(encryptedBytes);
}

String decryptAsymmetricString(String encryptedBase64, String hexPrivateKey) {
  final encryptedBytes = base64.decode(encryptedBase64);

  final privKeyBytes = hex.decode(hexPrivateKey);
  final privKey = PrivateKey(privKeyBytes);

  final unsealedBox = SealedBox(privKey);

  final decrypted = unsealedBox.decrypt(encryptedBytes);
  return utf8.decode(decrypted);
}
