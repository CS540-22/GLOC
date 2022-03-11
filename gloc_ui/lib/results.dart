import 'package:flutter/material.dart';
import 'models.dart';
import 'utilities.dart';

class ResultsScreen extends StatefulWidget {
  final ClocRequest request;
  const ResultsScreen({Key? key, required this.request}) : super(key: key);

  @override
  ResultsScreenState createState() => ResultsScreenState();
}

class ResultsScreenState extends State<ResultsScreen> {
  late Future<ClocResult> futureClocResult;

  @override
  void initState() {
    super.initState();
    futureClocResult = sendClocRequest(widget.request);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GLOC'),
        ),
        body: Center(
          child: FutureBuilder<ClocResult>(
            future: futureClocResult,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.totalFiles.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
