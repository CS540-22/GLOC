import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'details.dart';
import 'models.dart';
import 'results.dart';
import 'utilities.dart';

// ClocRequest('https://github.com/attendio/attendio.git')
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'GLOC';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyCustomForm(),
      ),
    );
  }
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
    return Form(
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
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text(urlController.text)),
                // );
                ClocRequest request = ClocRequest(urlController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsScreen(request: request),
                  ),
                );
              }
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    clocResult: result![0],
                  ),
                ),
              );
              print(result);
            },
            child: const Text('Pick file'),
          ),
        ],
      ),
    );
  }

  Widget buildZone1(BuildContext context) => Builder(
        builder: (context) => DropzoneView(
          operation: DragOperation.copy,
          cursor: CursorType.grab,
          onCreated: (ctrl) => controller1 = ctrl,
          onLoaded: () => print('Zone 1 loaded'),
          onError: (ev) => print('Zone 1 error: $ev'),
          onHover: () {
            setState(() => highlighted1 = true);
            print('Zone 1 hovered');
          },
          onLeave: () {
            setState(() => highlighted1 = false);
            print('Zone 1 left');
          },
          onDrop: (ev) async {
            print('Zone 1 drop: ${ev.name}');
            setState(() {
              message1 = '${ev.name} dropped';
              highlighted1 = false;
            });
            final bytes = await controller1.getFileData(ev);
            var result = getResultsFromFile(bytes);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  clocResult: result![0],
                ),
              ),
            );
            // print(result);
          },
          onDropMultiple: (ev) async {
            // message1 = 'Please only Select One File';
            // print('Zone 1 drop multiple: $ev');
          },
        ),
      );
}
