import 'package:Flick/pages/detailed_tv.dart';
import 'package:Flick/ui/shimmerCards.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:Flick/extra/iterablezip.dart';
import 'package:Flick/pages/detailed_movie.dart';
import 'package:Flick/services/APIhome.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomSheetx extends StatefulWidget {
  final String seewhat;
  final String type;
  BottomSheetx({@required this.seewhat, @required this.type});

  @override
  _BottomSheetxState createState() => _BottomSheetxState();
}

class _BottomSheetxState extends State<BottomSheetx> {
  // List<String> movietitles, tvtitles = [];
  List<String> posters = [];
  List<int> movieId = [];
  List<dynamic> ratings = [];

  int responsecode;
  int pageno = 1;

  void getMovies(pageno, type, movieortv) async {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    Getmovie popular = Getmovie(
        url:
            'https://api.themoviedb.org/3/$movieortv/$type?api_key=$key&page=$pageno');

    await popular.topRatedMoives();

    setState(() {
      responsecode = popular.responsecode;
      // movietitles = popular.titles;
      posters = popular.posterPath;
      movieId = popular.id;
      ratings = popular.rating;
      // tvtitles = popular.tvtitle;
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() {
    setState(() {
      pageno += 1;
    });
    getMovies(pageno, widget.seewhat, widget.type);
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
        child: Container(
          padding: responsecode == null
              ? EdgeInsets.only(top: 20)
              : EdgeInsets.only(left: 5, right: 5, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            color: Color(0xFF1e1e1e),

            //
          ),
          child: Scrollbar(
            child: SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              child:
                  ListView(physics: BouncingScrollPhysics(), children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Pull down to load other',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Center(
                          child: SlideInUp(
                            child: Container(
                              padding: responsecode == null
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.only(
                                      left: 30, bottom: 30, top: 30),
                              width: responsecode == null
                                  ? MediaQuery.of(context).size.width / 1
                                  : MediaQuery.of(context).size.width / 1.04,
                              decoration: BoxDecoration(
                                // color: Colors.pink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: responsecode == null
                                  ? Column(
                                      children: <Widget>[
                                        Shimmer2(),
                                        SizedBox(height: 10),
                                        Shimmer2(),
                                        SizedBox(height: 10),
                                        Shimmer2(),
                                      ],
                                    )
                                  : Column(
                                      children: IterableZip([
                                      // movietitles,
                                      movieId,
                                      posters,
                                      ratings
                                    ]).map((data) {
                                      // String title = data[0];
                                      int id = data[0];
                                      String posterid = data[1];
                                      dynamic rating = data[2];

                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            screen: widget.type == 'movie'
                                                ? MovieDetail(movieId: id)
                                                : TvDetail(movieId: id),
                                            withNavBar: false,
                                          );
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    backgroundImage:
                                                        NetworkImage(posterid ==
                                                                null
                                                            ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                                            : 'https://image.tmdb.org/t/p/w200/$posterid'),
                                                    radius: 70),
                                                SizedBox(width: 30),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text('$rating',
                                                        style: TextStyle(
                                                            fontSize: 48,
                                                            color:
                                                                Colors.amber)),
                                                    // SizedBox(height: 10),
                                                    Text(
                                                        widget.type == 'movie'
                                                            ? 'Movie'
                                                            : 'Series',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.white)),
                                                    Text('Tap to see detail',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.grey)),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 40)
                                          ],
                                        ),
                                      );
                                    }).toList()),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ]),
            ),
          ),
        ));
  }
}
