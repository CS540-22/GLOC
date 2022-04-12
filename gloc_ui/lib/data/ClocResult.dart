import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:gloc_ui/data/LanguageResult.dart';

class ClocResult {
  final int totalFiles;
  final int totalLines;
  final int totalBlank;
  final int totalComment;
  final int totalCode;
  String? commitHash;
  DateTime? date;
  Uri? giturl;

  List<LanguageResult> languages;

  ClocResult({
    required this.totalFiles,
    required this.totalLines,
    required this.totalBlank,
    required this.totalComment,
    required this.totalCode,
    required this.languages,
    this.commitHash,
    this.date,
    this.giturl,
  });

  factory ClocResult.fromJson(Map<String, dynamic> json, {Uri? giturl}) {
    List<LanguageResult> languages = [];
    for (var language in json.keys) {
      if (language == "header" || language == "SUM") continue;
      languages.add(LanguageResult.fromJson(language, json[language]));
    }

    // sorted into descending code count
    languages.sort((b, a) => a.code.compareTo(b.code));

    return ClocResult(
      totalFiles: json['header']['n_files'],
      totalLines: json['header']['n_lines'],
      totalBlank: json['SUM']['blank'],
      totalComment: json['SUM']['comment'],
      totalCode: json['SUM']['code'],
      languages: languages,
      commitHash: json['header']['commit_hash'],
      date: json['header']['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['header']['date'] * 1000)
          : null,
      giturl: giturl,
    );
  }

  factory ClocResult.fromBytes(Uint8List bytes) {
    var jsonString = String.fromCharCodes(bytes);
    var json = jsonDecode(jsonString);
    return ClocResult.fromJson(json);
  }

  factory ClocResult.mockResult() {
    String jsonString =
        '{"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.90","elapsed_seconds":0.327791929244995,"n_files":58,"n_lines":3042,"files_per_second":176.941513275179,"lines_per_second":9280.27729970855},"Dart":{"nFiles":26,"blank":190,"comment":94,"code":1668},"XML":{"nFiles":13,"blank":2,"comment":37,"code":319},"JSON":{"nFiles":5,"blank":0,"comment":0,"code":236},"YAML":{"nFiles":2,"blank":18,"comment":51,"code":103},"Gradle":{"nFiles":3,"blank":18,"comment":3,"code":88},"HTML":{"nFiles":1,"blank":13,"comment":17,"code":53},"Markdown":{"nFiles":4,"blank":25,"comment":0,"code":44},"CSS":{"nFiles":1,"blank":5,"comment":0,"code":38},"Swift":{"nFiles":1,"blank":1,"comment":0,"code":12},"Kotlin":{"nFiles":1,"blank":2,"comment":0,"code":4},"C/C++Header":{"nFiles":1,"blank":0,"comment":0,"code":1},"SUM":{"blank":274,"comment":202,"code":2566,"nFiles":58}}';
    return ClocResult.fromJson(jsonDecode(jsonString));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'header': {
        'commit_hash': commitHash,
        'date': date,
        'n_files': totalFiles,
        'n_lines': totalLines,
      },
      'SUM': {
        'blank': totalBlank,
        'comment': totalComment,
        'code': totalCode,
      }
    };
    for (var language in languages) {
      json[language.name] = language.toJson();
    }
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClocResult &&
          runtimeType == other.runtimeType &&
          totalFiles == other.totalFiles &&
          totalLines == other.totalLines &&
          totalBlank == other.totalBlank &&
          totalComment == other.totalComment &&
          totalCode == other.totalCode &&
          const DeepCollectionEquality().equals(languages, other.languages);

  @override
  int get hashCode =>
      totalFiles.hashCode ^
      totalLines.hashCode ^
      totalBlank.hashCode ^
      totalComment.hashCode ^
      totalCode.hashCode ^
      languages.hashCode;
}
