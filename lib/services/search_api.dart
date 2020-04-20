import 'dart:convert';
import 'package:http/http.dart';

class SearchQuery {
  SearchQuery({this.query, this.type});

  String query;
  List<String> titles = [];
  int responsecode;
  int totalresults;
  List<String> backgroundimg = [];
  List<String> votes = [];
  List<String> voteCount = [];
  List<int> id = [];
  String type;
  List<String> movietitle = [];
  List<int> movieid = [];

  Future<void> searchedItems() async {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    Response response = await get(
        'https://api.themoviedb.org/3/search/$type?api_key=$key&language=en-US&page=1&query=$query&include_adult=false');
    Map data = jsonDecode(response.body);
    responsecode = response.statusCode;
    totalresults = data['total_results'];
    if (totalresults > 20) {
      totalresults = 18;
    } else {
      totalresults = totalresults;
    }
    for (int i = 0; i < totalresults; i++) {
      String title = data['results'][i]['original_name'];
      String img = data['results'][i]['poster_path'];
      var vote = data['results'][i]['vote_average'];
      String vts = vote.toString();
      var votcount = data['results'][i]['vote_count'];
      int mid = data['results'][i]['id'];
      String x = votcount.toString();
      titles.add(title);
      backgroundimg.add(img);
      votes.add(vts);
      voteCount.add(x);
      id.add(mid);
      String mtitl = data['results'][i]['original_title'];
      movietitle.add(mtitl);
      mid = data['results'][i]['id'];
      movieid.add(mid);
    }
  }
}
