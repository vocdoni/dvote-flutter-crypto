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
      _signature = "-";
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
      final start = DateTime.now();
      _randomMnemonic = generateMnemonic(192);
      _privateKey = computePrivateKey(MNEMONIC);

      _publicKey = computePublicKey(_privateKey);
      _address = computeAddress(_privateKey);

      _signature = signMessage(message, _privateKey);

      _duration = start.difference(DateTime.now()).abs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final encryptionData = '''Random Mnemonic:
$_randomMnemonic

Computed private key from "${MNEMONIC.substring(0, 15)}..."
$_privateKey

Public Key:
$_publicKey

Address:
$_address

Signing "$message" with the private key:
$_signature

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
