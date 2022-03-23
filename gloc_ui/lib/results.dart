import 'dart:math';

import 'package:flutter/material.dart';
import 'models.dart';
import 'utilities.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsScreen extends StatefulWidget {
  final ClocRequest request;
  const ResultsScreen({Key? key, required this.request}) : super(key: key);

  @override
  ResultsScreenState createState() => ResultsScreenState();
}

class ResultsScreenState extends State<ResultsScreen> {
  late Future<ClocResult> futureClocResult;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    futureClocResult = sendClocRequest(widget.request);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GLOC'),
        ),
        body: Center(
          child: FutureBuilder<ClocResult>(
            future: futureClocResult,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: generatePieChartSections(
                          snapshot.data!, touchedIndex)),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

List<PieChartSectionData> generatePieChartSections(
    ClocResult result, int touchedIndex) {
  return List.generate(result.languages.length, (i) {
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 120.0 : 100.0;
    return PieChartSectionData(
      //todo generate sample of all 18 that wraps or better way to do random colors
      color: Colors.primaries[i % Colors.primaries.length],
      // color: Color((Random(i * 3).nextDouble() * 0xFFFFFF).toInt())
      //     .withOpacity(1.0),
      value: result.languages[i].code.toDouble(),
      title: result.languages[i].name,
      radius: radius,
      titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    );
  });
}
