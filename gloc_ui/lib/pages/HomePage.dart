import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gloc_ui/data/ClocRequest.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('G.L.O.C.', style: Theme.of(context).textTheme.displayMedium),
        Text('Graphical Lines of Code',
            style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 30.0),
        _ConfigurationForm(),
        SizedBox(height: 30.0),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 120.0, maxWidth: 500.0),
            child: _Dropzone()),
      ],
    ));
  }
}

class _Dropzone extends StatefulWidget {
  _Dropzone({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropzoneState();
}

class _DropzoneState extends State<_Dropzone> {
  late DropzoneViewController dropController;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: isHighlighted ? Theme.of(context).splashColor : Theme.of(context).cardColor),
            child: Stack(children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.Default,
                onCreated: (ctrl) => dropController = ctrl,
                onHover: () {
                  setState(() => isHighlighted = true);
                },
                onLeave: () {
                  setState(() => isHighlighted = false);
                },
                onDrop: (ev) async {
                  try {
                    final bytes = await dropController.getFileData(ev);
                    List<ClocResult> result =
                        (json.decode(String.fromCharCodes(bytes)) as List)
                            .map((i) => ClocResult.fromJson(i))
                            .toList();
                    setState(() => isHighlighted = false);
                    if (result.length == 1) {
                      context.goNamed('details', extra: result[0]);
                    } else if (result.length > 1) {
                      context.goNamed('history', extra: result);
                    }
                  } catch (e) {
                    setState(() => isHighlighted = false);
                  }
                },
              ),
              Center(child: Text('Or upload repo archive here.')),
            ])));
  }
}

class _ConfigurationForm extends StatefulWidget {
  _ConfigurationForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfigurationFormState();
}

class _ConfigurationFormState extends State<_ConfigurationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController urlController =
      TextEditingController(text: 'https://github.com/CS540-22/GLOC');
  TextEditingController limitController = TextEditingController(text: '5');
  TextEditingController stepController = TextEditingController(text: '1');
  RequestType type = RequestType.single;
  bool advancedSelected = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: type,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: RequestType.values.map((RequestType type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                        type.name[0].toUpperCase() + type.name.substring(1)),
                  );
                }).toList(),
                onChanged: (RequestType? newValue) {
                  setState(() {
                    type = newValue!;
                  });
                },
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Enter GitHub URL"),
                      controller: urlController,
                      validator: (value) {
                        if (value == null) return 'Enter a valid Github URL';
                        if (value.isEmpty) return 'URL cannot be blank';
                        Uri? url = Uri.tryParse(value);
                        if (url == null) return 'URL parse error';
                        if (!url.isScheme('https'))
                          return 'Make sure it has https:// at the front';
                        if (url.host != 'github.com')
                          return 'Project must be hosted at github.com';
                        if (url.hasEmptyPath)
                          return 'Github URL must contain project path';
                        return null;
                      },
                    ),
                  )),
            ],
          ),
          if (type == RequestType.history)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 250.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: stepController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                              labelText: "Step",
                              icon: Icon(
                                Icons.redo,
                                size: 25,
                              )),
                          validator: (value) {
                            if (value == null)
                              return "Please enter valid number";
                            int? step = int.tryParse(value);
                            if (step == null)
                              return "Please enter valid number";
                            if (step < 1) return "Step must be greater than 0";
                            return null;
                          }),
                    )),
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 250.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: limitController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                              labelText: "Limit",
                              icon: Icon(
                                Icons.last_page,
                                size: 30,
                              )),
                          validator: (value) {
                            if (value == null)
                              return "Please enter valid number";
                            int? limit = int.tryParse(value);
                            if (limit == null)
                              return "Please enter valid number";
                            if (limit < 1)
                              return "Limit must be greater than 0";
                            return null;
                          }),
                    )),
              ],
            ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.0, minWidth: 200.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.goNamed('loading',
                      extra: ClocRequest(
                          url: urlController.text,
                          type: type,
                          limit: limitController.text,
                          step: stepController.text));
                }
              },
              child: const Text('ANALYZE'),
            ),
          ),
        ],
      ),
    );
  }
}
