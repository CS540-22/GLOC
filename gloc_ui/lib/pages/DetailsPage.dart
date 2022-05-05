import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:gloc_ui/widgets/DownloadResults.dart';
import 'package:gloc_ui/widgets/HorizontalBarGraph.dart';
import 'package:gloc_ui/widgets/LanguageCardList.dart';
import 'package:gloc_ui/widgets/RepoTitle.dart';

import '../widgets/LangaugePieChart.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;
  final _cardSpacing = 30.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue[50],
      child: LimitedBox(
        maxWidth: 400.0,
        child: ListView(
          children: [
            if (clocResult.giturl != null) RepoTitle(url: clocResult.giturl),
            SizedBox(height: _cardSpacing),
            _CodeCount(
                totalLines: clocResult.totalLines,
                totalCode: clocResult.totalCode,
                totalBlank: clocResult.totalBlank,
                totalComment: clocResult.totalComment),
            SizedBox(height: _cardSpacing * 2),
            // Double spacer to avoid overlapping
            LanguagePieChart(
              clocResult: clocResult,
            ),
            SizedBox(height: _cardSpacing * 2),
            DownloadResults(results: [clocResult]),
            SizedBox(height: _cardSpacing * 2),
            Expanded(child: LanguageCardList(clocResult.languages, false)),
            SizedBox(height: _cardSpacing * 2),
          ],
        ),
      ),
    );
  }
}

class _CodeCount extends StatelessWidget {
  const _CodeCount(
      {required this.totalLines,
      required this.totalCode,
      required this.totalBlank,
      required this.totalComment});

  final int totalLines, totalCode, totalBlank, totalComment;
  final double barHeight = 10.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$totalLines lines of code',
          textScaleFactor: 1.5,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        HorizontalBarGraph([
          totalLines,
          totalComment,
          totalBlank
        ], [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withAlpha(80),
          Theme.of(context).disabledColor
        ], [
          "Code (${totalLines})",
          "Comment (${totalComment})",
          "Blank (${totalBlank})"
        ])
      ],
    );
  }
}
