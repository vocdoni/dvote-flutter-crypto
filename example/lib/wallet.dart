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
      _publicKeyUncompressed = "-",
      _address = "-";
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
        _publicKeyUncompressed = wallet1.publicKey(uncompressed: true);
        _address = wallet1.address;

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

Uncompressed:
$_publicKeyUncompressed

Address:
$_address

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
