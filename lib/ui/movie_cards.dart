import 'dart:ui';
import 'package:flick/pages/see_more.dart';
import 'package:flick/ui/shimmerCards.dart';
import 'package:flutter/material.dart';
import 'package:flick/pages/detailed_movie.dart';
import 'package:flick/extra/iterablezip.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MovieCard extends StatelessWidget {
  MovieCard(
      {@required this.listitem,
      @required this.movieid,
      @required this.initialString,
      @optionalTypeArgs this.responsecode,
      @required this.seewhat,
      @required this.type,
      });

  final List<String> listitem;
  final List<int> movieid;
  final String initialString;
  final int responsecode;
  final String seewhat;
  final String type;

  @override
  Widget build(BuildContext context) {    
    return Container(
        height: 250,
        padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
        margin: EdgeInsets.only(top: 0),
        child: Column(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$initialString',
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                      elevation: 0,                      
                      backgroundColor: Colors.transparent,                      
                      context: context,
                      builder: (BuildContext context) => BottomSheet(
                          builder: (BuildContext context) {
                            return BottomSheetx(                              
                              seewhat: seewhat,
                              type: type,
                            );
                          },
                          onClosing: () {}),
                    );
                  },
                  child: Text(
                    'See more',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ]),
          Container(
            child: Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  responsecode == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ShimmerCard(),
                            SizedBox(width: 40),
                            ShimmerCard(),
                            SizedBox(width: 40),
                            ShimmerCard(),
                            SizedBox(width: 40),
                            ShimmerCard(),
                            SizedBox(width: 40),
                            ShimmerCard(),
                            SizedBox(width: 40),
                            ShimmerCard(),
                            SizedBox(width: 40),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: IterableZip([listitem, movieid]).map((f) {
                            String poster = f[0];
                            int moviesid = f[1];

                            return Container(
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      pushNewScreen(
                                        context,
                                        screen: MovieDetail(movieId: moviesid),
                                        withNavBar: false,
                                      );
                                    },
                                    child: ClipRRect(
                                      child: CachedNetworkImage(
                                          width: 145,
                                          height: 150,
                                          imageUrl: poster == null
                                              ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                              : 'https://image.tmdb.org/t/p/w200/$poster'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()),
                ],
              ),
            ),
          ),
        ]),
        decoration: BoxDecoration(color: Colors.black));
  }
}
