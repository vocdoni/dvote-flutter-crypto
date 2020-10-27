import 'dart:typed_data';

import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import "package:hex/hex.dart";
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

import "../constants.dart";

// ////////////////////////////////////////////////////////////////////////////
// / IMPLEMENTATION
// ////////////////////////////////////////////////////////////////////////////

String makeRandomMnemonic(int size) {
  assert(size is int);
  return bip39.generateMnemonic(strength: size);
}

/// Returns a byte array representation of the private key
/// derived from the current mnemonic
Uint8List privateKeyBytes(String mnemonic, [String hdPath = DEFAULT_HD_PATH]) {
  final seed = bip39.mnemonicToSeedHex(mnemonic);
  final root = bip32.BIP32.fromSeed(HEX.decode(seed));
  final child = root.derivePath(hdPath);
  return child.privateKey;
}

/// Returns a byte array representation of the public key
/// derived from the current mnemonic
Uint8List publicKeyBytes(String hexPrivateKey, bool uncompressed) {
  final privKeyBigInt = hexToInt(hexPrivateKey);
  final pubKeyBytes = privateKeyToPublic(privKeyBigInt);

  List<int> result = List<int>();
  if (uncompressed) {
    result.add(4);
    result.addAll(pubKeyBytes);
    return Uint8List.fromList(result);
  }

  final xBytes = pubKeyBytes.sublist(0, 32);
  final ySign = pubKeyBytes[63];

  if (ySign & 0x01 == 0) {
    result.add(2);
    result.addAll(xBytes);
  } else {
    result.add(3);
    result.addAll(xBytes);
  }
  return Uint8List.fromList(result);
}

String address(String privateKey) {
  final privKeyBigInt = hexToInt(privateKey);
  final pubKeyBytes = privateKeyToPublic(privKeyBigInt);

  final addrBytes = publicKeyToAddress(pubKeyBytes);
  final addr = EthereumAddress(addrBytes);
  return addr.hexEip55;
}

bool isValidPrivateKey(Uint8List privKey) {
  if (privKey.length != 32)
    return false;
  else if (privKey.every((byte) => byte == 0x0)) return false;

  final maxInt = hexToInt(MAX_PRIV_KEY_VALUE);
  final privKeyInt = hexToInt(HEX.encode(privKey));
  return privKeyInt <= maxInt;
}
