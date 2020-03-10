import 'package:flutter/material.dart';

import "./zk-snarks.dart";
import "./hashing.dart";

void main() async {
  runApp(MaterialApp(
    title: 'DVote Flutter Native',
    home: ExampleApp(),
  ));
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DVote Flutter Native'),
      ),
      body: ListView(
        children: <Widget>[
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
        ],
      ),
    );
  }
}
