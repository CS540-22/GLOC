import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:gloc_ui/utilities.dart';
import 'package:http/http.dart';

enum RequestType { single, history }

class ClocRequest {
  final Uri giturl;
  final RequestType type;

  ClocRequest(String url, this.type) : giturl = Uri.parse(url);

  Future<Response> sendRequest() async {
    return await post(
      Uri.https('gloc.homelab.benlg.dev', type.name),
      body: <String, String>{
        'url': '$giturl',
      },
    );
  }
}

class LangIcon {
  late String path;
  late ColorPalette colorPalette = ColorPalette.empty();

  LangIcon(String languageName) {
    path = 'icons/' + getLanguageImagePath(languageName);
    List<String> colorStrings = getLanguageImageColors(languageName);
    for (var i = 0; i < 3; i++) {
      if (i < colorStrings.length) {
        RgbColor color = RgbColor.fromHex(colorStrings[i]);
        colorPalette.add(color);
      } else {
        var hslColor = HSLColor.fromColor(colorPalette[i - 1]);
        var newLightness = min(hslColor.lightness + .15, 1.0);
        colorPalette.add(hslColor.withLightness(newLightness).toColor());
      }
    }
    colorPalette.sortBy(ColorSortingProperty.darkest);
  }
}

class LanguageResult {
  final String name;
  int files;
  int blank;
  int comment;
  int code;
  final LangIcon icon;

  LanguageResult({
    required this.name,
    required this.files,
    required this.blank,
    required this.comment,
    required this.code,
    required this.icon,
  });

  factory LanguageResult.fromJson(String name, Map<String, dynamic> json) {
    return LanguageResult(
      name: name,
      files: json['nFiles'],
      blank: json['blank'],
      comment: json['comment'],
      code: json['code'],
      icon: LangIcon(name),
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
  final ColorPalette colorPalette;
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
    required this.colorPalette,
    this.commitHash,
    this.date,
  });

  factory ClocResult.fromJson(Map<String, dynamic> json) {
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
      colorPalette: ColorPalette.from([
        RgbColor.fromHex('1d3449'),
        RgbColor.fromHex('596f62'),
        RgbColor.fromHex('668060')
      ]),
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

enum JobStatus { pending, started, cloning, counting, finished }

class ClocJob {
  String? jobHash;
  JobStatus? status;
  int? currentCommit;
  int? lastCommit;
  List<ClocResult>? result;

  ClocJob({
    this.jobHash,
    this.status,
    this.currentCommit,
    this.lastCommit,
    this.result,
  });

  updateJobStatus(Map<String, dynamic> json) {
    if (json['status'] == "started") {
      status = JobStatus.started;
    } else if (json['status'] == "cloning") {
      status = JobStatus.cloning;
    } else if (json['status'].toString().contains('/')) {
      status = JobStatus.counting;
      var commitNums = json['status'].toString().split('/');
      currentCommit = int.parse(commitNums[0]);
      lastCommit = int.parse(commitNums[1]);
    } else if (json['status'] == "finished") {
      status = JobStatus.finished;
      result =
          (json['results'] as List).map((i) => ClocResult.fromJson(i)).toList();
    } else {
      throw Exception('Bad ApiResult json');
    }
  }

  Future<Response> fetchJobStatus() async {
    return await post(
      Uri.https('gloc.homelab.benlg.dev', 'single'),
      body: <String, String>{
        'job_hash': '$jobHash',
      },
    );
  }

  String createStatusMessage() {
    switch (status) {
      case JobStatus.pending:
        return "Pending";
      case JobStatus.started:
        return "Started";
      case JobStatus.cloning:
        return "Cloning";
      case JobStatus.counting:
        if (currentCommit != null && lastCommit != null) {
          return "Counting $currentCommit/$lastCommit Commits";
        }
        return "Counting";
      case JobStatus.finished:
        return "Finished";
      default:
        return "";
    }
  }
}
