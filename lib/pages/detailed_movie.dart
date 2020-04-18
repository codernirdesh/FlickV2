import 'package:flick/ui/successAlert.dart';
import 'package:flick/services/APImovie_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class MovieDetail extends StatefulWidget {

  final int movieId;
  MovieDetail({@optionalTypeArgs this.movieId});
  @override
  _MovieDetailState createState() => _MovieDetailState();  

}

class _MovieDetailState extends State<MovieDetail> {


  YoutubePlayerController _controller;

  String title = '';
  String year = '';
  String img = '';
  int code;
  String rating = '';
  String plot = '';
  double votes = 0;
  int voteCount = 0;
  String coverimg = '';
  int runtime = 0;
  String tagline = '';
  List <String> watchlist, cover = [];
  String website = 'N/A';
  int budget = 0;
  int revenue = 0;
  String movieid = '';
  double popularity = 0.0;
  String videourl = 'g8K21P8CoeI';

    void setWatchListData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('moviesId', watchlist);
    prefs.setStringList('moviecover', cover);
    
    
  }
  

    void getWatchListData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> name = prefs.getStringList('moviesId');
    List<String> cvr = prefs.getStringList('moviecover');
    if(name == null || cvr == null)
    {
      watchlist = [];
      cover = [];
    }
    else{
      cover = cvr;
      watchlist = name;
    }    
  }  
  




  void dataFetch (movieId) async{
    ApiFetch instance = ApiFetch(url: 'https://api.themoviedb.org/3/movie/$movieId?api_key=a71008231061acb3b96b658e8afb1ca3&language=en-US');
    await instance.getData();
    setState(() {
      title = instance.title;
      year = instance.year;
      img = instance.img;
      code = instance.responsecode;
      coverimg = instance.coverimg;
      plot = instance.plot;
      runtime = instance.runtime;
      votes = instance.voteAverage;
      videourl = instance.videourl;
      if(votes == null)
      {
        votes = 0;
      }
      if(title == null)
      {
        title = 'N/A';
      }
      tagline = instance.tagline;
      voteCount = instance.voteCount;
      website = instance.homepage;
      budget = instance.budget;
      revenue = instance.revenue;
      popularity = instance.popularity;
      movieid = instance.movieid;
      
    });
  }

  
  @override
  void initState() {    
    super.initState();
    getWatchListData();
    dataFetch(widget.movieId);        
    
    
  }

  @override
  Widget build(BuildContext context) {    

    _controller = YoutubePlayerController(
      initialVideoId: videourl,
      flags: YoutubePlayerFlags(
      autoPlay: false,
      loop: false,
    )
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(        
        physics: BouncingScrollPhysics(),
          children: <Widget>[            
            Container(             
      child: code == null 
      ? Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
        child: SpinKitFadingCube(
        color: Colors.orange,
        size: 200,
      ),
        )
      : Stack(
            children:
            <Widget>[                      
            Container(
          padding: EdgeInsets.only(top: 120, left: 20),
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,                      
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
              image: NetworkImage('https://image.tmdb.org/t/p/w300/$img') // Cover img
              ),
            color: Colors.black,                  
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))
          ),
          child: Column(
            children: <Widget>[
              // FlatButton.icon(onPressed: (){}, child: Icon(Icons.arrow_back_ios))
              Row(
                children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w200/$img'),
                  radius: 60,                      
                ),
                SizedBox(width: 15),                        
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.movie, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Column(
                        children: <Widget>[                          
                          title.length > 26 
                          ? Text('$title', style: TextStyle(                            
                            fontSize: 12,
                            color: Colors.white, fontWeight: FontWeight.bold)
                            )

                          : Text('$title', style: TextStyle(                            
                            fontSize: 15,
                            color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Icon(Icons.date_range, size: 20, color: Colors.white,),
                      SizedBox(width: 8),
                      Text('$year', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 9,
                        backgroundImage:NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png'),
                         backgroundColor: Colors.transparent),
                         SizedBox(width: 8),
                         Text('$votes', style: TextStyle(fontSize: 15)),
                         SizedBox(width: 8),
                         Text('|'),
                         SizedBox(width: 8),
                         Text('$voteCount votes'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children:<Widget>[
                      Icon(Icons.timer, size: 20, color: Colors.white,),
                      SizedBox(width: 8),
                      Text('$runtime  min', style: TextStyle(fontSize: 15)),                          
                  ]
                  ),
                ]
                ),
              ],
              ),
            ],
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 45),
          child: FlatButton.icon(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios), label: Text('$title', style: TextStyle(                    
            fontSize: 18
            ),
            )
            ),
        ),
        code == null
            ? Text('')
            : Container(
      margin: EdgeInsets.only(top:206, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[                  
          FlatButton.icon(              
          color: !watchlist.contains(movieid)             
          ? Colors.blue
          : Colors.red,
          textColor: Colors.black,
          onPressed: () {                         
          if(watchlist == null || !watchlist.contains(movieid) || !cover.contains(img)){              
          watchlist.add(movieid);
          cover.add(img);
          setWatchListData();
          getWatchListData();              
          print('$watchlist');
          print('$cover');
          SuccessBgAlertBox(context: context,
          title: '$title added to your watch list',
          titleTextColor: Colors.black,
          infoMessage: '',
          buttonText: 'Ok',  
          buttonTextColor: Colors.black,            
          buttonColor: Colors.white            
          );
          
          
          }
          else{
          watchlist.remove(movieid);
          cover.remove(img);
          setWatchListData();
          getWatchListData();
          print('$watchlist');
          print('$cover');
          DarkBgAlertBox(context: context,
          messageTextColor: Colors.white,
          title: '$title removed from your watch list',
          titleTextColor: Colors.red,
          infoMessage: '',
          buttonText: 'Ok',  
          buttonTextColor: Colors.black,            
          buttonColor: Colors.white                          
          );
          
          
          }            
          },           
          icon: 
           !watchlist.contains(movieid)
           ? Icon(Icons.add)
           : Icon(Icons.remove), 
           label: 
           !watchlist.contains(movieid)
           ? Text('Add')
           : Text('Remove'),           
           )
            ],
          ),
          SizedBox(height:6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[                      
              Text('*Watchlist'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          )
        ],
      ),
      ),
      ]
      )
      ),            
            SizedBox(height: 20),
            code == null
            ? Text('')            
            : Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(left: 22, right: 20, bottom: 40),
      child: Column(                
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Text('# $tagline', style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),                  
          
          SizedBox(height: 20),     
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('$votes', style: TextStyle(fontSize: 55, color: Colors.amber, fontWeight: FontWeight.bold)),
                  votes >= 8
                  ? 
                  Row(
                    children: <Widget>[
                      CircleAvatar(radius: 20, backgroundColor: Colors.black, backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png')),
                      CircleAvatar(radius: 20, backgroundColor: Colors.black, backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png')),
                      CircleAvatar(radius: 20, backgroundColor: Colors.black, backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png'))
                    ],
                  )

                  :
                  Row(
                    children:<Widget>[
                      CircleAvatar(radius: 30, backgroundColor: Colors.black, backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Gold_Star.svg/1200px-Gold_Star.svg.png'))
                    ]
                  )

                ],
              ),
              SizedBox(height: 20),                  
              
              Text('Official Website', style: TextStyle(fontSize: 19),),
              SizedBox(height: 10),
              GestureDetector(child: Text('$website', style: TextStyle(fontSize: 17 ,color: Colors.blue),), onTap: () => launch('$website'),),
              SizedBox(height: 20),
             videourl == 'null'
            ? Text('No Videos found :( ', style: TextStyle(color: Colors.white),)
            : YoutubePlayer(  
                aspectRatio: 16/9,              
                controller: _controller,
                // thumbnailUrl: 'https://img.youtube.com/vi/$videourl/1.jpg',
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(playedColor: Colors.red, bufferedColor: Colors.grey)
              ),               
              
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('REVENUE ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('BUDGET ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('\$ $budget', style: TextStyle(color: Colors.amber, fontSize: 16)),                                                
                  Text('\$ $revenue', style: TextStyle(color: Colors.green, fontSize: 16)),
                             
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Popularity'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('MOVIE PLOT', style: TextStyle(fontSize: 25, color: Colors.amber, fontWeight: FontWeight.bold)),                      
              Text('$popularity', style: TextStyle(fontSize: 25)),                      
            ],
          ),
          SizedBox(height: 20),
          Text('$plot', style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 20),           
             ],
          )
            ),
            
          ],
        ),
    );
  }
}