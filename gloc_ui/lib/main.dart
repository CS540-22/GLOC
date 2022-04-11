import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gloc_ui/stream_screen.dart';
import 'package:go_router/go_router.dart';
import 'details.dart';
import 'models.dart';
import 'results.dart';
import 'utilities.dart';

// ClocRequest('https://github.com/attendio/attendio.git')
void main() {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static const String _title = 'GLOC';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: _title,
      );

  final _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => MyCustomForm(key: state.pageKey),
          routes: [
            GoRoute(
                name: 'loading',
                path: 'loading',
                builder: (context, state) => WaitingScreen(
                      key: state.pageKey,
                      request: state.extra! as ClocRequest,
                    )),
            GoRoute(
                name: 'details',
                path: 'details',
                builder: (context, state) => DetailsPage(
                    key: state.pageKey,
                    clocResult: state.extra! as ClocResult)),
          ]),
    ],
    initialLocation: '/',
    errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(child: Text(state.error.toString())),
        )),
  );
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final urlController =
      TextEditingController(text: 'https://github.com/attendio/attendio');
  late DropzoneViewController controller1;
  String message1 = 'Drop something here';
  bool highlighted1 = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: urlController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              // if (isGithubURL(value)) {
              //   return null;
              // } else {
              //   return 'Enter a valid Github URL';
              // }
              return validateGithubURL(value);
            },
          ),
          ElevatedButton(
            onPressed: () {
              // ***********Details Page************
              // String expectedJsonString =
              //     '{"header":{"cloc_url":"github.com/AlDanial/cloc","cloc_version":"1.90","elapsed_seconds":0.327791929244995,"n_files":58,"n_lines":3042,"files_per_second":176.941513275179,"lines_per_second":9280.27729970855},"Dart":{"nFiles":26,"blank":190,"comment":94,"code":1668},"XML":{"nFiles":13,"blank":2,"comment":37,"code":319},"JSON":{"nFiles":5,"blank":0,"comment":0,"code":236},"YAML":{"nFiles":2,"blank":18,"comment":51,"code":103},"Gradle":{"nFiles":3,"blank":18,"comment":3,"code":88},"HTML":{"nFiles":1,"blank":13,"comment":17,"code":53},"Markdown":{"nFiles":4,"blank":25,"comment":0,"code":44},"CSS":{"nFiles":1,"blank":5,"comment":0,"code":38},"Swift":{"nFiles":1,"blank":1,"comment":0,"code":12},"Kotlin":{"nFiles":1,"blank":2,"comment":0,"code":4},"C/C++Header":{"nFiles":1,"blank":0,"comment":0,"code":1},"SUM":{"blank":274,"comment":202,"code":2566,"nFiles":58}}';
              // ClocResult expectedResult =
              //     ClocResult.fromJson(jsonDecode(expectedJsonString));
              // context.goNamed('details', extra: expectedResult);

              // ************Stream Page***************
              context.goNamed('loading',
                  extra: ClocRequest(urlController.text));

              // ************Results Page***************
              // // Validate returns true if the form is valid, or false otherwise.
              // if (_formKey.currentState!.validate()) {
              //   // If the form is valid, display a snackbar. In the real world,
              //   // you'd often call a server or save the information in a database.
              //   // ScaffoldMessenger.of(context).showSnackBar(
              //   //   SnackBar(content: Text(urlController.text)),
              //   // );
              //   ClocRequest request = ClocRequest(urlController.text);
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ResultsScreen(request: request),
              //     ),
              //   );
              // }
            },
            child: const Text('Submit'),
          ),
          Expanded(
            child: Container(
              color: highlighted1 ? Colors.red : Colors.transparent,
              child: Stack(
                children: [
                  buildZone1(context),
                  Center(child: Text(message1)),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var files =
                  await controller1.pickFiles(mime: ['application/json']);
              var bytes = await controller1.getFileData(files.first);
              var result = getResultsFromFile(bytes);
              context.goNamed('details', extra: result![0]);
            },
            child: const Text('Pick file'),
          ),
        ],
      ),
    ));
  }

  Widget buildZone1(BuildContext context) => Builder(
        builder: (context) => DropzoneView(
          operation: DragOperation.copy,
          cursor: CursorType.grab,
          onCreated: (ctrl) => controller1 = ctrl,
          // onLoaded: () => print('Zone 1 loaded'),
          // onError: (ev) => print('Zone 1 error: $ev'),
          onHover: () {
            setState(() => highlighted1 = true);
            // print('Zone 1 hovered');
          },
          onLeave: () {
            setState(() => highlighted1 = false);
            // print('Zone 1 left');
          },
          onDrop: (ev) async {
            // print('Zone 1 drop: ${ev.name}');
            setState(() {
              message1 = '${ev.name} dropped';
              highlighted1 = false;
            });
            final bytes = await controller1.getFileData(ev);
            var result = getResultsFromFile(bytes);
            context.goNamed('details', extra: result![0]);
            // print(result);
          },
          onDropMultiple: (ev) async {
            // message1 = 'Please only Select One File';
            // print('Zone 1 drop multiple: $ev');
          },
        ),
      );
}
