import 'dart:convert';
import 'models.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

List<LanguageResult> extractLanguagesFromJson(Map<String, dynamic> json) {
  List<LanguageResult> languages = [];
  for (var language in json.keys) {
    if (language == "header" || language == "SUM") continue;
    languages.add(LanguageResult.fromJson(json[language]));
  }
  return languages;
}

Future<ClocResult> sendClocRequest(ClocRequest request) async {
  var response = await http.get(request.generateRequestURL());
  if (response.statusCode == 200) {
    return ClocResult.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed Cloc Request');
  }
}

// bool isGithubURL(String? urlString) {
//   if (urlString == null) return false;
//   Uri? url = Uri.parse(urlString);
//   var host = url?.host;
//   log('url: $urlString');
//   return url?.host == "github.com" ? true : false;
// }

String? validateGithubURL(String? urlString) {
  if (urlString == null) return 'Enter a valid Github URL';
  if (urlString.isEmpty) return 'URL cannot be blank';
  Uri? url = Uri.tryParse(urlString);
  if (url == null) return 'Enter a valid Github URL';
  if (!url.isScheme('https')) return 'Make sure it has https:// at the front';
  if (url.host != 'github.com') return 'Project must be hosted at github.com';
  if (url.hasEmptyPath) return 'Github URL must contain project path';
  return null;
}
