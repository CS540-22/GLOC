import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:gloc_ui/data/LanguageIcon.dart';
import 'package:gloc_ui/data/LanguageResult.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;
  final _cardSpacing = 30.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RepoTitle(url: clocResult.giturl),
          SizedBox(height: _cardSpacing),
          _CodeCount(
              totalLines: clocResult.totalLines,
              totalCode: clocResult.totalCode,
              totalBlank: clocResult.totalBlank,
              totalComment: clocResult.totalComment),
          SizedBox(height: _cardSpacing),
          _LanguagePieChart(
            clocResult: clocResult,
          ),
        ],
      ),
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
          style: Theme.of(context).textTheme.titleSmall,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Row(children: [
            _buildBarSection(totalCode, Colors.red),
            _buildBarSection(totalComment, Colors.blue),
            _buildBarSection(totalBlank, Colors.green),
          ]),
        ),
      ],
    );
  }
}

class _LanguagePieChart extends StatefulWidget {
  const _LanguagePieChart({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;
  @override
  _LanguagePieChartState createState() => _LanguagePieChartState();
}

class _LanguagePieChartState extends State<_LanguagePieChart> {
  int touchedIndex = -1;
  late List<LanguageResult> graphLanguages;
  late ColorPalette graphColors;

  @override
  void initState() {
    super.initState();
    graphLanguages = generateGraphLanguages(widget.clocResult, .05);
    graphColors = ColorPalette.polyad(
      const HslColor(300, 100, 40),
      numberOfColors: graphLanguages.length,
      // hueVariability: 15,
      // saturationVariability: 10,
      // brightnessVariability: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: showingSections()),
      ),
    );
  }

  // combines smaller languages into an "other" language
  List<LanguageResult> generateGraphLanguages(
      ClocResult result, double threshold) {
    bool addOther = false;
    double remainingCode = 1.0;
    List<LanguageResult> graphLanguages = [];
    LanguageResult other = LanguageResult(
      name: 'Other',
      files: 0,
      blank: 0,
      comment: 0,
      code: 0,
      icon: LanguageIcon('Other'),
    );

    // check if remaining languages will create a slice lower than threshold
    for (var language in result.languages) {
      if (addOther ||
          threshold > remainingCode - (language.code / result.totalCode)) {
        other.files += language.files;
        other.blank += language.blank;
        other.comment += language.comment;
        other.code += language.code;
        addOther = true;
      } else {
        remainingCode -= language.code / result.totalCode;
        graphLanguages.add(language);
      }
    }

    // add other language slice if it contains languages
    if (other.files + other.blank + other.comment + other.code > 0) {
      graphLanguages.add(other);
    }

    return graphLanguages;
  }

  // generates pie chart data from graph languages
  List<PieChartSectionData> showingSections() {
    return List.generate(graphLanguages.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 120.0 : 100.0;
      return PieChartSectionData(
        color: graphColors[i],
        value: graphLanguages[i].code.toDouble(),
        title: graphLanguages[i].name,
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}
