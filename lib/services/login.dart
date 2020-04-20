import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class Login {
  String token;
  String url =
      'https://api.themoviedb.org/3/authentication/token/new?api_key=a71008231061acb3b96b658e8afb1ca3';

  Future<void> tokenRequest() async {
    Response response = await get('$url');
    Map data = jsonDecode(response.body);
    token = data['request_token'];
    launch(
        'https://www.themoviedb.org/authenticate/$token?redirect_to=app://movies/');
  }
}
