class ClocRequest {
  final Uri giturl;

  ClocRequest(String url) : giturl = Uri.parse(url);

  Uri generateRequestURL() {
    final queryParameters = {
      'giturl': '$giturl',
    };

    return Uri.https('gloc.homelab.benlg.dev', 'gloc', queryParameters);
  }
}
