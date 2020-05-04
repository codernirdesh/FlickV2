import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class SeasonDetail extends StatelessWidget {
  final String title;
  final String backdrop;
  final int id;
  final int seasonsnumber;
  SeasonDetail({this.title, this.backdrop, this.id, this.seasonsnumber});

  @override
  Widget build(BuildContext context) {
    Stream getSeason() async* {
      String key = 'a71008231061acb3b96b658e8afb1ca3';
      int i = seasonsnumber;
      Response response = await get(
          'https://api.themoviedb.org/3/tv/$id/season/$i?api_key=$key&language=en-US');
      yield jsonDecode(response.body);
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: StreamBuilder(
                stream: getSeason(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
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
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Stack(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 120, left: 20),
                                  height: 170,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: new ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.dstATop),
                                          image: snapshot.data['poster_path'] ==
                                                  null
                                              ? NetworkImage(
                                                  'https://i.ibb.co/CvCHJ7N/error.png')
                                              : NetworkImage(
                                                  "https://image.tmdb.org/t/p/w500" +
                                                      snapshot.data[
                                                          'poster_path']) // Cover img
                                          ),
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(35),
                                          bottomRight: Radius.circular(35))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 120, left: 20),
                                  child: Text(
                                    title.toUpperCase() +
                                        '\nSEASON $seasonsnumber',
                                    style: TextStyle(
                                        fontSize: 30, fontFamily: 'RussoOne'),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, top: 45),
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
                              ]),
                              SizedBox(height: 20),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.53,
                                child: ListView.builder(
                                    itemCount: snapshot.data['episodes'].length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.all(20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // color: Colors.white,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  snapshot.data['episodes'][index]
                                                              ['still_path'] ==
                                                          null
                                                      ? Container(
                                                          width: 150,
                                                          height: 150,
                                                          child: Icon(Icons
                                                              .sentiment_very_dissatisfied, size: 120))
                                                      : CachedNetworkImage(
                                                          imageUrl: 'https://image.tmdb.org/t/p/w200' +
                                                              snapshot.data['episodes']
                                                                      [index][
                                                                  'still_path'],
                                                          imageBuilder:
                                                              (context, imageProvider) =>
                                                                  Container(
                                                                    width: 150,
                                                                    height: 150,
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
                                                          placeholder: (context, url) =>
                                                              SpinKitDoubleBounce(
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30),
                                                          errorWidget:
                                                              (context, url, error) =>
                                                                  Text('')),
                                                  SizedBox(width: 40),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            '#' +
                                                                snapshot.data[
                                                                        'episodes']
                                                                        [index][
                                                                        'episode_number']
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 28,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          snapshot
                                                              .data['episodes']
                                                                  [index][
                                                                  'vote_average']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 23,
                                                              color:
                                                                  Colors.amber),
                                                        ),
                                                        Text(
                                                          snapshot.data[
                                                                      'episodes']
                                                                  [index]
                                                              ['air_date'],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ])
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                snapshot.data['episodes'][index]
                                                    ['name'],
                                                style: TextStyle(
                                                    fontSize: snapshot
                                                                .data[
                                                                    'episodes']
                                                                    [index]
                                                                    ['name']
                                                                .length >
                                                            20
                                                        ? 16
                                                        : 20,
                                                    color: Colors.amber),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                  child: snapshot
                                                              .data['episodes']
                                                                  [index]
                                                                  ['overview']
                                                              .length ==
                                                          0
                                                      ? Text(
                                                          'No other info :( ')
                                                      : Text(snapshot
                                                              .data['episodes']
                                                          [index]['overview']))
                                            ]),
                                      );
                                    }),
                              )
                            ]);
                })));
  }
}
