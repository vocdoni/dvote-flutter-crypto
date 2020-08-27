import 'package:flutter/material.dart';
import 'package:dvote_native/dvote_native.dart';

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
    setState(() {
      try {
        final start = DateTime.now();
        _randomMnemonic = Wallet.generateMnemonic(192);
        _privateKey = Wallet.computePrivateKey(MNEMONIC);

        _publicKey = Wallet.computePublicKey(_privateKey, uncompressed: false);
        String uncompressedPubKey =
            Wallet.computePublicKey(_privateKey, uncompressed: true);
        _address = Wallet.computeAddress(_privateKey);

        _signature = Wallet.sign(message, _privateKey);
        _recoveredPublicKey = Wallet.recoverSigner(_signature, message);
        _valid = Wallet.isValid(_signature, message, _publicKey);
        // Uncompressed should validate too
        assert(Wallet.isValid(_signature, message, uncompressedPubKey));

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
