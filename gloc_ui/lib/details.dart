import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloc_ui/utilities.dart';
import 'models.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;
  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  int touchedIndex = -1;
  late List<LanguageResult> graphLanguages;
  late ColorPalette graphColors;
  var names = languageImages.keys.toList();
  var paths = languageImages.values.toList();
  var colors = languageColors.values.toList();

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
    return Material(
        child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 42.0,
              height: 42.0,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: widget.clocResult.colorPalette[0]),
              ),
            ),
            SizedBox(
              width: 42.0,
              height: 42.0,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: widget.clocResult.colorPalette[1]),
              ),
            ),
            SizedBox(
              width: 42.0,
              height: 42.0,
              child: DecoratedBox(
                decoration:
                    BoxDecoration(color: widget.clocResult.colorPalette[2]),
              ),
            ),
          ],
        ),
        SizedBox(
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
        ),
        SizedBox(
          height: 400,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: languageImages.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Text(names[index]),
                    SvgPicture.asset(
                      'icons/' + paths[index],
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: LangIcon(names[index]).colorPalette[0]),
                      ),
                    ),
                    SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: LangIcon(names[index]).colorPalette[1]),
                      ),
                    ),
                    SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: LangIcon(names[index]).colorPalette[2]),
                      ),
                    ),
                  ],
                );
                // return Row(
                //   children: [
                //     Text(widget.clocResult.languages[index].name),
                //     SvgPicture.asset(
                //       widget.clocResult.languages[index].icon.path,
                //       width: 100,
                //       height: 100,
                //     ),
                //     SizedBox(
                //       width: 42.0,
                //       height: 42.0,
                //       child: DecoratedBox(
                //         decoration: BoxDecoration(
                //             color: widget.clocResult.languages[index].icon
                //                 .colorPalette[0]),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 42.0,
                //       height: 42.0,
                //       child: DecoratedBox(
                //         decoration: BoxDecoration(
                //             color: widget.clocResult.languages[index].icon
                //                 .colorPalette[1]),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 42.0,
                //       height: 42.0,
                //       child: DecoratedBox(
                //         decoration: BoxDecoration(
                //             color: widget.clocResult.languages[index].icon
                //                 .colorPalette[2]),
                //       ),
                //     ),
                //   ],
                // );
              }),
        )
      ],
    ));
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
      icon: LangIcon('Other'),
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
