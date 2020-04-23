import 'package:flutter/material.dart';
import 'package:Flick/ui/tv_cards.dart';
import 'package:Flick/services/APIhome.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:Flick/services/admob_service.dart';

class TvPage extends StatefulWidget {
  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  final ams = AdMobService();

  List<String> posters, posters2, posters3 = [];
  List<int> movieId, movieId2, movieId3 = [];

  int responsecode;

  void getMovies() async {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    Random random = new Random();
    int page = random.nextInt(20) + 1;

    Getmovie popular =
        Getmovie(url: 'https://api.themoviedb.org/3/tv/popular?api_key=$key');
    Getmovie toprated =
        Getmovie(url: 'https://api.themoviedb.org/3/tv/top_rated?api_key=$key');
    Getmovie randompicked = Getmovie(
        url:
            'https://api.themoviedb.org/3/tv/top_rated?api_key=$key&language=en-US&page=$page');

    await popular.topRatedMoives();
    await toprated.topRatedMoives();
    await randompicked.topRatedMoives();

    setState(() {
      responsecode = popular.responsecode;

      posters = popular.posterPath;
      movieId = popular.id;

      posters2 = toprated.posterPath;
      movieId2 = toprated.id;

      posters3 = randompicked.posterPath;
      movieId3 = randompicked.id;
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
        // Here i can put pageview
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
                        image: AssetImage('assets/series.jpg'),
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
                  child: Text('TV',
                      style: TextStyle(
                          fontSize: 75,
                          fontFamily: 'RussoOne',
                          color: Colors.white,
                          fontWeight: FontWeight.bold))),
            ]),
            TvCard(
                movieid: movieId,
                listitem: posters,
                initialString: 'Currently Popular TV Shows',
                responsecode: responsecode,
                seewhat: 'popular',
                type: 'tv'),
            responsecode == null
            ? Container()

            : AdmobBanner(
              adUnitId: ams.getBannerAdId(),
              adSize: AdmobBannerSize.FULL_BANNER,
            ),
            TvCard(
                movieid: movieId2,
                listitem: posters2,
                initialString: 'Top Rated TV Shows',
                responsecode: responsecode,
                seewhat: 'top_rated',
                type: 'tv'),

            responsecode == null
            ? Container()

            : AdmobBanner(
              adUnitId: ams.getBannerAdId(),
              adSize: AdmobBannerSize.FULL_BANNER,
            ),
            TvCard(            
                movieid: movieId3,
                listitem: posters3,
                initialString: 'TV Shows For You',
                responsecode: responsecode,
                seewhat: 'top_rated',
                type: 'tv'),
            
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
