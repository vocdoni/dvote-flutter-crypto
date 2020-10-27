import 'package:flutter/material.dart';
import 'package:dvote_crypto/dvote_crypto.dart';

const PUBLIC_KEY =
    "0x045a126cbbd3c66b6d542d40d91085e3f2b5db3bbc8cda0d59615deb08784e4f833e0bb082194790143c3d01cedb4a9663cb8c7bdaaad839cb794dd309213fcf30";

class HashingScreen extends StatefulWidget {
  @override
  _HashingScreenState createState() => _HashingScreenState();
}

class _HashingScreenState extends State<HashingScreen> {
  String _hexHash = "-";
  String _error;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String hexHash;
    String error;

    try {
      hexHash = Hashing.digestHexClaim(PUBLIC_KEY);
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
      _hexHash = hexHash;
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

    final encryptionData = '''Original claim:
$PUBLIC_KEY\n
Poseidon Hash:
$_hexHash''';

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
