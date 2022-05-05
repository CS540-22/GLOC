import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloc_ui/data/LanguageResult.dart';
import 'package:gloc_ui/widgets/HorizontalBarGraph.dart';

class LanguageCardList extends StatelessWidget {
  const LanguageCardList(this.languages, this.scrollFlag);

  final List<LanguageResult> languages;
  final bool scrollFlag;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Prevents this ListView from scrolling, it will instead scroll
      // with the outer ListView
      shrinkWrap: true,
      physics: (scrollFlag) ? null : NeverScrollableScrollPhysics(),
      itemCount: languages.length,
      itemBuilder: (BuildContext context, int index) {
        final data = languages[index];
        final totalLines = data.blank + data.code + data.comment;
        final icon = SvgPicture.asset(
          data.icon.path,
          width: 56.0,
          height: 56.0,
          color: (data.icon.recolorIcon) ? data.icon.colorPalette.first : null,
        );

        return Align(
          child: LimitedBox(
            maxWidth: 600.0,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600.0),
                    child: ListTile(
                      leading: icon,
                      title: Text(
                        data.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      subtitle: Text(
                        '$totalLines lines, ${data.files} files',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  HorizontalBarGraph(
                    [data.code, data.comment, data.blank],
                    [
                      data.icon.colorPalette[0],
                      data.icon.colorPalette[1],
                      data.icon.colorPalette[2]
                    ],
                    [
                      "Code (${data.code})",
                      "Comment (${data.comment})",
                      "Blank (${data.blank})"
                    ],
                  )
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
