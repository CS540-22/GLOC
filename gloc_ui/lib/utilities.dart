import 'dart:convert';
import 'models.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

List<LanguageResult> extractLanguagesFromJson(Map<String, dynamic> json) {
  List<LanguageResult> languages = [];
  for (var language in json.keys) {
    if (language == "header" || language == "SUM") continue;
    languages.add(LanguageResult.fromJson(language, json[language]));
  }
  return languages;
}

Future<ClocResult> sendClocRequest(ClocRequest request) async {
  var response = await http.get(request.generateRequestURL());
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return ClocResult.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed Cloc Request');
  }
}

String? validateGithubURL(String? urlString) {
  if (urlString == null) return 'Enter a valid Github URL';
  if (urlString.isEmpty) return 'URL cannot be blank';
  Uri? url = Uri.tryParse(urlString);
  if (url == null) return 'URL parse error';
  if (!url.isScheme('https')) return 'Make sure it has https:// at the front';
  if (url.host != 'github.com') return 'Project must be hosted at github.com';
  if (url.hasEmptyPath) return 'Github URL must contain project path';
  return null;
}

Map<String, String> languageImages = {
  "Arduino Sketch": "arduino-original.svg",
  "Bourne Again Shell": "bash-original.svg",
  "Bourne Shell": "bash-original.svg",
  "C": "c-original.svg",
  "C Shell": "c-original.svg",
  "C#": "csharp-original.svg",
  "C# Designer": "csharp-original.svg",
  "C++": "cplusplus-original.svg",
  "C/C++ Header": "c-original.svg",
  "Clojure": "clojure-original.svg",
  "ClojureC": "clojure-original.svg",
  "ClojureScript": "clojurescript-original.svg",
  "Crystal": "crystal-original.svg",
  "CSS": "css3-original.svg",
  "Cucumber": "cucumber-plain.svg",
  "Dart": "dart-original.svg",
  "Dockerfile": "docker-original.svg",
  "Elixir": "elixir-original.svg",
  "Elm": "elm-original.svg",
  "ERB": "ruby-original.svg",
  "Erlang": "erlang-original.svg",
  "F#": "fsharp-original.svg",
  "F# Script": "fsharp-original.svg",
  "Go": "go-original.svg",
  "Godot Resource": "godot-original.svg",
  "Godot Scene": "godot-original.svg",
  "Gradle": "gradle-plain.svg",
  "Grails": "grails-original.svg",
  "GraphQL": "graphql-plain.svg",
  "Groovy": "groovy-original.svg",
  "Handlebars": "handlebars-original.svg",
  "Haskell": "haskell-original.svg",
  "Haxe": "haxe-original.svg",
  "HTML": "html5-original.svg",
  "Java": "java-original.svg",
  "JavaScript": "javascript-original.svg",
  "Julia": "julia-original.svg",
  "Jupyter Notebook": "jupyter-original.svg",
  "Kotlin": "kotlin-original.svg",
  "LESS": "less-plain-wordmark.svg",
  "Lua": "lua-original.svg",
  "Markdown": "markdown-original.svg",
  "MATLAB": "matlab-original.svg",
  "Nix": "nixos-original.svg",
  "Objective-C": "objectivec-plain.svg",
  "Objective-C++": "objectivec-plain.svg",
  "OCaml": "ocaml-original.svg",
  "Oracle Forms": "oracle-original.svg",
  "Oracle PL/SQL": "oracle-original.svg",
  "Oracle Reports": "oracle-original.svg",
  "Perl": "perl-original.svg",
  "PHP": "php-original.svg",
  "PHP/Pascal": "php-original.svg",
  "Python": "python-original.svg",
  "Qt": "qt-original.svg",
  "Qt Linguist": "qt-original.svg",
  "Qt Project": "qt-original.svg",
  "R": "r-original.svg",
  "Ruby": "ruby-original.svg",
  "Ruby HTML": "ruby-original.svg",
  "Rust": "rust-plain.svg",
  "Sass": "sass-original.svg",
  "Scala": "scala-original.svg",
  "Stylus": "stylus-original.svg",
  "Svelte": "svelte-original.svg",
  "Swift": "swift-original.svg",
  "TypeScript": "typescript-original.svg",
  "Unity-Prefab": "unity-original.svg",
  "vim script": "vim-original.svg",
  "Visual Studio Solution": "visualstudio-plain.svg",
  "Vuejs Component": "vuejs-original.svg",
  "Windows Message File": "windows8-original.svg",
  "Windows Module Definition": "windows8-original.svg",
  "Windows Resource File": "windows8-original.svg",
  "Zig": "zig-original.svg",
};

String getLanguageImagePath(String language) {
  return languageImages[language] ?? "default.svg";
}
