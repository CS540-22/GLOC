import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocResult.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
    required this.historyResult,
  }) : super(key: key);

  final List<ClocResult> historyResult;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('History'));
  }
}
