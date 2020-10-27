import '../dart/stubs.dart' if (dart.library.io) '../native/hashing.dart';
// import '../native/hashing.dart';

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

class Hashing {
  /// Computes the Poseidon Hash of the given hex payload and returns it encoded in Base64
  static String digestHexClaim(String claimData) => hashPoseidonHex(claimData);

  /// Computes the Poseidon Hash of the given UTF8 string and returns it encoded in Base64
  static String digestStringClaim(String claimData) =>
      hashPoseidonString(claimData);
}
