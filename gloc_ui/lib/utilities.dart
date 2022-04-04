import 'dart:convert';
import 'dart:typed_data';
import 'models.dart';
import 'package:http/http.dart' as http;

Future<ClocResult> sendClocRequest(ClocRequest request) async {
  var response = await http.get(request.generateRequestURL());
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return ClocResult.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed Cloc Request');
  }
}

Future<List<ClocResult>> sendClocHistoryRequest(ClocRequest request) async {
  var response = await http.get(request.generateRequestURL());
  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return (json.decode(response.body) as List)
        .map((i) => ClocResult.fromJson(i))
        .toList();
  } else {
    throw Exception('Failed Cloc History Request');
  }
}

List<ClocResult>? getResultsFromFile(Uint8List bytes) {
  // Attempt to read bytes as single cloc result
  try {
    var result = [ClocResult.fromBytes(bytes)];
    // print("single");
    return result;
  } catch (e) {
    // Attempt to read bytes as cloc history request
    try {
      var result = (json.decode(String.fromCharCodes(bytes)) as List)
          .map((i) => ClocResult.fromJson(i))
          .toList();
      // print("history");
      return result;
    } catch (e) {
      // print("invalid");
      return null;
    }
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

Map<String, List<String>> languageColors = {
  "Arduino Sketch": ["04949c"],
  "Bourne Again Shell": ["2c343b", "4aa144", "3a643e"],
  "Bourne Shell": ["2c343b", "4aa144", "3a643e"],
  "C": ["317ab6", "b9d1e9", "7cacd6"],
  "C Shell": ["317ab6", "b9d1e9", "7cacd6"],
  "C#": ["843988", "e0cee1", "cca2c7"],
  "C# Designer": ["843988", "e0cee1", "cca2c7"],
  "C++": ["b73460", "eed0d9", "e1a5b8"],
  "C/C++ Header": ["317ab6", "b9d1e9", "7cacd6"],
  "Clojure": ["72bf39", "6f94e5", "d7e9dc"],
  "ClojureC": ["72bf39", "6f94e5", "d7e9dc"],
  "ClojureScript": ["94cc4c", "5c7cbc"],
  "Crystal": ["040404"],
  "CSS": ["1d82be", "e3e9eb", "6fc3e6"],
  "Cucumber": ["04ac1c"],
  "Dart": ["0ac2bf", "0474cb", "049edb"],
  "Dockerfile": ["1f84a4", "bbdce4", "28c4eb"],
  "Elixir": ["715783", "c6becc", "bca4c6"],
  "Elm": ["5e8e48", "63b4cc", "eca404"],
  "ERB": ["a8170b", "f0beb4", "c98484"],
  "Erlang": ["ac0434"],
  "F#": ["33bcdc", "348cbc", "3498d0"],
  "F# Script": ["33bcdc", "348cbc", "3498d0"],
  "Go": ["6bd1e1", "192020", "ead0a9"],
  "Godot Resource": ["4589b7", "cad8e3", "414042"],
  "Godot Scene": ["4589b7", "cad8e3", "414042"],
  "Gradle": ["02303a"],
  "Grails": ["fcb474"],
  "GraphQL": ["e434ac"],
  "Groovy": ["0f1113", "639bbb", "b6b6b6"],
  "Handlebars": ["040404"],
  "Haskell": ["5e5187", "443c64", "934c8c"],
  "Haxe": ["f0911e", "ec5824", "fbd71b"],
  "HTML": ["e85427", "ece8e7", "f6ac89"],
  "Java": ["0474bc", "ec2c2c", "3c50c0"],
  "JavaScript": ["f3db4b", "373634", "948444"],
  "Julia": ["ba9bcb", "3d9c25", "cc3d35"],
  "Jupyter Notebook": ["868488", "f47424", "d08864"],
  "Kotlin": ["527fb9", "e27550", "b4747c"],
  "LESS": ["2c4c84"],
  "Lua": ["040483", "838383", "244880"],
  "Markdown": ["040404"],
  "MATLAB": ["ed6d40", "4783b7", "8e7f94"],
  "Nix": ["7cbce4", "5277c3"],
  "Objective-C": ["0c5c9c"],
  "Objective-C++": ["0c5c9c"],
  "OCaml": ["f18206", "ec6b0c", "f49404"],
  "Oracle Forms": ["ec1c24"],
  "Oracle PL/SQL": ["ec1c24"],
  "Oracle Reports": ["ec1c24"],
  "Perl": ["25257c", "c3c3d9", "8484b4"],
  "PHP": ["6682ad", "080708", "cfd4e0"],
  "PHP/Pascal": ["6682ad", "080708", "cfd4e0"],
  "Python": ["fbde58", "3d7aab", "346c94"],
  "Qt": ["44cc54"],
  "Qt Linguist": ["44cc54"],
  "Qt Project": ["44cc54"],
  "R": ["aeb0b4", "1f65b7", "5f7daa"],
  "Ruby": ["a8170b", "f0beb4", "c98484"],
  "Ruby HTML": ["a8170b", "f0beb4", "c98484"],
  "Rust": ["040404"],
  "Sass": ["cc649c"],
  "Scala": ["db3323", "3f0d0c", "9f251a"],
  "Stylus": ["343434"],
  "Svelte": ["fc3d05", "fccbbb", "fc9c7b"],
  "Swift": ["f3543c", "fbd3cc", "f5ac9c"],
  "TypeScript": ["047ccc", "acd3ee", "79bce4"],
  "Unity-Prefab": ["140c0c"],
  "vim script": ["c2c4c3", "0a972e", "080c09"],
  "Visual Studio Solution": ["6c247c"],
  "Vuejs Component": ["43bb83", "344c5c", "3c8b74"],
  "Windows Message File": ["04acec"],
  "Windows Module Definition": ["04acec"],
  "Windows Resource File": ["04acec"],
  "Zig": ["f4a41c"],
};

List<String> getLanguageImageColors(String language) {
  return languageColors[language] ?? ["040404"];
}
