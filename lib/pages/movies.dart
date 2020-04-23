import 'package:flutter/material.dart';
import 'package:Flick/ui/movie_cards.dart';
import 'package:Flick/services/APIhome.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:Flick/services/admob_service.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
  
}


class _MoviesPageState extends State<MoviesPage> {

  final ams = AdMobService();

    
  List<String> posters, posters2, posters3, posters4, posters5 = [];
  List<int> movieId, movieId2, movieId3, movieId4, movieId5 = [];

  int responsecode;

  void getMovies() async {
    String key = 'a71008231061acb3b96b658e8afb1ca3';

    Random random = new Random();
    int page = random.nextInt(20) + 1;

    Getmovie popular = Getmovie(
        url: 'https://api.themoviedb.org/3/movie/popular?api_key=$key');
    Getmovie toprated = Getmovie(
        url: 'https://api.themoviedb.org/3/movie/top_rated?api_key=$key');
    Getmovie nowplaying = Getmovie(
        url: 'https://api.themoviedb.org/3/movie/now_playing?api_key=$key');
    Getmovie moviesforyou = Getmovie(
        url:
            'https://api.themoviedb.org/3/movie/top_rated?api_key=$key&page=$page');

    await popular.topRatedMoives();
    await toprated.topRatedMoives();
    await nowplaying.topRatedMoives();
    await moviesforyou.topRatedMoives();

    setState(() {
      responsecode = popular.responsecode;

      posters = popular.posterPath;
      movieId = popular.id;

      posters2 = toprated.posterPath;
      movieId2 = toprated.id;

      posters3 = nowplaying.posterPath;
      movieId3 = nowplaying.id;

      posters5 = moviesforyou.posterPath;
      movieId5 = moviesforyou.id;
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() {
    getMovies();
    // Admob.initialize(ams.getAdMobAppId());
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    Admob.initialize(ams.getAdMobAppId());
    
  }

  @override
  Widget build(BuildContext context) {    

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          children: <Widget>[
            Stack(children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(left: 40),
                  height: MediaQuery.of(context).size.height / 3.1,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.dstATop),
                        image: AssetImage('assets/movie.png'),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 3.1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [Colors.black, Colors.black26]),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.9, left: 20),
                  child: Text('MOVIE',
                      style: TextStyle(
                          fontSize: 75,
                          color: Colors.white,
                          fontFamily: 'RussoOne',
                          fontWeight: FontWeight.bold))),
              ConnectionStatusBar(
                height: 25,
                width: double.maxFinite,
                color: Colors.redAccent,
                lookUpAddress: 'google.com',
                endOffset: const Offset(0.0, 0.0),
                beginOffset: const Offset(0.0, -1.0),
                animationDuration: const Duration(milliseconds: 200),
                title: Text(
                  'Please check your internet connection :(',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ]),
            MovieCard(
              movieid: movieId3,
              listitem: posters3,
              initialString: 'Now Playing',
              responsecode: responsecode,
              seewhat: 'now_playing',
              type: 'movie',
            ),

            // Ads
            responsecode == null
            ? Container()
            : AdmobBanner(
              adUnitId: ams.getBannerAdId(), 
              adSize: AdmobBannerSize.FULL_BANNER,
              ),

            MovieCard(
                movieid: movieId,
                listitem: posters,
                initialString: 'Currently Popular Movies',
                responsecode: responsecode,
                seewhat: 'popular',
                type: 'movie'),


            responsecode == null
            ? Container()
            : AdmobBanner(
              adUnitId: ams.getBannerAdId(), 
              adSize: AdmobBannerSize.FULL_BANNER,
              ),

            MovieCard(
              movieid: movieId2,
              listitem: posters2,
              initialString: 'Top Rated Movies',
              responsecode: responsecode,
              seewhat: 'top_rated',
              type: 'movie',
            ),

            responsecode == null
            ? Container()

            : AdmobBanner(
              adUnitId: ams.getBannerAdId(), 
              adSize: AdmobBannerSize.FULL_BANNER,
              ),


            MovieCard(
                movieid: movieId5,
                listitem: posters5,
                initialString: 'Movies For You',
                seewhat: 'top_rated',
                type: 'movie',
                responsecode: responsecode),

              responsecode == null
            ? Container()
            :
              AdmobBanner(
              adUnitId: ams.getBannerAdId(), 
              adSize: AdmobBannerSize.FULL_BANNER,
              ),
          ],
        ),
      )),
    );
  }

}
