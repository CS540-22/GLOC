import 'package:gloc_ui/data/LanguageIcon.dart';

class LanguageResult {
  final String name;
  int files;
  int blank;
  int comment;
  int code;
  final LanguageIcon icon;

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
      icon: LanguageIcon(name),
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
