import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gloc_ui/data/ClocJob.dart';
import 'package:gloc_ui/data/ClocRequest.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.request}) : super(key: key);

  final ClocRequest request;
  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
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
    return Container(
      child: Text(currentJob.createStatusMessage()),
    );
  }

  void jobStreamSetup() async {
    // send initial cloc request
    var response = await widget.request.sendRequest();
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var jsonData = jsonDecode(response.body);
      currentJob = ClocJob(
          jobHash: jsonData['hash'],
          giturl: widget.request.giturl,
          type: widget.request.type);
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
            // history page
          }
        }
      });
    });
  }
}
