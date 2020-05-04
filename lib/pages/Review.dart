import 'dart:convert';

import 'package:Flick/models/MovieDetail.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Reviews extends StatefulWidget {
  Reviews({this.movieId, this.movieortv});
  final int movieId;
  final String movieortv;
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<ReviewList> data;
  int length = 0;
  void getReview() async {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    String movieortv = widget.movieortv;
    Response response = await get(
        'https://api.themoviedb.org/3/$movieortv/${widget.movieId}/reviews?api_key=$key&language=en-US&page=1');
    MovieReviews instance = MovieReviews.fromJson(jsonDecode(response.body));
    setState(() {
      data = instance.reviewList;
      length = instance.results.length;
    });
  }

  @override
  void initState() {
    getReview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandChild(
        child: Container(
      height: 500,
      child: length == 0
          ? Text('No Reviews yet.. :(')
          : ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('@ ' + data[index].author,
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Text(
                            data[index].content,
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(height: 30),
                      Divider(color: Colors.white, thickness: 1),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              }),
    ));
  }
}