import 'dart:convert';
import 'package:http/http.dart';

class TvApiFetch{
  
  String url;
  int responsecode, runtime, budget, seasons, episodes, voteCount, revenue;
  String year, title, img, language, status, origincountry, genre, movieid, lastEpisode, createdby;
  String rating, plot, actors, imdbvotes, writer, director, coverimg, tagline, homepage;  
  double voteAverage, popularity;
  String videourl;

  TvApiFetch({this.url});

  Future <void> getData() async{
    Response response = await get('$url');
    Map data = jsonDecode(response.body);
    responsecode = response.statusCode;
    try{
      title = data['original_name'];
    year = data['first_air_date'];
    img = data['poster_path'];
    plot = data['overview'];
    runtime = data['episode_run_time'][0];    
    coverimg = data['backdrop_path'];
    voteAverage = data['vote_average'];
    voteCount = data['vote_count'];
    tagline = data['tagline'];
    homepage = data['homepage'];
    budget = data['budget'];
    language = data['original_language'];
    revenue = data['revenue'];
    popularity = data['popularity'];
    int id = data['id'];
    movieid = id.toString();
    status = data['status'];
    origincountry = data['origin_country'][0];
    lastEpisode = data['last_air_date'];
    seasons = data['number_of_seasons'];
    episodes = data['number_of_episodes'];
    createdby = data['created_by'][0]['name'];
    genre = data['genres'][0]['name'];
    // List<dynamic>  seasonzz = data['seasons'];
    Response response2 = await get('https://api.themoviedb.org/3/tv/$movieid/videos?api_key=a71008231061acb3b96b658e8afb1ca3&language=en-US');
    Map data2 = jsonDecode(response2.body);
    List<dynamic> x = data2['results'];
    var results = x.length;
    if(results == 0){
      videourl = 'null';
    }
    else{
      videourl = data2['results'][0]['key'];
    }
    print(videourl);
    }

    
    catch(e){
      print(e);
    }
    
    
    // Map seasoninfo = json.encode(seasonzz) as Map;    
    // print(seasoninfo);
    }    
  }

// To get movie details