import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocRequest.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          context.goNamed('loading',
              extra: ClocRequest(
                  'https://github.com/CS540-22/GLOC', RequestType.single));
        },
        child: const Text('Submit'),
      ),
    );
  }
}
