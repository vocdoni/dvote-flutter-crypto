import 'dart:convert';
import 'package:ffi/ffi.dart';
import './bridge.dart' as bridge;

// ////////////////////////////////////////////////////////////////////////////
// / IMPLEMENTATION
// ////////////////////////////////////////////////////////////////////////////

/// Computes the Zero Knowledge Proof for the given set of inputs using the Proving Key located at the given path.
/// Returns a string containing the data to ben sent to a verifier.
String generateZkProof(
    Map<String, dynamic> circuitInputs, String provingKeyPath) {
  if (bridge.nativeDvote == null)
    throw Exception("The library is not initialized");

  final strProvingKeyPath = Utf8.toUtf8(provingKeyPath);

  final strInputs = jsonEncode(circuitInputs);
  final strInputsParam = Utf8.toUtf8(strInputs);

  // The actual native call
  final resultPtr = bridge.generateZkProof(strProvingKeyPath, strInputsParam);

  return bridge.handleResultStringPointer(resultPtr);
}
