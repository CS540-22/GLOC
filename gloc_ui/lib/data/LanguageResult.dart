
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
