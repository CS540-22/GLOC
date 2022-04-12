import 'package:flutter/material.dart';
import 'package:gloc_ui/data/LanguageIcon.dart';
import 'package:gloc_ui/widgets/DetailsPage.dart';

import 'data/ClocResult.dart';
import 'data/LanguageResult.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Test data to use for UI development
  final mockLanguages = [
    LanguageResult(
        name: 'Dart',
        files: 26,
        blank: 190,
        comment: 94,
        code: 1668,
        icon: LanguageIcon('Dart')),
    LanguageResult(
        name: 'XML',
        files: 13,
        blank: 2,
        comment: 37,
        code: 319,
        icon: LanguageIcon('XML')),
    LanguageResult(
        name: 'JSON',
        files: 5,
        blank: 0,
        comment: 0,
        code: 236,
        icon: LanguageIcon('JSON')),
    LanguageResult(
        name: 'YAML',
        files: 2,
        blank: 18,
        comment: 51,
        code: 103,
        icon: LanguageIcon('YAML')),
  ];

  final mockClocResult = ClocResult(
    totalFiles: 78,
    totalLines: 274 + 203 + 2575,
    totalBlank: 274,
    totalComment: 203,
    totalCode: 2575,
    languages: [],
    commitHash: null,
    date: null,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: DetailsPage(
          clocResult: mockClocResult,
        ));
  }
}
