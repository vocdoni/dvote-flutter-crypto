import 'package:ffi/ffi.dart';
import './native-bridge/index.dart' as bridge;

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

class SymmetricEncryption {
  /// Encrypts the given message with the given passphrase using SecretBox and returns a base64 encoded buffer containing `nonce[24] + cipherText[]`.
  /// The 24 first bytes represent the nonce, and the rest of the buffer contains the cipher text.
  /// The 16 first bytes of the cipher text (containing zeroes) are trimmed out
  static String encrypt(String message, String passphrase) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");
    final messagePtr = Utf8.toUtf8(message);
    final passphrasePtr = Utf8.toUtf8(passphrase);

    // The actual native call
    final resultPtr = bridge.encryptSymmetric(messagePtr, passphrasePtr);

    return bridge.handleResultStringPointer(resultPtr);
  }

  /// Decrypts the given base64 encoded buffer, containing `nonce[24] + cipherText[]` with the given passphrase using SecretBox
  static String decrypt(String b64CipherBytes, String passphrase) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");
    final b64CipherBytesPtr = Utf8.toUtf8(b64CipherBytes);
    final passphrasePtr = Utf8.toUtf8(passphrase);

    // The actual native call
    final resultPtr = bridge.decryptSymmetric(b64CipherBytesPtr, passphrasePtr);

    return bridge.handleResultStringPointer(resultPtr);
  }
}
