import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:gloc_ui/data/LanguageResult.dart';

class HistoryLineChart extends StatefulWidget {
  HistoryLineChart({Key? key, required this.historyResult}) : super(key: key);

  final List<ClocResult> historyResult;

  @override
  State<StatefulWidget> createState() => HistoryLineChartState();
}

class HistoryLineChartState extends State<HistoryLineChart> {
  late List<LineChartBarData> languageBars;
  int maxCode = 0;

  @override
  void initState() {
    initializeLineChartData(widget.historyResult);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      sampleData,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  LineChartData get sampleData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: languageBars,
        minX: 0,
        maxX: widget.historyResult.length - 1.0,
        maxY: maxCode.toDouble(),
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Commit Date',
            style: TextStyle(
              color: Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          sideTitles: SideTitles(
            getTitlesWidget: bottomTitleWidgets,
            showTitles: true,
            interval: 1,
            reservedSize: 40,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
              getTitlesWidget: (double value, TitleMeta meta) => Container(),
              showTitles: true,
              reservedSize: 40),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text(
            'Lines of Code',
            style: TextStyle(
              color: Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          sideTitles: SideTitles(
            getTitlesWidget: leftTitleWidgets,
            showTitles: true,
            interval: (maxCode / 20).ceil().toDouble(),
            reservedSize: 50,
          ),
        ),
      );

  FlGridData get gridData => FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  Widget leftTitleWidgets(double code, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = code.toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    int index = value.toInt();
    if (index < widget.historyResult.length) {
      var datetime = widget.historyResult[index.toInt()].date!;
      text = Text(DateFormat('M-d-yy').format(datetime), style: style);
    } else {
      return Container();
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 10.0));
  }

  List<FlSpot> generateSpotsFromLanguageHistory(
      Map<int, LanguageResult> langHistory) {
    var newMap = langHistory
        .map((index, result) =>
            MapEntry(index, FlSpot(index.toDouble(), result.code.toDouble())))
        .values
        .toList();
    return newMap;
  }

  initializeLineChartData(List<ClocResult> history) {
    Map<String, Map<int, LanguageResult>> languageData = {};

    // loop through languages in each commit and add them to language map
    for (int i = 0; i < history.length; i++) {
      for (var language in history[i].languages) {
        // store max of all lines of code
        maxCode = max(maxCode, language.code);

        // insert or update if the language is already tracked
        if (languageData.containsKey(language.name)) {
          languageData[language.name]!.putIfAbsent(i, () => language);
        } else {
          languageData.putIfAbsent(language.name, () => {i: language});
        }
      }
    }

    ColorPalette barColors = ColorPalette.polyad(
      const HslColor(10, 100, 70),
      numberOfColors: languageData.length,
      // hueVariability: 15,
      // saturationVariability: 10,
      // brightnessVariability: 10,
    );

    languageBars = List.generate(languageData.length, (i) {
      String key = languageData.keys.elementAt(i);
      return LineChartBarData(
        isCurved: false,
        color: barColors[i],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: languageData[key]!
            .map((index, result) => MapEntry(
                index, FlSpot(index.toDouble(), result.code.toDouble())))
            .values
            .toList(),
      );
    });
  }
}
