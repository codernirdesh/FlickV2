import 'package:flutter/material.dart';
import 'package:flick/ui/movie_cards.dart';
import 'package:flick/services/APIhome.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  List<String> movietitles,
      movietitles2,
      movietitles3,
      movietitles4,
      movietitles5 = [];
  List<String> posters, posters2, posters3, posters4, posters5 = [];
  List<int> movieId, movieId2, movieId3, movieId4, movieId5 = [];

  int responsecode;

  List<String> images = [
    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg',
    'https://adastra.ca/wp-content/uploads/2016/01/horizontal-portada.jpg',
  ];

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
    Getmovie trending = Getmovie(
        url:
            'https://api.themoviedb.org/3/trending/all/day?api_key=$key&page=2');
    Getmovie moviesforyou = Getmovie(
        url:
            'https://api.themoviedb.org/3/trending/all/day?api_key=$key&page=$page');

    await popular.topRatedMoives();
    await toprated.topRatedMoives();
    await nowplaying.topRatedMoives();
    await trending.topRatedMoives();
    await moviesforyou.topRatedMoives();

    setState(() {
      responsecode = popular.responsecode;

      movietitles = popular.titles;
      posters = popular.posterPath;
      movieId = popular.id;
      movietitles2 = toprated.titles;
      posters2 = toprated.posterPath;
      movieId2 = toprated.id;

      movietitles3 = nowplaying.titles;
      posters3 = nowplaying.posterPath;
      movieId3 = nowplaying.id;

      movietitles4 = trending.titles;
      posters4 = trending.posterPath;
      movieId4 = trending.id;

      movietitles5 = moviesforyou.titles;
      posters5 = moviesforyou.posterPath;
      movieId5 = moviesforyou.id;
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() {
    getMovies();

    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    getMovies();
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
                  child: Text('MOVIES',
                      style: TextStyle(
                          fontSize: 80,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))),
            ]),
            MovieCard(
                movieid: movieId3,
                listitem: posters3,
                initialString: 'Now Playing',
                responsecode: responsecode),
            MovieCard(
                movieid: movieId,
                listitem: posters,
                initialString: 'Currently Popular Movies',
                responsecode: responsecode),
            MovieCard(
                movieid: movieId2,
                listitem: posters2,
                initialString: 'Top IMDb Rated Movies',
                responsecode: responsecode),
            MovieCard(
                movieid: movieId4,
                listitem: posters4,
                initialString: 'Trending',
                responsecode: responsecode),
            MovieCard(
                movieid: movieId5,
                listitem: posters5,
                initialString: 'Movies For You',
                responsecode: responsecode),
          ],
        ),
      )),
    );
  }
}
