// import 'dart:typed_data';
import 'package:dvote_crypto/util/asyncify.dart';

import '../dart/stubs.dart' if (dart.library.io) '../native/snarks.dart'
    as implementation;
// import '../native/snarks.dart' as implementation;

// /////////////////////////////////////////////////////////////////////////////
// HANDLERS
// /////////////////////////////////////////////////////////////////////////////

class Snarks {
  /// Computes the Zero Knowledge Proof for the given set of inputs using the Proving Key located at the given path.
  /// Returns a string containing the data to ben sent to a verifier.
  static String generateZkProof(
          Map<String, dynamic> circuitInputs, String provingKeyPath) =>
      implementation.generateZkProof(circuitInputs, provingKeyPath);

  /// Computes the Zero Knowledge Proof for the given set of inputs using the Proving Key located at the given path.
  /// Returns a string containing the data to ben sent to a verifier.
  static Future<String> generateZkProofAsync(
      Map<String, dynamic> circuitInputs, String provingKeyPath) {
    return runAsync<String, String Function(Map<String, dynamic>, String)>(
        implementation.generateZkProof, [circuitInputs, provingKeyPath]);
  }
}
