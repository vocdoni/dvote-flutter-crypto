import 'package:flutter/material.dart';
import 'package:dvote_native/dvote_native.dart';

void main() => runApp(MyApp());

const PUBLIC_KEY =
    "0x045a126cbbd3c66b6d542d40d91085e3f2b5db3bbc8cda0d59615deb08784e4f833e0bb082194790143c3d01cedb4a9663cb8c7bdaaad839cb794dd309213fcf30";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _hash = '(Unknown)';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initPlatformState() {
    final hash = digestHexClaim(PUBLIC_KEY);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _hash = hash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DVote Native'),
        ),
        body: Center(
          child: Text('The Poseidon hash of\n$PUBLIC_KEY\n\nis\n\n$_hash\n'),
        ),
      ),
    );
  }
}
