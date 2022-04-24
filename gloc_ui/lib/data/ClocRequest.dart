import 'package:http/http.dart';

enum RequestType { single, history }

class ClocRequest {
  final Uri giturl;
  final RequestType type;
  final String limit;
  final String step;

  ClocRequest(
      {required String url,
      required this.type,
      required this.limit,
      required this.step})
      : giturl = Uri.parse(url);

  Future<Response> sendRequest() async {
    var body = <String, String>{
      'url': '$giturl',
    };
    if (type == RequestType.history) {
      body['limit'] = limit;
      body['step'] = step;
    }
    return await post(
      Uri.https('gloc-api.homelab.benlg.dev', type.name),
      body: body,
    );
  }
}
