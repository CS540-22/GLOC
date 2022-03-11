import 'utilities.dart';

class ClocRequest {
  final Uri giturl;

  ClocRequest(String url) : giturl = Uri.parse(url);

  Uri generateRequestURL() {
    // TODO build actual url
    // return "" + giturl.toString();
    return Uri.parse(
        "https://raw.githubusercontent.com/CS540-22/GLOC/main/cloc_samples/attendio.min.json");
  }
}

class LanguageResult {
  final int files;
  final int blank;
  final int comment;
  final int code;

  LanguageResult({
    required this.files,
    required this.blank,
    required this.comment,
    required this.code,
  });

  factory LanguageResult.fromJson(Map<String, dynamic> json) {
    return LanguageResult(
      files: json['nFiles'],
      blank: json['blank'],
      comment: json['comment'],
      code: json['code'],
    );
  }
}

class ClocResult {
  final int totalFiles;
  final int totalLines;
  final int totalBlank;
  final int totalComment;
  final int totalCode;

  List<LanguageResult> languages;

  ClocResult({
    required this.totalFiles,
    required this.totalLines,
    required this.totalBlank,
    required this.totalComment,
    required this.totalCode,
    required this.languages,
  });

  factory ClocResult.fromJson(Map<String, dynamic> json) {
    return ClocResult(
      totalFiles: json['header']['n_files'],
      totalLines: json['header']['n_lines'],
      totalBlank: json['SUM']['blank'],
      totalComment: json['SUM']['comment'],
      totalCode: json['SUM']['blank'],
      languages: extractLanguagesFromJson(json),
    );
  }
}
