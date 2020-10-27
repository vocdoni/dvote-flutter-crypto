/////////////////////////////////////////////////////////////////////////////////////////
// The stubs below do not have a Dart implementation and throw an error when invoked.
/////////////////////////////////////////////////////////////////////////////////////////

// Hashing

/// Generates a Poseidon Hash of the given hex payload and returns it encoded in Base64
String hashPoseidonHex(String claimData) {
  throw UnimplementedError("Not available in Dart");
}

/// Generates a Poseidon Hash of the given UTF8 string and returns it encoded in Base64
String hashPoseidonString(String claimData) {
  throw UnimplementedError("Not available in Dart");
}

// ZK Snarks

/// Computes the Zero Knowledge Proof for the given set of inputs using the Proving Key located at the given path.
/// Returns a string containing the data to ben sent to a verifier.
String generateZkProof(
    Map<String, dynamic> circuitInputs, String provingKeyPath) {
  throw UnimplementedError("Not available in Dart");
}
