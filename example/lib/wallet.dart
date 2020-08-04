import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
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
  String _error;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String randomMnemonic, privateKey, publicKey, address, signature;
    String error;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      randomMnemonic = generateMnemonic(192);
      privateKey = computePrivateKey(MNEMONIC);
      publicKey = computePublicKey(privateKey);
      address = computeAddress(privateKey);

      signature = signMessage(message, privateKey);
    } on PlatformException catch (err) {
      error = err.message;
    } catch (err) {
      error = err;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (error != null) {
      setState(() {
        _error = error;
      });
      return;
    }

    setState(() {
      _randomMnemonic = randomMnemonic;
      _privateKey = privateKey;
      _publicKey = publicKey;
      _address = address;
      _signature = signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hashing'),
        ),
        body: Container(
          child: Text("Error: " + _error),
        ),
      );
    }

    final encryptionData = '''Random Mnemonic:
$_randomMnemonic

Computed private key from "${MNEMONIC.substring(0, 15)}..."
$_privateKey

Public Key:
$_publicKey

Address:
$_address

Signing "$message" with the private key:
$_signature''';

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
