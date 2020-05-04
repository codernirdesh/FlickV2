import 'dart:convert';
import 'package:Flick/pages/MovieDetail.dart';
import 'package:Flick/pages/TvDetail.dart';
import 'package:Flick/ui/ModalWithBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RoundCard extends StatelessWidget {
  RoundCard({this.type, this.prefixText, this.movieOrTv});
  final String type;
  final String prefixText;
  final String movieOrTv;

  Stream getItem() async* {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    Response response = await get(
        'https://api.themoviedb.org/3/$movieOrTv/$type?api_key=$key&language=en-US&page=1');
    yield jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getItem(),
        builder: (ctxt, snapshot) {
          return snapshot.data == null
              ? Center(child: Container())
              : Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('$prefixText'),
                            GestureDetector(
                              onTap: () {
                                showBarModalBottomSheet(
                                  barrierColor: Colors.black38,
                                  useRootNavigator: true,
                                  context: context,
                                  builder: (context, scrollController) =>
                                      ModalwithBar(
                                          type: type, movieOrTv: movieOrTv),
                                );
                              },
                              child: Container(
                                height: 30,
                                child: Text(
                                  'See More',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      height: 180,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data['results'].length,
                          itemBuilder: (ctx, index) {
                            String img =
                                snapshot.data['results'][index]['poster_path'];
                            return Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      screen: movieOrTv == 'tv'
                                          ? TvDetail(
                                              movieId: snapshot.data['results']
                                                  [index]['id'])
                                          : MovieDetail(
                                              movieId: snapshot.data['results']
                                                  [index]['id']),
                                      withNavBar: false,
                                    );
                                  },
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          "http://image.tmdb.org/t/p/w200$img",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            width: 130,
                                            height: 130,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) => Text(''),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons
                                              .sentiment_very_dissatisfied)),
                                ),
                                SizedBox(width: 20)
                              ],
                            );
                          }),
                    ),
                    SizedBox(height: 20)
                  ],
                );
        });
  }
}
