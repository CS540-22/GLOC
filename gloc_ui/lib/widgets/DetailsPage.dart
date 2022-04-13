import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:collection/collection.dart';

import '../data/LanguageResult.dart';
import 'LangaugePieChart.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;
  final _cardSpacing = 30.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _RepoTitle(url: clocResult.giturl),
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
        Expanded(child: _LanguageCardList(clocResult.languages)),
      ],
    );
  }
}

class _RepoTitle extends StatelessWidget {
  const _RepoTitle({
    required this.url,
  });

  final Uri? url;

  @override
  Widget build(BuildContext context) {
    final String nameString = url?.pathSegments.last ?? "Your Repository";
    final String urlString = url?.toString() ?? "Unknown URL";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(nameString, style: Theme.of(context).textTheme.displaySmall),
        Text(urlString, style: Theme.of(context).textTheme.headlineSmall),
      ],
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

  Widget _buildBarSection(int count, Color color) {
    return Expanded(
      flex: ((count / totalLines) * 100.0).round(),
      child: Container(
        height: barHeight,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$totalLines lines of code',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _HorizontalBarGraph([
          totalLines,
          totalComment,
          totalBlank
        ], [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withAlpha(80),
          Theme.of(context).disabledColor
        ], [
          'Code',
          'Comment',
          'Blank'
        ])
      ],
    );
  }
}

class _LanguageCardList extends StatelessWidget {
  const _LanguageCardList(this.languages);

  final List<LanguageResult> languages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: languages.length,
      itemBuilder: (BuildContext context, int index) {
        final data = languages[index];
        final totalLines = data.blank + data.code + data.comment;
        final icon = SvgPicture.asset(
          data.icon.path,
          width: 56.0,
          height: 56.0,
        );

        return Card(
            child: Column(children: [
          ListTile(
            leading: icon,
            title: Text(
              data.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            subtitle: Text(
              '$totalLines lines, ${data.files} files',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ]));
      },
    );
  }
}

class _HorizontalBarGraph extends StatelessWidget {
  const _HorizontalBarGraph(this.values, this.colors, this.labels);

  final List<int> values;
  final List<Color> colors;
  final List<String> labels;
  final double barHeight = 10.0;

  Widget _buildBarSection(int count, Color color) {
    return Expanded(
      flex: ((count / values.sum) * 100.0).round(),
      child: Container(
        height: barHeight,
        color: color,
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 5.0),
        Text(text, style: Theme.of(context).textTheme.titleSmall)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[];
    final legend = <Widget>[];
    values.forEachIndexed((index, value) {
      sections.add(_buildBarSection(value, colors[index]));
      legend.add(_buildLabel(context, labels[index], colors[index]));
    });

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Column(children: [
        Row(children: sections),
        SizedBox(height: 5.0),
        Row(
          children: legend,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ]),
    );
  }
}
