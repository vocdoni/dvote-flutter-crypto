import 'package:flutter/material.dart';
import 'package:dvote_crypto/dvote_crypto.dart';

const MNEMONIC =
    "coral imitate swim axis note super success public poem frown verify then";

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  String _signature = "-", _recoveredPublicKey = "-";
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
    final wallet = EthereumWallet.fromMnemonic(MNEMONIC);

    setState(() {
      try {
        final start = DateTime.now();

        _signature = wallet.sign(message);
        _recoveredPublicKey =
            Signature.recoverSignerPubKey(_signature, message);

        _valid = Signature.isValidSignature(
            _signature, message, wallet.publicKey(uncompressed: false));

        _duration = start.difference(DateTime.now()).abs();
      } catch (err) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final encryptionData = '''Random Mnemonic:

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
