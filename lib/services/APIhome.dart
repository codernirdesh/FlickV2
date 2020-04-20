import 'dart:convert';
import 'package:http/http.dart';

class Getmovie {
  Getmovie({this.url});

  String url;
  List<String> titles = [];
  List<String> posterPath = [];
  List<int> id = [];
  int responsecode;
  List<dynamic> rating = [];

  Future<void> topRatedMoives() async {
    Response response = await get('$url');
    Map data = jsonDecode(response.body);
    responsecode = response.statusCode;
    for (int i = 1; i < 20; i++) {
      String title = data['results'][i]['title'];
      titles.add(title);
      String poster = data['results'][i]['poster_path'];
      int mid = data['results'][i]['id'];
      dynamic ratingx = data['results'][i]['vote_average'];
      id.add(mid);

      posterPath.add(poster);
      rating.add(ratingx);
    }
  }
}
