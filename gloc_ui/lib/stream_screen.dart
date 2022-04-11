import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gloc_ui/details.dart';
import 'package:gloc_ui/utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:math';

import 'models.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key, required this.request}) : super(key: key);

  final ClocRequest request;
  @override
  State<WaitingScreen> createState() => WaitingScreenState();
}

class WaitingScreenState extends State<WaitingScreen> {
  ClocJob currentJob = ClocJob();
  late StreamSubscription jobSubscription;

  Color _bgColor = Colors.blueGrey;
  @override
  void initState() {
    jobStreamSetup();
    super.initState();
  }

  @override
  void dispose() {
    jobSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter Stream.periodic Demo'),
        backgroundColor: Colors.white12,
      ),
      body: Center(
        child: Text(
          currentJob.createStatusMessage(),
          style: const TextStyle(fontSize: 150, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.stop,
          size: 30,
        ),
        onPressed: () => jobSubscription.cancel(),
      ),
    );
  }

  void jobStreamSetup() {
    Stream jobStream = Stream.periodic(const Duration(seconds: 1), (_) async {
      var response = await get(widget.request.generateRequestURL());
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        print(response.body);
        return ClocJob.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed Cloc Request');
      }
    }).asyncMap(
      (value) async => await value,
    );

    jobSubscription = jobStream.listen((event) {
      setState(() {
        currentJob = event;

        if (currentJob.status == JobStatus.finished &&
            currentJob.result != null) {
          jobSubscription.cancel();
          Router.neglect(context,
              () => context.goNamed('details', extra: currentJob.result!));
        }
        _bgColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      });
    });
  }
}
