import 'dart:convert';
import 'package:Flick/pages/Recommendation.dart';
import 'package:Flick/pages/Review.dart';
import 'package:Flick/ui/VideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:async';
import 'package:Flick/ui/successAlert.dart';
import 'package:Flick/models/MovieDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flick/ui/Cast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:expand_widget/expand_widget.dart';

class MovieDetail extends StatefulWidget {
  final int movieId;
  MovieDetail({@optionalTypeArgs this.movieId});
  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  int code;
  List<String> watchlist, cover = [];
  String videourl = 'g8K21P8CoeI';
  dynamic userrating = 0.0;
  var posterpath, backdroppath;
  String netflixurl = '';

  void setWatchListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('moviesId', watchlist);
    prefs.setStringList('moviecover', cover);
  }

  void getWatchListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> name = prefs.getStringList('moviesId');
    List<String> cvr = prefs.getStringList('moviecover');

    if (name == null || cvr == null) {
      watchlist = [];
      cover = [];
    } else {
      cover = cvr;
      watchlist = name;
    }
  }

  void updateWatchlist() {
    if (watchlist == null ||
        !watchlist.contains(data['id'].toString()) ||
        !cover.contains(data['poster_path'])) {
      watchlist.add(data['id'].toString());
      cover.add(data['poster_path']);
      setWatchListData();
      getWatchListData();
      SuccessBgAlertBox(
          context: context,
          title: data['title'] + ' added to your watch list',
          titleTextColor: Colors.black,
          infoMessage: '',
          buttonText: 'Ok',
          buttonTextColor: Colors.black,
          buttonColor: Colors.white);
    } else {
      watchlist.remove(data['id'].toString());
      cover.remove(data['poster_path']);
      setWatchListData();
      getWatchListData();
      DarkBgAlertBox(
          context: context,
          messageTextColor: Colors.white,
          title: data['title'] + ' removed from your watch list',
          titleTextColor: Colors.red,
          infoMessage: '',
          buttonText: 'Ok',
          buttonTextColor: Colors.black,
          buttonColor: Colors.white);
    }
  }

  Map data;
  String video = '';
  String key = 'a71008231061acb3b96b658e8afb1ca3';
  int similarMoviesCount;
  List<String> similarMovies = [];
  List<int> similarMoviesId = [];
  List<String> genres = [];
  int genreLen = 0;

  Future<void> getMovieDetail(id) async {
    Response response = await get(
        'https://api.themoviedb.org/3/movie/$id?api_key=$key&language=en-US');

    Map json = jsonDecode(response.body);
    Detail instance = Detail.jsonparse(json);
    int statuscode = response.statusCode;

    setState(() {
      data = instance.toJson();
      posterpath = data['poster_path'];
      backdroppath = data['backdrop_path'];
      genreLen = data['genres'].length;
      for (int i = 0; i < genreLen; i++) {
        genres.add(data['genres'][i].name);
      }
      code = statuscode;
    });
  }

  @override
  void initState() {
    getWatchListData();
    getMovieDetail(widget.movieId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      String website = data['homepage'];
      if (website.length > 20 &&
          website.substring(0, 20) == 'https://www.netflix.') {
        netflixurl = data['homepage'];
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                child: code == null
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: SpinKitFadingCube(
                            color: Colors.white,
                            size: 200,
                          ),
                        ),
                      )
                    : Stack(children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(top: 120, left: 20),
                            height: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.black.withOpacity(0.4),
                                        BlendMode.dstATop),
                                    image: NetworkImage(backdroppath == null
                                        ? ''
                                        : "https://image.tmdb.org/t/p/w500/$backdroppath") // Cover img
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
                                      backgroundImage: NetworkImage(posterpath ==
                                              null
                                          ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                          : 'https://image.tmdb.org/t/p/w200/$posterpath'),
                                      radius: 60,
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.movie,
                                                  size: 20,
                                                  color: Colors.white),
                                              SizedBox(width: 8),
                                              Column(
                                                children: <Widget>[
                                                  Text(data['title'],
                                                      style: TextStyle(
                                                          fontSize: data['title']
                                                                      .length >
                                                                  26
                                                              ? 12
                                                              : 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                                              Text(data['release_date'],
                                                  style:
                                                      TextStyle(fontSize: 15)),
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
                                              Text(
                                                  data['vote_average']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              SizedBox(width: 8),
                                              Text('|'),
                                              SizedBox(width: 8),
                                              Text(data['vote_count']
                                                      .toString() +
                                                  ' votes'),
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
                                            Text(
                                                data['runtime'].toString() +
                                                    ' min',
                                                style: TextStyle(fontSize: 15)),
                                          ]),
                                          SizedBox(height: 8),
                                          Row(children: <Widget>[
                                            Icon(
                                              Icons.language,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                                data['original_language']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(fontSize: 15)),
                                          ])
                                        ]),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 45),
                          child: FlatButton.icon(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios),
                              label: Text(
                                data['title'],
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        code == null
                            ? Text('')
                            : Container(
                                margin: EdgeInsets.only(top: 190, right: 10),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          child: AvatarGlow(
                                            startDelay: Duration(seconds: 3),
                                            glowColor: Colors.white,
                                            endRadius: 60.0, //required
                                            child: Material(
                                              //required
                                              elevation: 20.0,
                                              shape: CircleBorder(),
                                              child: CircleAvatar(
                                                backgroundColor: !watchlist
                                                        .contains(data['id']
                                                            .toString())
                                                    ? Colors.white
                                                    : Colors.red,
                                                child: !watchlist.contains(
                                                        data['id'].toString())
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
                                          onTap: () {
                                            setState(() {
                                              updateWatchlist();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ])),
            SizedBox(height: 10),
            code == null
                ? Text('')
                : Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        genreLen != 0
                            ? Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: genreLen,
                                    itemBuilder: (BuildContext context, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(width: 20),
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200),
                                                  color: Colors.white),
                                              child: Text(
                                                  '# ' +
                                                      genres[index].toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)))
                                        ],
                                      );
                                    }),
                              )
                            : Text(''),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Text('# ' + data['tagline'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(right: 20, left: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      String title = data['title'];
                                      launch(
                                        'https://fmovies.to/search?keyword=$title',
                                      );
                                    },
                                    child: Image.network(
                                        'https://img3.apk.tools/img/a4UgMaYjxfHCEqwYY6YsbbitxDg-aCY9AWiI3b3KaFJDMG-Z796HHZSjs1SheFUhu4w=s150',
                                        width: 50)),
                                netflixurl != ''
                                    ? GestureDetector(
                                        onTap: () {
                                          launch(
                                            data['homepage'].toString(),
                                          );
                                        },
                                        child: Image.network(
                                            'https://www.freepnglogos.com/uploads/netflix-logo-circle-png-5.png',
                                            width: 70))
                                    : SizedBox(width: 10),
                                GestureDetector(
                                    onTap: () {
                                      String title = data['title'];
                                      launch(
                                        'https://europixhd.pro/search?search=$title',
                                      );
                                    },
                                    child: Image.network(
                                        'https://cdn.cybrhome.com/media/website/live/favicon/fav_hdeuropix.com_cc68ad.ico',
                                        width: 50)),
                              ]),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Score',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(data['vote_average'].toString(),
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
                                    onRatingUpdate: (rating) {},
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.language),
                                      SizedBox(width: 10),
                                      Text(
                                        'Official Website',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  FlatButton.icon(
                                      onPressed: () {
                                        showBarModalBottomSheet(
                                          barrierColor: Colors.black38,
                                          useRootNavigator: true,
                                          context: context,
                                          builder:
                                              (context, scrollController) =>
                                                  CastNdCrew(
                                                      id: widget.movieId,
                                                      movieortv: 'movie'),
                                        );
                                      },
                                      icon: Icon(Icons.contacts),
                                      label: Text('CAST'))
                                ],
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Text(
                                  data['homepage'].toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                ),
                                onTap: () =>
                                    launch(data['homepage'].toString()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.ondemand_video),
                                  SizedBox(width: 10),
                                  Text('VIDEO',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  children: <Widget>[
                                    Text('Swipe for more videos'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                    SizedBox(width: 5),
                                    Icon(Icons.info_outline, size: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        MyVideoPlayer(
                          id: widget.movieId,
                          movieortv: 'movie',
                        ),

                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Popularity'),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.movie_creation),
                                  SizedBox(width: 10),
                                  Text('MOVIE PLOT',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text(data['popularity'].toString(),
                                  style: TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ExpandText(data['overview'],
                              maxLength: 3,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                        // Text(),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.sentiment_satisfied),
                              SizedBox(width: 10),
                              Text('SIMILAR MOVIES',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SimilarTvShows(
                          id: widget.movieId,
                          movieortv: 'movie',
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person_pin),
                              SizedBox(width: 10),
                              Text('USER REVIEWS',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    )),
            Reviews(
              movieId: widget.movieId,
              movieortv: 'movie',
            ),
          ],
        ),
      ),
    );
  }
}
