import 'dart:convert';
import 'package:gloc_ui/widgets/DownloadResults.dart';
import 'package:gloc_ui/widgets/HistoryLineChart.dart';
import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:gloc_ui/widgets/LanguageCardList.dart';
import 'package:gloc_ui/widgets/RepoTitle.dart';

List<ClocResult> mockHistoryResult() {
  String jsonString =
      '[{"Bourne Shell":{"blank":1,"code":4,"comment":0,"nFiles":1},"Dockerfile":{"blank":0,"code":5,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"JSON":{"blank":0,"code":74,"comment":0,"nFiles":2},"Markdown":{"blank":13,"code":53,"comment":0,"nFiles":2},"SUM":{"blank":36,"code":360,"comment":19,"nFiles":14},"YAML":{"blank":16,"code":187,"comment":19,"nFiles":7},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"5b105a28fdd7786b64da4a37aa04df84696577f5","date":1648009680,"elapsed_seconds":0.0374619960784912,"files_per_second":373.71206730861,"lines_per_second":11077.8934237909,"n_files":14,"n_lines":415}},{"Bourne Shell":{"blank":1,"code":4,"comment":0,"nFiles":1},"Dockerfile":{"blank":0,"code":5,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"JSON":{"blank":0,"code":74,"comment":0,"nFiles":2},"Markdown":{"blank":13,"code":53,"comment":0,"nFiles":2},"SUM":{"blank":36,"code":361,"comment":19,"nFiles":14},"YAML":{"blank":16,"code":188,"comment":19,"nFiles":7},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"49e6ab9ec8110ac10a7ad359946a097f8da46025","date":1648042177,"elapsed_seconds":0.0371389389038086,"files_per_second":376.962843129702,"lines_per_second":11201.1816244254,"n_files":14,"n_lines":416}},{"Bourne Shell":{"blank":1,"code":4,"comment":0,"nFiles":1},"Dockerfile":{"blank":0,"code":5,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"JSON":{"blank":0,"code":74,"comment":0,"nFiles":2},"Markdown":{"blank":13,"code":53,"comment":0,"nFiles":2},"SUM":{"blank":36,"code":362,"comment":19,"nFiles":14},"YAML":{"blank":16,"code":189,"comment":19,"nFiles":7},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"127300bf5c8876578b3b53c7089d09d3a7081da9","date":1648043535,"elapsed_seconds":0.0367341041564941,"files_per_second":381.117229383283,"lines_per_second":11351.8489037735,"n_files":14,"n_lines":417}},{"Bourne Shell":{"blank":1,"code":4,"comment":0,"nFiles":1},"Dockerfile":{"blank":0,"code":5,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"JSON":{"blank":0,"code":74,"comment":0,"nFiles":2},"Markdown":{"blank":13,"code":53,"comment":0,"nFiles":2},"SUM":{"blank":36,"code":366,"comment":19,"nFiles":14},"YAML":{"blank":16,"code":193,"comment":19,"nFiles":7},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"041b66ad11b8f8a75e2a857696d090454d673b5f","date":1648045071,"elapsed_seconds":0.0902130603790283,"files_per_second":155.18817276766,"lines_per_second":4666.73005251321,"n_files":14,"n_lines":421}},{"Bourne Shell":{"blank":1,"code":2,"comment":0,"nFiles":1},"Dockerfile":{"blank":8,"code":9,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"JSON":{"blank":0,"code":74,"comment":0,"nFiles":2},"Markdown":{"blank":24,"code":82,"comment":0,"nFiles":3},"Python":{"blank":42,"code":100,"comment":22,"nFiles":3},"SUM":{"blank":94,"code":500,"comment":41,"nFiles":18},"YAML":{"blank":13,"code":196,"comment":19,"nFiles":7},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"96140ab049952ced075839c651ebf7b2fe252bdb","date":1649097237,"elapsed_seconds":0.094688892364502,"files_per_second":190.096214566642,"lines_per_second":6706.17201387875,"n_files":18,"n_lines":635}},{"Bourne Shell":{"blank":1,"code":2,"comment":0,"nFiles":1},"Dart":{"blank":33,"code":204,"comment":21,"nFiles":6},"Dockerfile":{"blank":8,"code":9,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"HTML":{"blank":6,"code":26,"comment":13,"nFiles":1},"JSON":{"blank":0,"code":97,"comment":0,"nFiles":3},"Markdown":{"blank":30,"code":92,"comment":0,"nFiles":4},"Python":{"blank":42,"code":100,"comment":22,"nFiles":3},"SUM":{"blank":160,"code":808,"comment":136,"nFiles":29},"YAML":{"blank":34,"code":241,"comment":80,"nFiles":9},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"d453611bc3204ca86cc659462dbbc5f117289b29","date":1649339244,"elapsed_seconds":0.115437984466553,"files_per_second":251.21713735744,"lines_per_second":9563.57653940047,"n_files":29,"n_lines":1104}},{"Bourne Shell":{"blank":1,"code":2,"comment":0,"nFiles":1},"Dart":{"blank":33,"code":204,"comment":21,"nFiles":6},"Dockerfile":{"blank":8,"code":9,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"HTML":{"blank":6,"code":26,"comment":13,"nFiles":1},"JSON":{"blank":0,"code":97,"comment":0,"nFiles":3},"Markdown":{"blank":30,"code":92,"comment":0,"nFiles":4},"Python":{"blank":42,"code":100,"comment":22,"nFiles":3},"SUM":{"blank":160,"code":810,"comment":136,"nFiles":29},"YAML":{"blank":34,"code":243,"comment":80,"nFiles":9},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"119d49cfb25762a04781f64a5b082599383e443b","date":1649351427,"elapsed_seconds":0.122224092483521,"files_per_second":237.269096548294,"lines_per_second":9048.95244077285,"n_files":29,"n_lines":1106}},{"Bourne Shell":{"blank":1,"code":2,"comment":0,"nFiles":1},"Dart":{"blank":38,"code":490,"comment":22,"nFiles":8},"Dockerfile":{"blank":10,"code":11,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"HTML":{"blank":6,"code":26,"comment":13,"nFiles":1},"JSON":{"blank":0,"code":97,"comment":0,"nFiles":3},"Markdown":{"blank":30,"code":92,"comment":0,"nFiles":4},"Python":{"blank":43,"code":101,"comment":22,"nFiles":3},"SUM":{"blank":168,"code":1198,"comment":137,"nFiles":124},"SVG":{"blank":0,"code":99,"comment":0,"nFiles":93},"YAML":{"blank":34,"code":243,"comment":80,"nFiles":9},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"53e1b01751e5fe0e982e29dce99269f2f86d0295","date":1649471545,"elapsed_seconds":0.509367942810059,"files_per_second":243.438955572905,"lines_per_second":2950.71572762965,"n_files":124,"n_lines":1503}},{"Bourne Shell":{"blank":1,"code":7,"comment":0,"nFiles":2},"Dart":{"blank":38,"code":490,"comment":22,"nFiles":8},"Dockerfile":{"blank":16,"code":17,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"HTML":{"blank":6,"code":26,"comment":13,"nFiles":1},"JSON":{"blank":0,"code":97,"comment":0,"nFiles":3},"Markdown":{"blank":30,"code":92,"comment":0,"nFiles":4},"Python":{"blank":51,"code":130,"comment":22,"nFiles":4},"SUM":{"blank":342,"code":1383,"comment":1754,"nFiles":129},"SVG":{"blank":0,"code":99,"comment":0,"nFiles":93},"YAML":{"blank":194,"code":388,"comment":1697,"nFiles":12},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"5465b068a7bfcee9d1ece47d058685592a0919d4","date":1649815293,"elapsed_seconds":0.494191884994507,"files_per_second":261.032210193888,"lines_per_second":7039.77565321347,"n_files":129,"n_lines":3479}},{"Bourne Shell":{"blank":1,"code":7,"comment":0,"nFiles":2},"Dart":{"blank":90,"code":967,"comment":22,"nFiles":13},"Dockerfile":{"blank":16,"code":17,"comment":0,"nFiles":1},"HCL":{"blank":6,"code":37,"comment":0,"nFiles":1},"HTML":{"blank":6,"code":26,"comment":13,"nFiles":1},"JSON":{"blank":0,"code":97,"comment":0,"nFiles":3},"Markdown":{"blank":38,"code":107,"comment":0,"nFiles":5},"Python":{"blank":51,"code":130,"comment":22,"nFiles":4},"SUM":{"blank":401,"code":1879,"comment":1754,"nFiles":135},"SVG":{"blank":0,"code":99,"comment":0,"nFiles":93},"YAML":{"blank":193,"code":392,"comment":1697,"nFiles":12},"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.86","commit_hash":"a60a18317f2cd91f121329ca45269eca524d3813","date":1649861267,"elapsed_seconds":0.514563083648682,"files_per_second":262.35850236814,"lines_per_second":7839.66073002279,"n_files":135,"n_lines":4034}}]';
  return (json.decode(jsonString) as List)
      .map((i) => ClocResult.fromJson(i))
      .toList();
}

class HistoryPage extends StatefulWidget {
  HistoryPage({
    Key? key,
    required this.historyResult,
  }) : super(key: key);

  final List<ClocResult> historyResult;

  @override
  State<HistoryPage> createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  int clickedIndex = 0;
  final _cardSpacing = 15.0;

  void updateClickedIndex(int newIdx) {
    setState(() {
      clickedIndex = newIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue[50],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.historyResult[0].giturl != null)
            RepoTitle(url: widget.historyResult[0].giturl),
          SizedBox(height: _cardSpacing),
          SizedBox(
              width: 500,
              child: HistoryLineChart(
                historyResult: widget.historyResult,
                updateClickedIndex: updateClickedIndex,
              )),
          SizedBox(height: _cardSpacing),
          DownloadResults(results: widget.historyResult),
          SizedBox(height: _cardSpacing),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Text("Selected Commit",
                          textScaleFactor: 1.5,
                          style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: LanguageCardList(
                            widget.historyResult[clickedIndex].languages, true),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Text("Latest Commit",
                          textScaleFactor: 1.5,
                          style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: LanguageCardList(
                            widget
                                .historyResult[widget.historyResult.length - 1]
                                .languages,
                            true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
