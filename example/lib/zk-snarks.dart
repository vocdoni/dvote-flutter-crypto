import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

import 'package:dvote_crypto/dvote_crypto.dart';

const CIRCUIT_INPUT_VALUES = {
  "privateKey":
      "3876493977147089964395646989418653640709890493868463039177063670701706079087",
  "votingId": "1",
  "nullifier":
      "18570357092029990534015153781798290815577397208925401637716365342267062658897",
  "censusRoot":
      "15628532949280720223077383407297400734969515772490239240715135787382227308157",
  "censusSiblings": [
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0"
  ],
  "censusIdx": "1337",
  "voteSigS":
      "2049495377478274326519165466593378972734554211375612654402604012080164390815",
  "voteSigR8x":
      "14670348391137384574095265741371426216865551653599272344433977096828239606867",
  "voteSigR8y":
      "14049142839519357696409855481674224186117305076655920589500172245054519140805",
  "voteValue": "2",
  "gcommitment": [
    "16508917144752610602145963506823743115557101240265470506805505298395529637033",
    "1891156797631087029347893674931101305929404954783323547727418062433377377293"
  ],
  "gnullifier": ["0", "0"]
};

class ZkProofsScreen extends StatefulWidget {
  @override
  _ZkProofsScreenState createState() => _ZkProofsScreenState();
}

class _ZkProofsScreenState extends State<ZkProofsScreen> {
  String _response = '(please, wait)';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
    final provingKey = await rootBundle.load('assets/proving.key');
    final provingKeyBytes = provingKey.buffer
        .asUint8List(provingKey.offsetInBytes, provingKey.lengthInBytes);

    final tempDir = await getTemporaryDirectory();
    final provingKeyPath = join(tempDir.path, "proving.key");
    await File(provingKeyPath).writeAsBytes(provingKeyBytes);

    // sync call
    try {
      final start = DateTime.now();
      final zkProof =
          Snarks.generateZkProof(CIRCUIT_INPUT_VALUES, provingKeyPath);
      final end = DateTime.now();

      final duration = end.difference(start);

      setState(() {
        _response =
            "$zkProof\n\nThe computation took ${duration.inMilliseconds} ms";
      });
    } catch (err) {
      setState(() {
        _response = "ERROR: " + err.toString();
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZK Snarks'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(
                  'ZK proof:\n\n$_response\n',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
