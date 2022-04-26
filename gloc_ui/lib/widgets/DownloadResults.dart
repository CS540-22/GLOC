import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocResult.dart';

class DownloadResults extends StatelessWidget {
  const DownloadResults({Key? key, required this.results}) : super(key: key);

  final List<ClocResult> results;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final content = base64Encode(jsonEncode(results).codeUnits);
          AnchorElement(
              href:
                  "data:application/octet-stream;charset=utf-16le;base64,$content")
            ..setAttribute("download", "results.json")
            ..click();
        },
        child: const Text("Download Results"));
  }
}
