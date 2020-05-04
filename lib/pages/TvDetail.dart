import 'dart:convert';
import 'package:Flick/pages/Recommendation.dart';
import 'package:Flick/pages/Review.dart';
import 'package:Flick/pages/SeasonDetail.dart';
import 'package:Flick/ui/Cast.dart';
import 'package:Flick/ui/VideoPlayer.dart';
import 'package:Flick/ui/successAlert.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/utils/functions.utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';

class TvDetail extends StatefulWidget {
  final int movieId;
  TvDetail({@optionalTypeArgs this.movieId});
  @override
  _TvDetailState createState() => _TvDetailState();
}

class _TvDetailState extends State<TvDetail> {
  // Get the WatchList Data
  List<String> watchlist, bg = [];
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

  // Set the WatchList
  void setWatchListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('seriesid', watchlist);
    prefs.setStringList('seriescoverimg', bg);
  }

  @override
  void initState() {
    getWatchListData();
    setWatchListData();
    super.initState();
  }

  // Stream for TV Detail
  Stream detailStream() async* {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    int id = widget.movieId;
    Response response = await get(
        'https://api.themoviedb.org/3/tv/$id?api_key=$key&language=en-US');
    Map data = jsonDecode(response.body);
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    String backdrop = '';
    String poster = '';
    String networkimg = '';
    String title = '';
    int id;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: StreamBuilder(
              stream: detailStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  backdrop = snapshot.data['backdrop_path'];
                  poster = snapshot.data['poster_path'];
                  title = snapshot.data['name'];
                  id = snapshot.data['id'];
                  if (snapshot.data['networks'].length == 0) {
                    networkimg = 'https://i.ibb.co/CvCHJ7N/error.png';
                  } else {
                    networkimg = snapshot.data['networks'][0]['logo_path'];
                  }
                }

                void updateWatchlist() {
                  if (watchlist == null ||
                      !watchlist.contains(id.toString()) ||
                      !bg.contains(poster)) {
                    watchlist.add(id.toString());
                    bg.add(poster);
                    setWatchListData();
                    getWatchListData();
                    SuccessBgAlertBox(
                        context: context,
                        title: title + ' added to your watch list',
                        titleTextColor: Colors.black,
                        infoMessage: '',
                        buttonText: 'Ok',
                        buttonTextColor: Colors.black,
                        buttonColor: Colors.white);
                  } else {
                    watchlist.remove(id.toString());
                    bg.remove(poster);
                    setWatchListData();
                    getWatchListData();
                    DarkBgAlertBox(
                        context: context,
                        messageTextColor: Colors.white,
                        title: title + ' removed from your watch list',
                        titleTextColor: Colors.red,
                        infoMessage: '',
                        buttonText: 'Ok',
                        buttonTextColor: Colors.black,
                        buttonColor: Colors.white);
                  }
                }

                return !snapshot.hasData
                    ? Container(
                        height: height,
                        width: width,
                        child: Center(
                          child: SpinKitFadingCube(
                            color: Colors.white,
                            size: 200,
                          ),
                        ),
                      )
                    : Column(children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 120, left: 20),
                              height: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.4),
                                          BlendMode.dstATop),
                                      image: NetworkImage(backdrop == null
                                          ? ''
                                          : "https://image.tmdb.org/t/p/w500/$backdrop") // Cover img
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
                                        backgroundImage: NetworkImage(poster ==
                                                null
                                            ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                            : 'https://image.tmdb.org/t/p/w200/$poster'),
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
                                                    Text(snapshot.data['name'],
                                                        style: TextStyle(
                                                            fontSize: snapshot
                                                                        .data[
                                                                            'name']
                                                                        .length >
                                                                    26
                                                                ? 12
                                                                : 15,
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
                                                CircleAvatar(
                                                    radius: 9,
                                                    backgroundImage: NetworkImage(
                                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png'),
                                                    backgroundColor:
                                                        Colors.transparent),
                                                SizedBox(width: 8),
                                                Text(
                                                    snapshot
                                                        .data['vote_average']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                SizedBox(width: 8),
                                                Text('|'),
                                                SizedBox(width: 8),
                                                snapshot.data['vote_count'] ==
                                                        null
                                                    ? Text('N/A')
                                                    : Text(snapshot
                                                            .data['vote_count']
                                                            .toString() +
                                                        ' votes'),
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
                                                snapshot.data[
                                                            'first_air_date'] ==
                                                        null
                                                    ? Text('N/A')
                                                    : Text(
                                                        snapshot.data[
                                                            'first_air_date'],
                                                        style: TextStyle(
                                                            fontSize: 15)),
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
                                              snapshot.data['episode_run_time']
                                                          .length ==
                                                      0
                                                  ? Text('N/A')
                                                  : Text(
                                                      snapshot.data[
                                                                  'episode_run_time']
                                                                  [0]
                                                              .toString() +
                                                          ' min',
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                            ]),
                                            SizedBox(height: 8),
                                            Row(children: <Widget>[
                                              Icon(
                                                Icons.language,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 8),
                                              snapshot.data['languages']
                                                          .length ==
                                                      0
                                                  ? Text('N/A')
                                                  : Text(
                                                      snapshot.data['languages']
                                                              [0]
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 15)),
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
                                  snapshot.data['name'],
                                  style: TextStyle(fontSize: 18),
                                )),
                          ),
                          Container(
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
                                                      .contains(id.toString())
                                                  ? Colors.white
                                                  : Colors.red,
                                              child: !watchlist
                                                      .contains(id.toString())
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
                                        })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: snapshot.data['genres'].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    SizedBox(width: 20),
                                    Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            color: Colors.white),
                                        child: Text(
                                            '# ' +
                                                snapshot.data['genres'][index]
                                                        ['name']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)))
                                  ],
                                );
                              }),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: snapshot.data['status'] ==
                                                    'Returning Series'
                                                ? Colors.green
                                                : Colors.red)),
                                    SizedBox(width: 10),
                                    Text(snapshot.data['status']
                                        .toString()
                                        .toUpperCase()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          String title = snapshot.data['name'];
                                          launch(
                                            'https://europixhd.pro/search?search=$title',
                                          );
                                        },
                                        child: Image.network(
                                            'https://cdn.cybrhome.com/media/website/live/favicon/fav_hdeuropix.com_cc68ad.ico',
                                            width: 50)),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                        onTap: () {
                                          String title = snapshot.data['name'];
                                          launch(
                                            'https://fmovies.to/search?keyword=$title',
                                          );
                                        },
                                        child: Image.network(
                                            'https://img3.apk.tools/img/a4UgMaYjxfHCEqwYY6YsbbitxDg-aCY9AWiI3b3KaFJDMG-Z796HHZSjs1SheFUhu4w=s150',
                                            width: 50)),
                                  ],
                                ),
                              ],
                            )
                          ]),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Score',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('RATE',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(snapshot.data['vote_average'].toString(),
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
                        MyVideoPlayer(id: widget.movieId, movieortv: 'tv'),

                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Popularity'),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.scatter_plot),
                                  SizedBox(width: 8),
                                  Text('SERIES PLOT',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text(snapshot.data['popularity'].toString(),
                                  style: TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: ExpandText(
                              snapshot.data['overview'].toString(),
                              maxLength: 3),
                        ),

                        //

                        Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.info),
                                    SizedBox(width: 8),
                                    Text('SERIES INFO',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                FlatButton.icon(
                                    onPressed: () {
                                      showBarModalBottomSheet(
                                        barrierColor: Colors.black38,
                                        useRootNavigator: true,
                                        context: context,
                                        builder: (context, scrollController) =>
                                            CastNdCrew(
                                                id: widget.movieId,
                                                movieortv: 'tv'),
                                      );
                                    },
                                    icon: Icon(Icons.contacts),
                                    label: Text("CAST"))
                              ],
                            )),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('NO. OF SEASONS'),
                                Text('NO. OF EPISODES')
                              ]),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 40, right: 40, top: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    snapshot.data['number_of_seasons']
                                        .toString(),
                                    style: TextStyle(fontSize: 22)),
                                Text(
                                    snapshot.data['number_of_episodes']
                                        .toString(),
                                    style: TextStyle(fontSize: 22)),
                              ]),
                        ),
                        SizedBox(height: 20),
                        Container(
                            height: 60,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data['number_of_seasons'],
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: <Widget>[
                                      SizedBox(width: 30),
                                      GestureDetector(
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            screen: SeasonDetail(
                                              title: snapshot.data['name']
                                                  .toString(),
                                              backdrop: snapshot
                                                  .data['backdrop_path']
                                                  .toString(),
                                              id: widget.movieId,
                                              seasonsnumber: index + 1,
                                            ),
                                            withNavBar: false,
                                          );
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                  'S' + (index + 1).toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            )),
                                      ),
                                    ],
                                  );
                                })),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Tap to see season detail',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Row(children: <Widget>[
                            Icon(Icons.near_me),
                            SizedBox(width: 10),
                            Text('SERIES NETWORK',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                        Container(
                            padding:
                                EdgeInsets.only(left: 30, right: 20, top: 10),
                            child: Row(children: <Widget>[
                              Container(
                                width: 90,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        alignment: Alignment.center,
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(
                                          'http://image.tmdb.org/t/p/w500$networkimg',
                                        ))),
                              )
                            ])),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.sentiment_satisfied),
                              SizedBox(width: 10),
                              Text("SIMILAR TV SHOWS",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        SimilarTvShows(
                          id: widget.movieId,
                          movieortv: 'tv',
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person_pin),
                              SizedBox(width: 10),
                              Text('USER REVIEWS',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        Container(
                            child: Reviews(
                                movieortv: 'tv', movieId: widget.movieId)),
                      ]);
              })),
    );
  }
}
