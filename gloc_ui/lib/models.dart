import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:gloc_ui/utilities.dart';

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
        // colorPalette.add(colorPalette[i - 1].rotateHue(30));
        // colorPalette.add(ColorPalette.random(1)[0]);

        var hslColor = HSLColor.fromColor(colorPalette[i - 1]);
        var newLightness = min(hslColor.lightness + .3, 1.0);
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
