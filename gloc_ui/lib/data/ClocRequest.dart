import 'package:http/http.dart';

enum RequestType { single, history }

class ClocRequest {
  final Uri giturl;
  final RequestType type;

  ClocRequest(String url, this.type) : giturl = Uri.parse(url);

  Future<Response> sendRequest() async {
    return await post(
      Uri.https('gloc.homelab.benlg.dev', type.name),
      body: <String, String>{
        'url': '$giturl',
      },
    );
  }
}
