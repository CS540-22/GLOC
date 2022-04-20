import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gloc_ui/data/ClocRequest.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final urlController =
      TextEditingController(text: 'https://github.com/CS540-22/GLOC');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('G.L.O.C.', style: Theme.of(context).textTheme.displayMedium),
        Text('Graphical Lines of Code',
            style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 30.0),
        _URLForm(urlController),
        SizedBox(height: 30.0),
        _Analyze(urlController),
        // Expanded(child: _Dropzone()), //TODO add back in when design is finalized
      ],
    );
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
            color: isHighlighted ? Colors.green : Colors.white,
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
              Center(child: Text('Drop results here')),
            ])));
  }
}

class _URLForm extends StatelessWidget {
  const _URLForm(this.controller);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400.0),
      child: Material(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(hintText: "Enter GitHub URL"),
          controller: controller,
          validator: (value) {
            if (value == null) return 'Enter a valid Github URL';
            if (value.isEmpty) return 'URL cannot be blank';
            Uri? url = Uri.tryParse(value);
            if (url == null) return 'URL parse error';
            if (!url.isScheme('https'))
              return 'Make sure it has https:// at the front';
            if (url.host != 'github.com')
              return 'Project must be hosted at github.com';
            if (url.hasEmptyPath) return 'Github URL must contain project path';
            return null;
          },
        ),
      )),
    );
  }
}

class _Analyze extends StatelessWidget {
  const _Analyze(this.controller);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400.0, minWidth: 200.0),
      child: ElevatedButton(
        onPressed: () {
          context.goNamed('loading',
              extra: ClocRequest(controller.text, RequestType.single));
        },
        child: const Text('ANALYZE'),
      ),
    );
  }
}
