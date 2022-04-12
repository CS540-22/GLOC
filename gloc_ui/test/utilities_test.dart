import 'dart:convert';
import 'package:gloc_ui/models.dart';
import 'package:test/test.dart';
import 'package:gloc_ui/utilities.dart';

void main() {
  group("URL validation", () {
    test("is empty", () {
      expect(validateGithubURL(''), 'URL cannot be blank');
    });

    test("is random characters w/o scheme", () {
      expect(validateGithubURL('sdfwrebfdg'),
          'Make sure it has https:// at the front');
    });

    test("is random characters w/ scheme", () {
      expect(validateGithubURL('https://sdfwrebfdg'),
          'Project must be hosted at github.com');
    });

    test("is github.com", () {
      expect(validateGithubURL('https://github.com'),
          'Github URL must contain project path');
    });

    test("is project on github.com", () {
      expect(validateGithubURL('https://github.com/attendio/attendio'), null);
    });
  });

//   group("Backend processing", () {
//     test("with valid repo", () async {
//       String expectedJsonString =
//           '{"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.90","elapsed_seconds":0.327791929244995,"n_files":58,"n_lines":3042,"files_per_second":176.941513275179,"lines_per_second":9280.27729970855},"Dart":{"nFiles":26,"blank":190,"comment":94,"code":1668},"XML":{"nFiles":13,"blank":2,"comment":37,"code":319},"JSON":{"nFiles":5,"blank":0,"comment":0,"code":236},"YAML":{"nFiles":2,"blank":18,"comment":51,"code":103},"Gradle":{"nFiles":3,"blank":18,"comment":3,"code":88},"HTML":{"nFiles":1,"blank":13,"comment":17,"code":53},"Markdown":{"nFiles":4,"blank":25,"comment":0,"code":44},"CSS":{"nFiles":1,"blank":5,"comment":0,"code":38},"Swift":{"nFiles":1,"blank":1,"comment":0,"code":12},"Kotlin":{"nFiles":1,"blank":2,"comment":0,"code":4},"C/C++Header":{"nFiles":1,"blank":0,"comment":0,"code":1},"SUM":{"blank":274,"comment":202,"code":2566,"nFiles":58}}';
//       ClocResult expectedResult =
//           ClocResult.fromJson(jsonDecode(expectedJsonString));

//       ClocRequest request = ClocRequest("https://github.com/attendio/attendio");
//       ClocResult actualResult = await sendClocRequest(request);

//       expect(actualResult, expectedResult);
//     });

//     test("with invalid repo", () {
//       ClocRequest request = ClocRequest("https://github.com/sdfwrebfdg");
//       expect(() async => await sendClocRequest(request), throwsException);
//     });
//   });
}
