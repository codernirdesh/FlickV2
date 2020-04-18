import 'dart:convert';
import 'package:http/http.dart';

class ApiFetch{
  
  String url, moviekey, videourl;
  int responsecode, runtime, budget, revenue, voteCount;
  String year, title, img, rating, plot, actors, imdbvotes, director, coverimg, tagline, homepage, movieid;    
  double voteAverage, popularity;

  ApiFetch({this.url});

  Future <void> getData() async{

    try{
      Response response = await get('$url');    
    Map data = jsonDecode(response.body);
    responsecode = response.statusCode;
    title = data['title'];
    year = data['release_date'];
    img = data['poster_path'];
    plot = data['overview'];
    runtime = data['runtime'];    
    coverimg = data['backdrop_path'];
    voteAverage = data['vote_average'];
    voteCount = data['vote_count'];
    tagline = data['tagline'];
    homepage = data['homepage'];
    budget = data['budget'];
    revenue = data['revenue'];
    popularity = data['popularity'];
    int id = data['id'];
    movieid = id.toString();    
    Response response2 = await get('https://api.themoviedb.org/3/movie/$movieid/videos?api_key=a71008231061acb3b96b658e8afb1ca3&language=en-US');
    Map data2 = jsonDecode(response2.body);
    List<dynamic> x = data2['results'];
    var results = x.length;
    if(results == 0){
      videourl = 'null';
    }
    else{
      videourl = data2['results'][0]['key'];
    }
    }
    catch(e){
      // print(e);
    }
    

  }
}


// To get movie details