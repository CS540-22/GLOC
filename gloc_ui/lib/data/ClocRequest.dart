import 'package:http/http.dart';

enum RequestType { single, history }

class ClocRequest {
  final Uri giturl;
  final RequestType type;

  ClocRequest(String url, this.type) : giturl = Uri.parse(url);

  Future<Response> sendRequest() async {
    var body = <String, String>{
      'url': '$giturl',
    };
    if (type == RequestType.history) {
      body['limit'] = '5';
    }
    return await post(
      Uri.https(String.fromEnvironment('API_URL'), type.name),
      body: body,
    );
  }
}
