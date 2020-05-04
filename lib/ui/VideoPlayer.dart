import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyVideoPlayer extends StatefulWidget {
  MyVideoPlayer({this.id, this.movieortv});
  final int id;
  final String movieortv;

  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  Stream getVideo() async* {
    String key = 'a71008231061acb3b96b658e8afb1ca3';
    String videoid = widget.id.toString();
    String type = widget.movieortv;
    Response response = await get(
        'https://api.themoviedb.org/3/$type/$videoid/videos?api_key=$key&language=en-US');
    yield jsonDecode(response.body);
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getVideo().asBroadcastStream(),
      builder: (context, snapshot) {
        return snapshot.hasData == false
            ? Center(child: Text('LOADING...'))
            : Container(
                height: snapshot.data['results'].length == 0 ? 150 : 250,
                child: snapshot.data['results'].length == 0
                    ? Center(
                        child: Column(
                        children: <Widget>[
                          Icon(Icons.videocam_off, size: 90),
                          SizedBox(height: 30),
                          Text('No Video to show :( '),
                        ],
                      ))
                    : Container(
                        height: 250,
                        child:
                            // Here goes listview
                            ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data['results'].length,
                                itemBuilder: (_, i) {
                                  return YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId:
                                          snapshot.data['results'].length == 0
                                              ? ''
                                              : snapshot.data['results'][i]
                                                  ['key'],
                                      flags: YoutubePlayerFlags(
                                        forceHideAnnotation: false,
                                        disableDragSeek: true,
                                        autoPlay: false,
                                      ),
                                    ),
                                    showVideoProgressIndicator: true,
                                  );
                                }),
                      ));
      },
    );
  }
}
