import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';

class ClocRequest {
  final Uri giturl;

  ClocRequest(String url) : giturl = Uri.parse(url);

  Uri generateRequestURL() {
    final queryParameters = {
      'giturl': '$giturl',
    };

    return Uri.https('gloc.homelab.benlg.dev', 'gloc', queryParameters);
  }
}

class LanguageResult {
  final String name;
  final int files;
  final int blank;
  final int comment;
  final int code;

  LanguageResult({
    required this.name,
    required this.files,
    required this.blank,
    required this.comment,
    required this.code,
  });

  factory LanguageResult.fromJson(String name, Map<String, dynamic> json) {
    return LanguageResult(
      name: name,
      files: json['nFiles'],
      blank: json['blank'],
      comment: json['comment'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nFiles': files,
        'blank': blank,
        'comment': comment,
        'code': code,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageResult &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          files == other.files &&
          blank == other.blank &&
          comment == other.comment &&
          code == other.code;

  @override
  int get hashCode =>
      name.hashCode ^
      files.hashCode ^
      blank.hashCode ^
      comment.hashCode ^
      code.hashCode;
}

class ClocResult {
  final int totalFiles;
  final int totalLines;
  final int totalBlank;
  final int totalComment;
  final int totalCode;
  String? commitHash;
  DateTime? date;

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
  });

  factory ClocResult.fromJson(Map<String, dynamic> json) {
    List<LanguageResult> languages = [];
    for (var language in json.keys) {
      if (language == "header" || language == "SUM") continue;
      languages.add(LanguageResult.fromJson(language, json[language]));
    }

    return ClocResult(
      totalFiles: json['header']['n_files'],
      totalLines: json['header']['n_lines'],
      totalBlank: json['SUM']['blank'],
      totalComment: json['SUM']['comment'],
      totalCode: json['SUM']['blank'],
      languages: languages,
      commitHash: json['header']['commit_hash'],
      date: json['header']['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['header']['date'] * 1000)
          : null,
    );
  }

  factory ClocResult.fromBytes(Uint8List bytes) {
    var jsonString = String.fromCharCodes(bytes);
    var json = jsonDecode(jsonString);
    return ClocResult.fromJson(json);
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