import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class HorizontalBarGraph extends StatelessWidget {
  const HorizontalBarGraph(this.values, this.colors, this.labels);

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
