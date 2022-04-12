import 'package:gloc_ui/data/ClocRequest.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:http/http.dart';

enum JobStatus { pending, started, cloning, counting, finished }

class ClocJob {
  String? jobHash;
  JobStatus? status;
  int? currentCommit;
  int? lastCommit;
  List<ClocResult>? result;
  Uri? giturl;
  RequestType? type;

  ClocJob({
    this.jobHash,
    this.status,
    this.currentCommit,
    this.lastCommit,
    this.result,
    this.giturl,
    this.type,
  });

  updateJobStatus(Map<String, dynamic> json) {
    if (json['status'] == "started") {
      status = JobStatus.started;
    } else if (json['status'] == "cloning") {
      status = JobStatus.cloning;
    } else if (json['status'].toString().contains('/')) {
      status = JobStatus.counting;
      var commitNums = json['status'].toString().split('/');
      currentCommit = int.parse(commitNums[0]);
      lastCommit = int.parse(commitNums[1]);
    } else if (json['status'] == "finished") {
      status = JobStatus.finished;
      result = (json['results'] as List)
          .map((i) => ClocResult.fromJson(i, giturl: giturl))
          .toList();
    } else {
      throw Exception('Bad ApiResult json');
    }
  }

  Future<Response> fetchJobStatus() async {
    return await post(
      Uri.https('gloc.homelab.benlg.dev', type!.name),
      body: <String, String>{
        'job_hash': '$jobHash',
      },
    );
  }

  String createStatusMessage() {
    switch (status) {
      case JobStatus.pending:
        return "Pending";
      case JobStatus.started:
        return "Started";
      case JobStatus.cloning:
        return "Cloning";
      case JobStatus.counting:
        if (currentCommit != null && lastCommit != null) {
          return "Counting $currentCommit/$lastCommit Commits";
        }
        return "Counting";
      case JobStatus.finished:
        return "Finished";
      default:
        return "";
    }
  }
}
