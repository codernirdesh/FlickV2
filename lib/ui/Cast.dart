import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class CastNdCrew extends StatefulWidget {
  const CastNdCrew({
    Key key,
    this.id,
    this.movieortv,
  }) : super(key: key);

  final int id;
  final dynamic movieortv;

  @override
  _CastNdCrewState createState() => _CastNdCrewState();
}

class _CastNdCrewState extends State<CastNdCrew> {
  int pageno = 2;
  Stream getItem(pageno) async* {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    int movieid = widget.id;
    dynamic movieortv = widget.movieortv;
    Response response = await get(
        'https://api.themoviedb.org/3/$movieortv/$movieid/credits?api_key=$key');
    yield jsonDecode(response.body);
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
                                  padding: const EdgeInsets.only(top: 160),
                                  child: SpinKitDualRing(color: Colors.grey),
                                ))
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.58,
                                  child: snapshot.data['cast'].length == 0
                                      ? Center(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 80),
                                              Icon(
                                                  Icons
                                                      .sentiment_very_dissatisfied,
                                                  size: 90),
                                              SizedBox(height: 20),
                                              Text(
                                                  'Shoot...! Nothing found :('),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              snapshot.data['cast'].length,
                                          itemBuilder: (context, index) {
                                            String img = snapshot.data['cast']
                                                [index]['profile_path'];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    img == null
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
                                                                'https://image.tmdb.org/t/p/w200$img',
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
                                                    SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        SizedBox(height: 32),
                                                        Text(
                                                            snapshot
                                                                        .data[
                                                                    'cast'][
                                                                index]['name'],
                                                            style: snapshot
                                                                        .data[
                                                                            'cast']
                                                                            [
                                                                            index]
                                                                            [
                                                                            'name']
                                                                        .length >
                                                                    11
                                                                ? TextStyle(
                                                                    color: Colors
                                                                        .amber,
                                                                    fontSize:
                                                                        16)
                                                                : TextStyle(
                                                                    color: Colors
                                                                        .amber,
                                                                    fontSize:
                                                                        22)),
                                                        SizedBox(height: 5),
                                                        Text(
                                                            snapshot
                                                                .data['cast']
                                                                    [index][
                                                                    'character']
                                                                .toString(),
                                                            style: snapshot
                                                                        .data[
                                                                            'cast']
                                                                            [
                                                                            index]
                                                                            [
                                                                            'character']
                                                                        .toString()
                                                                        .length >
                                                                    11
                                                                ? TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                        SizedBox(height: 5),
                                                        snapshot.data['cast']
                                                                        [index][
                                                                    'gender'] ==
                                                                2
                                                            ? Text('Male',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ))
                                                            : Text('Female',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                        SizedBox(height: 5),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30),
                                              ],
                                            );
                                          }),
                                );
                        })
                  ]),
            ))));
  }
}
