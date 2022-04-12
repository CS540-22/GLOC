import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  ClocJob currentJob = ClocJob(status: JobStatus.pending);
  late StreamSubscription jobSubscription;

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
      backgroundColor: Colors.blueGrey,
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

  void jobStreamSetup() async {
    // send initial cloc request
    var response = await widget.request.sendRequest();
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonData = jsonDecode(response.body);
      currentJob = ClocJob(jobHash: jsonData['hash']);
      currentJob.updateJobStatus(jsonData);
    } else {
      throw Exception('Failed to start job');
    }

    // create polling stream to periodically check the job status
    Stream jobStream = Stream.periodic(const Duration(seconds: 1), (_) async {
      var response = await currentJob.fetchJobStatus();
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var jsonData = jsonDecode(response.body);
        currentJob.updateJobStatus(jsonData);
        return currentJob;
      } else {
        throw Exception('Failed to get job status');
      }
    }).asyncMap(
      (value) async => await value,
    );

    // listen for status changes and update state
    jobSubscription = jobStream.listen((event) {
      setState(() {
        currentJob = event;
        if (currentJob.status == JobStatus.finished &&
            currentJob.result != null) {
          jobSubscription.cancel();
          if (currentJob.result!.length == 1) {
            Router.neglect(context,
                () => context.goNamed('details', extra: currentJob.result![0]));
          } else {
            Router.neglect(context,
                () => context.goNamed('history', extra: currentJob.result!));
          }
        }
      });
    });
  }
}
