import 'dart:convert';
import 'package:Flick/pages/MovieDetail.dart';
import 'package:Flick/pages/TvDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SimilarTvShows extends StatelessWidget {
  const SimilarTvShows({
    Key key,
    this.id,
    this.movieortv,
  }) : super(key: key);

  final int id;
  final String movieortv;

  Stream similarShowStream() async* {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    // int id = widget.id;
    // String movieortv = widget.movieortv;
    Response response = await get(
        'https://api.themoviedb.org/3/$movieortv/$id/similar?api_key=$key&language=en-US&page=1');
    Map data = jsonDecode(response.body);
    yield data;
  }

  @override
  Widget build(BuildContext context) {
    int itemcount = 0;
    return StreamBuilder(
        stream: similarShowStream().asBroadcastStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            itemcount = snapshot.data['results'].length;
          }
          return itemcount == 0
              ? Container(
                padding: EdgeInsets.all(20),
                child: Center(child: Text('SHOOT! NOTHING FOUND :(')))
              : Container(
                  height: 130,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: itemcount,
                      itemBuilder: (context, index) {
                        String img =
                            snapshot.data['results'][index]['poster_path'];
                        return Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                pushNewScreen(
                                  context,
                                  screen: 
                                  movieortv == 'tv'
                                  ? TvDetail(
                                    movieId: snapshot.data['results'][index]
                                        ['id']
                                  )
                                  : MovieDetail(
                                    movieId: snapshot.data['results'][index]
                                        ['id']
                                  ),
                                  withNavBar: false,
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: "http://image.tmdb.org/t/p/w200$img",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        );
                      }),
                );
        });
  }
}
