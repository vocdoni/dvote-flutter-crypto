import 'package:ffi/ffi.dart';
import './bridge.dart' as bridge;

// ////////////////////////////////////////////////////////////////////////////
// / IMPLEMENTATION
// ////////////////////////////////////////////////////////////////////////////

/// Generates a Poseidon Hash of the given hex payload and returns it encoded in Base64
String hashPoseidonHex(String claimData) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");
  final claimDataPtr = Utf8.toUtf8(claimData);

  // The actual native call
  final resultPtr = bridge.digestHexClaim(claimDataPtr);

  return bridge.handleResultStringPointer(resultPtr);
}

/// Generates a Poseidon Hash of the given UTF8 string and returns it encoded in Base64
String hashPoseidonString(String claimData) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");
  final claimDataPtr = Utf8.toUtf8(claimData);

  // The actual native call
  final resultPtr = bridge.digestStringClaim(claimDataPtr);

  return bridge.handleResultStringPointer(resultPtr);
}
