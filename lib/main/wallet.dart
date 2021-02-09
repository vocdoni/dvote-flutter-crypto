import 'dart:typed_data';
import 'package:dvote_crypto/main/signature.dart';

import '../constants.dart';
import 'package:dvote_crypto/util/asyncify.dart';
import 'package:bip39/bip39.dart' as bip39;
import "package:hex/hex.dart";

// import '../dart/wallet.dart' if (dart.library.io) '../native/wallet.dart'
//     as implementation;
import '../dart/wallet.dart' as implementation;
// import '../native/wallet.dart' as implementation;

// /////////////////////////////////////////////////////////////////////////////
// HANDLERS
// /////////////////////////////////////////////////////////////////////////////

/// Ethereum wallet allowing to manage cryptographic keys and derive deterministic identities for a given entity.
class EthereumWallet {
  final String mnemonic;
  final String hdPath;
  final Uint8List entityAddressHash; // HEX without 0x (may be null)

  /// Creates an Ethereum wallet for the given mnemonic, using the (optional) HD path.
  /// If an entityAddress is defined, the results private key, public key and address will
  /// be a unique derivation for the given entity that no one else will be able to correlate.
  EthereumWallet.fromMnemonic(this.mnemonic,
      {this.hdPath = DEFAULT_HD_PATH, this.entityAddressHash}) {
    if (!bip39.validateMnemonic(mnemonic))
      throw Exception("The provided mnemonic is not valid");
    else if (entityAddressHash is Uint8List && entityAddressHash.length != 32)
      throw Exception("Invalid address hash length");
  }

  /// Creates a new Ethereum wallet using a random mnemonic and the (optional) HD path.
  /// If an entityAddress is defined, the results private key, public key and address will
  /// be a unique derivation for the given entity that no one else will be able to correlate.
  EthereumWallet.random(
      {int size = 192,
      String hdPath = DEFAULT_HD_PATH,
      Uint8List entityAddressHash})
      : this.mnemonic = implementation.makeRandomMnemonic(size),
        this.hdPath = hdPath,
        this.entityAddressHash = entityAddressHash {
    if (entityAddressHash is Uint8List && entityAddressHash.length != 32)
      throw Exception("Invalid address hash length");
  }

  /// Creates a new Ethereum wallet using a random mnemonic and the (optional) HD path.
  /// If an entityAddress is defined, the results private key, public key and address will
  /// be a unique derivation for the given entity that no one else will be able to correlate.
  static Future<EthereumWallet> randomAsync(
      {int size = 192,
      String hdPath = DEFAULT_HD_PATH,
      Uint8List entityAddressHash}) async {
    final mnemonic = await runAsync<String, String Function(int)>(
        implementation.makeRandomMnemonic, [size]);

    return EthereumWallet.fromMnemonic(mnemonic,
        hdPath: hdPath, entityAddressHash: entityAddressHash);
  }

  /// Returns a byte array representation of the private key derived from the current mnemonic.
  /// If entityAddress is set, its bytes will be used to derive a new private key, unique to this entity.
  Uint8List get privateKeyBytes {
    final privKeyBytes = implementation.privateKeyBytes(mnemonic, hdPath);
    assert(privKeyBytes.length == 32, "Invalid private key length");
    assert(entityAddressHash is! Uint8List || entityAddressHash.length == 32,
        "Invalid entity address hash length");

    // XOR the 32 bytes of the generated private key using the entity address hash
    if (entityAddressHash is Uint8List) {
      for (int i = entityAddressHash.length - 1; i >= 0; i--) {
        privKeyBytes[i] = privKeyBytes[i] ^ entityAddressHash[i];
      }
      if (!implementation.isValidPrivateKey(privKeyBytes))
        throw Exception("The private key derived for the entity is not valid");
    }
    return privKeyBytes;
  }

  /// Returns a byte array representation of the private key derived from the current mnemonic.
  /// If entityAddress is set, its bytes will be used to derive a new private key, unique to this entity.
  Future<Uint8List> get privateKeyBytesAsync {
    return runAsync<Uint8List, Uint8List Function(String, String)>(
            implementation.privateKeyBytes, [mnemonic, hdPath])
        .then((privKeyBytes) {
      assert(privKeyBytes.length == 32, "Invalid private key length");
      assert(entityAddressHash is! Uint8List || entityAddressHash.length == 32,
          "Invalid entity address hash length");

      // XOR the 32 bytes of the generated private key using the entity address hash
      if (entityAddressHash is Uint8List) {
        for (int i = entityAddressHash.length - 1; i >= 0; i--) {
          privKeyBytes[i] = privKeyBytes[i] ^ entityAddressHash[i];
        }
        if (!implementation.isValidPrivateKey(privKeyBytes))
          throw Exception(
              "The private key derived for the entity is not valid");
      }
      return privKeyBytes;
    });
  }

  /// Returns an Hexadecimal representation of the private key
  /// derived from the current mnemonic
  String get privateKey {
    return "0x" + HEX.encode(privateKeyBytes);
  }

  /// Returns an Hexadecimal representation of the private key
  /// derived from the current mnemonic
  Future<String> get privateKeyAsync {
    return this
        .privateKeyBytesAsync
        .then((privKeyBytes) => "0x" + HEX.encode(privKeyBytes));
  }

  /// Returns a byte array representation of the public key
  /// derived from the current mnemonic
  Uint8List publicKeyBytes({bool uncompressed = false}) {
    return implementation.publicKeyBytes(this.privateKey, uncompressed);
  }

  /// Returns a byte array representation of the public key
  /// derived from the current mnemonic
  Future<Uint8List> publicKeyBytesAsync({bool uncompressed = false}) {
    return runAsync<Uint8List, Uint8List Function(String, bool)>(
        implementation.publicKeyBytes, [this.privateKey, uncompressed]);
  }

  /// Returns an Hexadecimal representation of the public key
  /// derived from the current mnemonic
  String publicKey({bool uncompressed = false}) {
    return "0x" + HEX.encode(this.publicKeyBytes(uncompressed: uncompressed));
  }

  /// Returns an Hexadecimal representation of the public key
  /// derived from the current mnemonic
  Future<String> publicKeyAsync({bool uncompressed = false}) {
    return this
        .publicKeyBytesAsync(uncompressed: uncompressed)
        .then((pubKeyBytes) => "0x" + HEX.encode(pubKeyBytes));
  }

  String get address {
    return implementation.address(this.privateKey);
  }

  Future<String> get addressAsync {
    return runAsync<String, String Function(String)>(
        implementation.address, [this.privateKey]);
  }

  /// Sign the given payload using the private key and return a hex signature
  String sign(String payload, {int chainId}) {
    return Signature.signString(payload, this.privateKey, chainId: chainId);
  }
}
