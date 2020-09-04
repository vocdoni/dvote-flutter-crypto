import 'package:flutter/material.dart';
import 'package:dvote_native/dvote_native.dart';

const MESSAGE = "Hello word, I am a message encrypted with Rust";
const PASSPHRASE = "This is a very secure passphrase";

class EncryptionScreen extends StatefulWidget {
  @override
  _EncryptionScreenState createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  String _encrypted = "-";
  String _decrypted = "-";
  Duration _duration;
  String _error;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String encrypted, decrypted;
    DateTime start, end;
    String error;

    try {
      start = DateTime.now();
      encrypted = SymmetricEncryption.encrypt(MESSAGE, PASSPHRASE);
      decrypted = SymmetricEncryption.decrypt(encrypted, PASSPHRASE);
      end = DateTime.now();
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
      _encrypted = encrypted;
      _decrypted = decrypted;
      _duration = end.difference(start);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Encryption'),
        ),
        body: Container(
          child: Text("Error: " + _error),
        ),
      );
    }

    final encryptionData = '''Message:
$MESSAGE

Passphrase:
$PASSPHRASE

Encrypted data:
$_encrypted

Decrypted message:
$_decrypted

---

Computation took ${_duration.inMicroseconds}µs''';

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
