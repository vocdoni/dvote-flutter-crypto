import 'package:flutter/material.dart';
import 'package:dvote_crypto/dvote_crypto.dart';

const MNEMONIC =
    "coral imitate swim axis note super success public poem frown verify then";

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _randomMnemonic = "-",
      _privateKey = "-",
      _publicKey = "-",
      _address = "-",
      _signature = "-",
      _recoveredPublicKey = "-";
  bool _valid = false;
  String message = "hello";
  Duration _duration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final wallet1 = EthereumWallet.random(
      size: 192,
      // hdPath: "..."
      // entityAddressHash: "0x00000000..."
    );
    final wallet2 = await EthereumWallet.randomAsync(
      size: 192,
      // hdPath: "..."
      // entityAddressHash: "0x00000000..."
    );
    final wallet3 = EthereumWallet.fromMnemonic(MNEMONIC);

    setState(() {
      try {
        final start = DateTime.now();
        _randomMnemonic = wallet1.mnemonic;
        _privateKey = wallet1.privateKey;

        _publicKey = wallet1.publicKey(uncompressed: false);
        String uncompressedPubKey = wallet1.publicKey(uncompressed: true);
        _address = wallet1.address;

        _signature = wallet1.sign(message);
        _recoveredPublicKey =
            Signature.recoverSignerPubKey(_signature, message);
        _valid = Signature.isValidSignature(_signature, message, _publicKey);
        // Uncompressed should validate too
        assert(Signature.isValidSignature(
            _signature, message, uncompressedPubKey));

        _duration = start.difference(DateTime.now()).abs();
      } catch (err) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final encryptionData = '''Random Mnemonic:
$_randomMnemonic

---

Computed private key from "${MNEMONIC.substring(0, 15)}..."
$_privateKey

Public Key:
$_publicKey

Address:
$_address

---

Signing "$message" with the private key:
$_signature

Recovered public key:
$_recoveredPublicKey

Valid: $_valid

Duration:
${_duration.inMicroseconds / 1000} ms
''';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hashing'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(encryptionData),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
