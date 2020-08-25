import 'package:ffi/ffi.dart';
import './native-bridge/index.dart' as bridge;

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

class Hashing {
  /// Generates a Poseidon Hash of the given hex payload and returns it encoded in Base64
  static String digestHexClaim(String claimData) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");
    final claimDataPtr = Utf8.toUtf8(claimData);

    // The actual native call
    final resultPtr = bridge.digestHexClaim(claimDataPtr);
    final hashStr = Utf8.fromUtf8(resultPtr);

    if (hashStr.startsWith("ERROR: ")) {
      final errMessage = "" + hashStr.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final hash = "" + hashStr;
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return hash;
  }

  /// Generates a Poseidon Hash of the given UTF8 string and returns it encoded in Base64
  static String digestStringClaim(String claimData) {
    if (bridge.nativeDvote == null)
      throw Exception("The library is not initialized");
    final claimDataPtr = Utf8.toUtf8(claimData);

    // The actual native call
    final resultPtr = bridge.digestStringClaim(claimDataPtr);
    final hashStr = Utf8.fromUtf8(resultPtr);

    if (hashStr.startsWith("ERROR: ")) {
      final errMessage = "" + hashStr.substring(7);
      // Free the string pointer
      bridge.freeCString(resultPtr);
      throw Exception(errMessage);
    }

    final hash = "" + hashStr;
    // Free the string pointer
    bridge.freeCString(resultPtr);
    return hash;
  }
}
