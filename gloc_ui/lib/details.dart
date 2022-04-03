import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'models.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key? key,
    required this.clocResult,
  }) : super(key: key);

  final ClocResult clocResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 42.0,
              height: 42.0,
              child: DecoratedBox(
                decoration: BoxDecoration(color: clocResult.colorPalette[0]),
              ),
            ),
            SizedBox(
              width: 42.0,
              height: 42.0,
              child: DecoratedBox(
                decoration: BoxDecoration(color: clocResult.colorPalette[1]),
              ),
            ),
            SizedBox(
              width: 42.0,
              height: 42.0,
              child: DecoratedBox(
                decoration: BoxDecoration(color: clocResult.colorPalette[2]),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 500,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: clocResult.languages.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    SvgPicture.asset(
                      clocResult.languages[index].icon.path,
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: clocResult
                                .languages[index].icon.colorPalette[0]),
                      ),
                    ),
                    SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: clocResult
                                .languages[index].icon.colorPalette[1]),
                      ),
                    ),
                    SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: clocResult
                                .languages[index].icon.colorPalette[2]),
                      ),
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }
}
