import 'dart:convert';
import 'package:Flick/pages/MovieDetail.dart';
import 'package:Flick/pages/TvDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar/utils/functions.utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ModalwithBar extends StatefulWidget {
  const ModalwithBar({
    Key key,
    this.type,
    this.movieOrTv,
  }) : super(key: key);

  final String type;
  final String movieOrTv;

  @override
  _ModalwithBarState createState() => _ModalwithBarState();
}

class _ModalwithBarState extends State<ModalwithBar> {
  int pageno = 2;
  Stream getItem(pageno) async* {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    String type = widget.type;
    String movieOrTv = widget.movieOrTv;
    Response response = await get(
        'https://api.themoviedb.org/3/$movieOrTv/$type?api_key=$key&language=en-US&page=$pageno');
    yield jsonDecode(response.body);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    setState(() {
      pageno += 1;
    });
    getItem(pageno);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Scaffold(
            backgroundColor: Color(0xFF1e1e1e),
            body: Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    StreamBuilder(
                        stream: getItem(pageno),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? Center(
                                  child: Padding(
                                  padding: EdgeInsets.only(top: 160),
                                  child: SpinKitDualRing(color: Colors.grey),
                                ))
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.58,
                                  child: SmartRefresher(
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
                                    child: ListView.builder(
                                        itemCount:
                                            snapshot.data['results'].length,
                                        itemBuilder: (context, index) {
                                          String img = snapshot.data['results']
                                              [index]['poster_path'];
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      pushNewScreen(
                                                        context,
                                                        screen: widget
                                                                    .movieOrTv ==
                                                                'tv'
                                                            ? TvDetail(
                                                                movieId: snapshot
                                                                            .data[
                                                                        'results'][index]
                                                                    ['id'])
                                                            : MovieDetail(
                                                                movieId: snapshot
                                                                            .data[
                                                                        'results']
                                                                    [
                                                                    index]['id']),
                                                        withNavBar: false,
                                                      );
                                                    },
                                                    child: img == null
                                                        ? Container(
                                                            width: 130,
                                                            height: 130,
                                                            child: Center(
                                                              child: Icon(
                                                                  Icons
                                                                      .sentiment_very_dissatisfied,
                                                                  size: 120,
                                                                  color: Colors
                                                                      .grey),
                                                            ))
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                "http://image.tmdb.org/t/p/w200$img",
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                                  width: 130,
                                                                  height: 130,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                SpinKitDoubleBounce(
                                                                    color: Colors
                                                                        .white,
                                                                    size: 30),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Text('')),
                                                  ),
                                                  SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(height: 10),
                                                      widget.movieOrTv == 'tv'
                                                          ? Text(snapshot.data['results'][index]['name'],
                                                              style: snapshot.data['results'][index]['name'].length > 20
                                                                  ? TextStyle(
                                                                      color: Colors
                                                                          .amber)
                                                                  : TextStyle(
                                                                      color: Colors
                                                                          .amber,
                                                                      fontSize:
                                                                          20))
                                                          : Text(snapshot.data['results'][index]['title'],
                                                              style: snapshot.data['results'][index]['title'].length > 20
                                                                  ? TextStyle(
                                                                      color: Colors
                                                                          .amber)
                                                                  : TextStyle(
                                                                      color: Colors.amber,
                                                                      fontSize: 20)),
                                                      SizedBox(height: 10),
                                                      Text(
                                                          snapshot
                                                              .data['results']
                                                                  [index][
                                                                  'vote_average']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30)),
                                                      SizedBox(height: 10),
                                                      Text(
                                                          snapshot.data[
                                                                      'results']
                                                                      [index][
                                                                      'vote_count']
                                                                  .toString() +
                                                              ' votes',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Tap on image to see detail',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          );
                                        }),
                                  ),
                                );
                        })
                  ]),
            ))));
  }
}
