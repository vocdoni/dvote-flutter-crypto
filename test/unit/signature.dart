import 'package:flutter_test/flutter_test.dart';
import 'package:dvote_crypto/dvote_crypto.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';

void signature() {
  syncSignature();
  asyncSignature();
  signingMatch();
}

void syncSignature() {
  test("Sign a plain string", () {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    String message = "hello";
    String signature = Signature.signString(message, wallet.privateKey);
    expect(signature,
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f7763181b");

    message = "àèìòù";
    signature = Signature.signString(message, wallet.privateKey);
    expect(signature,
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda811c");
  });

  // Received

  test("Recover the public key of signatures received externally", () {
    final originalPublicKey =
        "0x04d811f8ade566618a667715c637a7f3019f46ae0ffc8b2ec3b16b1f72999e2e2f9e9b50c78ca34175d78942de88798cce5d53569f96579a95ec9bab17c0131d4f";

    String message = "hello";
    String signature =
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f7763181b";
    String recoveredPubKey =
        Signature.recoverSignerPubKey(signature, message, uncompressed: true);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");

    message = "àèìòù";
    signature =
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda811c";
    recoveredPubKey =
        Signature.recoverSignerPubKey(signature, message, uncompressed: true);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");
  });

  test("Verify a signature received externally", () {
    final publicKey =
        "0x04d811f8ade566618a667715c637a7f3019f46ae0ffc8b2ec3b16b1f72999e2e2f9e9b50c78ca34175d78942de88798cce5d53569f96579a95ec9bab17c0131d4f";

    String message = "hello";
    String signature =
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f7763181b";
    bool valid = Signature.isValidSignature(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");

    message = "àèìòù";
    signature =
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda811c";
    valid = Signature.isValidSignature(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");
  });

  test("Verify a signature received externally with 'v' below 72", () {
    final publicKey =
        "0x04d811f8ade566618a667715c637a7f3019f46ae0ffc8b2ec3b16b1f72999e2e2f9e9b50c78ca34175d78942de88798cce5d53569f96579a95ec9bab17c0131d4f";

    String message = "hello";
    String signature =
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f77631800";
    bool valid = Signature.isValidSignature(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");

    message = "àèìòù";
    signature =
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda8101";
    valid = Signature.isValidSignature(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");
  });

  // Signed here

  test("Recover the public key of signatures generated locally", () {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    final originalPublicKey = wallet.publicKey(uncompressed: false);

    String message = "hello";
    String signature = Signature.signString(message, wallet.privateKey);
    String recoveredPubKey = Signature.recoverSignerPubKey(signature, message);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");

    message = "àèìòù";
    signature = Signature.signString(message, wallet.privateKey);
    recoveredPubKey = Signature.recoverSignerPubKey(signature, message);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");
  });

  test("Verify a signature generated locally", () {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    final expectedPublicKey = wallet.publicKey(uncompressed: false);

    String message = "hello";
    String signature = Signature.signString(message, wallet.privateKey);
    bool valid =
        Signature.isValidSignature(signature, message, expectedPublicKey);
    expect(valid, true, reason: "The signature should be valid");

    message = "àèìòù";
    signature = Signature.signString(message, wallet.privateKey);
    valid = Signature.isValidSignature(signature, message, expectedPublicKey);
    expect(valid, true, reason: "The signature should be valid");
  });
}

void asyncSignature() {
  // String

  test("Sign a plain string [async]", () async {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    String message = "hello";
    String signature =
        await Signature.signStringAsync(message, wallet.privateKey);
    expect(signature,
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f7763181b");

    message = "àèìòù";
    signature = await Signature.signStringAsync(message, wallet.privateKey);
    expect(signature,
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda811c");
  });

  // Received

  test("Recover the public key of signatures received externally [async]",
      () async {
    final originalPublicKey =
        "0x04d811f8ade566618a667715c637a7f3019f46ae0ffc8b2ec3b16b1f72999e2e2f9e9b50c78ca34175d78942de88798cce5d53569f96579a95ec9bab17c0131d4f";

    String message = "hello";
    String signature =
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f7763181b";
    String recoveredPubKey = await Signature.recoverSignerPubKeyAsync(
        signature, message,
        uncompressed: true);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");

    message = "àèìòù";
    signature =
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda811c";
    recoveredPubKey = await Signature.recoverSignerPubKeyAsync(
        signature, message,
        uncompressed: true);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");
  });

  test("Verify a signature received externally [async]", () async {
    final publicKey =
        "0x04d811f8ade566618a667715c637a7f3019f46ae0ffc8b2ec3b16b1f72999e2e2f9e9b50c78ca34175d78942de88798cce5d53569f96579a95ec9bab17c0131d4f";

    String message = "hello";
    String signature =
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f7763181b";
    bool valid =
        await Signature.isValidSignatureAsync(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");

    message = "àèìòù";
    signature =
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda811c";
    valid =
        await Signature.isValidSignatureAsync(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");
  });

  test("Verify a signature received externally with 'v' below 72 [async]",
      () async {
    final publicKey =
        "0x04d811f8ade566618a667715c637a7f3019f46ae0ffc8b2ec3b16b1f72999e2e2f9e9b50c78ca34175d78942de88798cce5d53569f96579a95ec9bab17c0131d4f";

    String message = "hello";
    String signature =
        "0x9d06b4f31641aba791bb79dfb211c1141c4b3e346f230c05256c657c5c10916229a8f4cee40bfdbe0d90061d60e712ec5ec0c59cb90321814848ec2f6f77631800";
    bool valid =
        await Signature.isValidSignatureAsync(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");

    message = "àèìòù";
    signature =
        "0x2cbf9ae0de3df7e975b68b4cf67e14a0b49a1f8ed5d54c6c13d2ff936585036232fb53846fd49331bf8832fcd7e4517c3f07c951b95d5e0e102e572bbbadda8101";
    valid =
        await Signature.isValidSignatureAsync(signature, message, publicKey);
    expect(valid, true, reason: "The signature should be valid");
  });

  // Signed here

  test("Recover the public key of signatures generated locally [async]",
      () async {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    final originalPublicKey = wallet.publicKey();

    String message = "hello";
    String signature =
        await Signature.signStringAsync(message, wallet.privateKey);
    String recoveredPubKey =
        await Signature.recoverSignerPubKeyAsync(signature, message);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");

    message = "àèìòù";
    signature = await Signature.signStringAsync(message, wallet.privateKey);
    recoveredPubKey =
        await Signature.recoverSignerPubKeyAsync(signature, message);
    expect(recoveredPubKey, originalPublicKey,
        reason: "The public key should match");
  });

  test("Verify a signature generated locally [async]", () async {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    final expectedPublicKey = wallet.publicKey(uncompressed: false);

    String message = "hello";
    String signature =
        await Signature.signStringAsync(message, wallet.privateKey);
    bool valid = await Signature.isValidSignatureAsync(
        signature, message, expectedPublicKey);
    expect(valid, true, reason: "The signature should be valid");

    message = "àèìòù";
    signature = await Signature.signStringAsync(message, wallet.privateKey);
    valid = await Signature.isValidSignatureAsync(
        signature, message, expectedPublicKey);
    expect(valid, true, reason: "The signature should be valid");
  });
}

void signingMatch() {
  test("Sync and async should match", () async {
    EthereumWallet wallet = EthereumWallet.fromMnemonic(
        'poverty castle step need baby chair measure leader dress print cruise baby avoid fee sock shoulder rate opinion');

    // Plain
    String message = "hello";
    String signature1 = Signature.signString(message, wallet.privateKey);
    String signature2 =
        await Signature.signStringAsync(message, wallet.privateKey);
    expect(signature1, signature2);

    String recoveredPubKey1 =
        Signature.recoverSignerPubKey(signature1, message);
    String recoveredPubKey2 =
        await Signature.recoverSignerPubKeyAsync(signature2, message);
    expect(recoveredPubKey1, recoveredPubKey2);

    bool isValid1 =
        Signature.isValidSignature(signature1, message, wallet.publicKey());
    bool isValid2 = await Signature.isValidSignatureAsync(
        signature2, message, wallet.publicKey());
    expect(isValid1, isValid2);

    // UTF-8
    message = "àèìòù";
    signature1 = Signature.signString(message, wallet.privateKey);
    signature2 = await Signature.signStringAsync(message, wallet.privateKey);
    expect(signature1, signature2);

    recoveredPubKey1 = Signature.recoverSignerPubKey(signature1, message);
    recoveredPubKey2 =
        await Signature.recoverSignerPubKeyAsync(signature2, message);
    expect(recoveredPubKey1, recoveredPubKey2);

    isValid1 =
        Signature.isValidSignature(signature1, message, wallet.publicKey());
    isValid2 = await Signature.isValidSignatureAsync(
        signature2, message, wallet.publicKey());
    expect(isValid1, isValid2);
  });
}
