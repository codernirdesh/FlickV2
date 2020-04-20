import 'package:flick/ui/successAlert.dart';
import 'package:flick/services/APItv_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';

class TvDetail extends StatefulWidget {
  final int movieId;
  TvDetail({@optionalTypeArgs this.movieId});
  @override
  _TvDetailState createState() => _TvDetailState();
}

class _TvDetailState extends State<TvDetail> {
  YoutubePlayerController _controller;

  String movieid, createdby, genre, year, rating, plot, coverimg, tagline = '';
  String img, language, status, origincountry, lastEpisode, title = '';
  int code;
  double votes, popularity, rated = 0;
  int voteCount, revenue, runtime, budget, seasons, episodes = 0;
  String website = 'N/A';
  List<String> watchlist, bg = [];
  String videourl = 'g8K21P8CoeI';

  void setWatchListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('seriesid', watchlist);
    prefs.setStringList('seriescoverimg', bg);
  }

  void getWatchListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> name = prefs.getStringList('seriesid');
    List<String> background = prefs.getStringList('seriescoverimg');
    if (name == null || background == null) {
      watchlist = [];
      bg = [];
    } else {
      watchlist = name;
      bg = background;
    }
  }

  void dataFetch(movieId) async {
    TvApiFetch instance = TvApiFetch(
        url:
            'https://api.themoviedb.org/3/tv/$movieId?api_key=a71008231061acb3b96b658e8afb1ca3&language=en-US');
    await instance.getData();
    setState(() {
      title = instance.title;
      year = instance.year;
      img = instance.img;
      code = instance.responsecode;
      coverimg = instance.coverimg;
      plot = instance.plot;
      runtime = instance.runtime;
      if (instance.videourl == null) {
        videourl = 'null';
      } else {
        videourl = instance.videourl;
      }

      votes = instance.voteAverage;
      if (votes == null) {
        votes = 0;
      }
      tagline = instance.tagline;
      voteCount = instance.voteCount;
      website = instance.homepage;
      budget = instance.budget;
      revenue = instance.revenue;
      popularity = instance.popularity;
      movieid = instance.movieid;
      language = instance.language;
      status = instance.status;
      origincountry = instance.origincountry;
      lastEpisode = instance.lastEpisode;
      episodes = instance.episodes;
      seasons = instance.seasons;
      createdby = instance.createdby;
      genre = instance.genre;
    });
  }

  @override
  void initState() {
    super.initState();
    getWatchListData();
    dataFetch(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController(
        initialVideoId: videourl,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          loop: false,
        ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              child: code == null
                  ? Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3.5),
                      child: SpinKitFadingCube(
                        color: Colors.orange,
                        size: 200,
                      ),
                    )
                  : Stack(children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 100, left: 20),
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: new ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.dstATop),
                                  image: NetworkImage(img == null
                                      ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                      : 'https://image.tmdb.org/t/p/w300/$img') // Cover img
                                  ),
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35))),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                      backgroundImage: NetworkImage(img == null
                                          ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                          : 'https://image.tmdb.org/t/p/w200/$img'),
                                      radius: 60,
                                      backgroundColor: Colors.transparent),
                                  SizedBox(width: 15),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.movie,
                                                size: 20, color: Colors.white),
                                            SizedBox(width: 8),
                                            Column(
                                              children: <Widget>[
                                                title.length > 26
                                                    ? Text('$title',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                    : Text('$title',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text('$year',
                                                style: TextStyle(fontSize: 15)),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                                radius: 9,
                                                backgroundImage: NetworkImage(
                                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png'),
                                                backgroundColor:
                                                    Colors.transparent),
                                            SizedBox(width: 8),
                                            Text('$votes',
                                                style: TextStyle(fontSize: 15)),
                                            SizedBox(width: 8),
                                            Text('|'),
                                            SizedBox(width: 8),
                                            Text('$voteCount votes'),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(children: <Widget>[
                                          Icon(
                                            Icons.timer,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text('$runtime  min',
                                              style: TextStyle(fontSize: 15)),
                                        ]),
                                        SizedBox(height: 8),
                                        Row(children: <Widget>[
                                          Icon(
                                            Icons.gavel,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text('$genre',
                                              style: TextStyle(fontSize: 15)),
                                        ]),
                                        SizedBox(height: 8),
                                        Row(children: <Widget>[
                                          Container(
                                            width: 25,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        'https://www.countryflags.io/$origincountry/flat/64.png'))),
                                          ),
                                          SizedBox(width: 8),
                                          Text('$language'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                      ]),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 25),
                        child: FlatButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                            label: Text(
                              '$title',
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                      code == null
                          ? Text('')
                          : Container(
                              margin: EdgeInsets.only(top: 170, right: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            updateWatchList();
                                          });
                                        },
                                        child: AvatarGlow(
                                          glowColor: Colors.white,
                                          endRadius: 60.0, //required
                                          child: Material(
                                            //required
                                            elevation: 20.0,
                                            shape: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  !watchlist.contains(movieid)
                                                      ? Colors.white
                                                      : Colors.red,
                                              child: !watchlist
                                                      .contains(movieid)
                                                  ? Icon(Icons.add_to_queue,
                                                      size: 30)
                                                  : Icon(
                                                      Icons.remove_from_queue,
                                                      size: 30,
                                                      color: Colors.white),
                                              radius: 30.0,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ])),
          SizedBox(height: 20),
          code == null
              ? Text('')
              : Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.only(left: 22, right: 20, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: status == 'Returning Series'
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(90))),
                          Text('   $status'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Score',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('Your Rating  $rated',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('$votes',
                                  style: TextStyle(
                                      fontSize: 55,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold)),
                              RatingBar(
                                glowColor: Colors.amber,
                                initialRating: 0,
                                itemSize: 40,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                unratedColor: Colors.grey,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    rated = rating * 2.0;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          videourl == 'null'
                              ? Text('No videos found :(')
                              : YoutubePlayer(
                                  aspectRatio: 16 / 9,
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                  progressColors: ProgressBarColors(
                                      playedColor: Colors.red,
                                      bufferedColor: Colors.grey)),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Popularity'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('SERIES PLOT',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold)),
                              Text('$popularity',
                                  style: TextStyle(fontSize: 25)),
                            ],
                          ),
                          SizedBox(height: 30),
                          Text('$plot',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(height: 20),
                          Text(
                            'Official Website',
                            style: TextStyle(fontSize: 19),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            child: Text(
                              '$website',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.blue),
                            ),
                            onTap: () => launch('$website'),
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('LAST EPISODE AIR DATE ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                              Text('NEXT EP. ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('$lastEpisode'),
                              Text('nextep',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('SEASONS',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink)),
                              Text('EPISODES',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('$seasons',
                                    style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text('$episodes',
                                    style: TextStyle(
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('CREATED BY',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold)),
                            Text('$createdby'.toUpperCase(),
                                style: TextStyle(fontSize: 18)),
                          ]),
                      SizedBox(height: 40),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.info, size: 30),
                            SizedBox(width: 20),
                            Text('SEASONS INFO',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                          ]),
                      SizedBox(height: 20),
                      Center(child: Text('Feature will be added soon...'))
                    ],
                  ))
        ],
      ),
    );
  }

  void updateWatchList() {
    if (watchlist == null ||
        !watchlist.contains(movieid) ||
        !bg.contains(img)) {
      watchlist.add(movieid);
      bg.add(img);
      setWatchListData();
      getWatchListData();
      
      SuccessBgAlertBox(
          context: context,
          title: '$title added to your watch list',
          titleTextColor: Colors.black,
          infoMessage: '',
          buttonText: 'Ok',
          buttonTextColor: Colors.black,
          buttonColor: Colors.white);
    } else {
      watchlist.remove(movieid);
      bg.remove(img);
      setWatchListData();
      getWatchListData();      
      DarkBgAlertBox(
          context: context,
          messageTextColor: Colors.white,
          title: '$title removed from your watch list',
          titleTextColor: Colors.red,
          infoMessage: '',
          buttonText: 'Ok',
          buttonTextColor: Colors.black,
          buttonColor: Colors.white);
    }
  }
}
