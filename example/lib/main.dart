import 'package:dvote_crypto_example/signature.dart';
import 'package:flutter/material.dart';

import "./encryption.dart";
import "./hashing.dart";
import './wallet.dart';
import "./zk-snarks.dart";

void main() async {
  runApp(MaterialApp(
    title: 'DVote Flutter Crypto',
    home: ExampleApp(),
  ));
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DVote Flutter Crypto'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Wallet'),
              subtitle: Text('Generating wallets and computing keys'),
              isThreeLine: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WalletScreen())),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Signature'),
              subtitle: Text('Computing and verifying signatures'),
              isThreeLine: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignatureScreen())),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Hashing'),
              subtitle: Text(
                  'Generating hashes that are efficient to use on a ZK circuit'),
              isThreeLine: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HashingScreen())),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Encryption'),
              subtitle:
                  Text('Encrypting and decrypting strings using SecretBox'),
              isThreeLine: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EncryptionScreen())),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('ZK Snarks'),
              subtitle:
                  Text('Generating zero knowledge proofs given some inputs'),
              isThreeLine: true,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ZkProofsScreen())),
            ),
          ),
        ],
      ),
    );
  }
}
