import 'package:flick/ui/successAlert.dart';
import 'package:flick/services/APItv_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class TvDetail extends StatefulWidget {

  final int movieId;
  TvDetail({@optionalTypeArgs this.movieId});
  @override
  _TvDetailState createState() => _TvDetailState();  

}

class _TvDetailState extends State<TvDetail> {

  YoutubePlayerController _controller;

  String title = '';
  String year = '';
  String img, language, status, origincountry, lastEpisode = '';
  int code;
  String rating = '';
  String plot = '';
  double votes = 0;
  int voteCount = 0;
  String coverimg = '';
  int runtime = 0;
  String tagline = '';  
  String website = 'N/A';
  int budget = 0;
  int revenue = 0;
  String movieid, createdby, genre = '';
  double popularity = 0.0;
  int seasons, episodes = 0;
  List <String> watchlist = [];
  List<String> bg = [];
  String videourl = 'g8K21P8CoeI';


    void setWatchListData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('seriesid', watchlist);    
    prefs.setStringList('seriescoverimg', bg);
  }

    void getWatchListData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> name = prefs.getStringList('seriesid');
    List<String> background = prefs.getStringList('seriescoverimg');
    if(name == null || background == null)
    {
      watchlist = [];
      bg = [];
    }
    else{
      watchlist = name;
      bg = background;
    }    
  }  
  


  void dataFetch (movieId) async{
    TvApiFetch instance = TvApiFetch(url: 'https://api.themoviedb.org/3/tv/$movieId?api_key=a71008231061acb3b96b658e8afb1ca3&language=en-US');
    await instance.getData();
    setState(() {
      title = instance.title;
      year = instance.year;
      img = instance.img;
      code = instance.responsecode;
      coverimg = instance.coverimg;
      plot = instance.plot;
      runtime = instance.runtime;
      videourl = instance.videourl;
      
      votes = instance.voteAverage;
      if(votes == null)
      {
        votes = 0;
      }
      tagline = instance.tagline;
      voteCount = instance.voteCount;
      website = instance.homepage;
      budget = instance.budget;
      revenue = instance.revenue;
      popularity = instance.popularity;
      movieid = instance.movieid;
      language = instance.language;
      status = instance.status;
      origincountry = instance.origincountry;
      lastEpisode = instance.lastEpisode;
      episodes = instance.episodes;
      seasons = instance.seasons;
      createdby = instance.createdby;
      genre = instance.genre;
      
      
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
      : 
      
      Stack(
            children:
            <Widget>[                      
            Container(
          padding: EdgeInsets.only(top: 100, left: 20),
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
                  backgroundColor: Colors.transparent               
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
                  SizedBox(height: 8),
                  Row(
                    children:<Widget>[
                      Icon(Icons.gavel, size: 20, color: Colors.white,),
                      SizedBox(width: 8),
                      Text('$genre', style: TextStyle(fontSize: 15)),                          
                  ]
                  ),
                  SizedBox(height: 8),
                  Row(
                    children:<Widget>[
                      Container(
                        width: 25,
                        height: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage('https://www.countryflags.io/$origincountry/flat/64.png'))
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('$language'.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),                          
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
          padding: const EdgeInsets.only(left: 0, top: 25),
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
          if(watchlist == null || !watchlist.contains(movieid) || !bg.contains(img)){               
          watchlist.add(movieid);
          bg.add(img);
          setWatchListData();
          getWatchListData();              
          print('$watchlist');
          print('$bg');          
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
          bg.remove(img);
          setWatchListData();
          getWatchListData();
          print('$watchlist');
          print(bg);
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
          Row(                    
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color:
                status == 'Returning Series'
                ? Colors.green
                : Colors.red,
                borderRadius: BorderRadius.circular(90)
                )
              ),
              Text('   $status'.toUpperCase(), style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
                                    
            ],
          ),
          
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
                  votes > 7
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
              videourl == 'null'
              ? Text('No videos found :(')
            : YoutubePlayer( 
                aspectRatio: 16/9,              
                controller: _controller,
                // thumbnailUrl: 'https://img.youtube.com/vi/$videourl/1.jpg',
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(playedColor: Colors.red, bufferedColor: Colors.grey)
              ),                                 
              SizedBox(height: 30),
              Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Popularity'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('SERIES PLOT', style: TextStyle(fontSize: 25, color: Colors.amber, fontWeight: FontWeight.bold)),                      
              Text('$popularity', style: TextStyle(fontSize: 25)),                      
            ],
          ),                  
          
          SizedBox(height: 30),
          Text('$plot', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 20),
              Text('Official Website', style: TextStyle(fontSize: 19),),
              SizedBox(height: 10),
              GestureDetector(child: Text('$website', style: TextStyle(fontSize: 17 ,color: Colors.blue),), onTap: () => launch('$website'),),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('LAST EPISODE AIR DATE ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  Text('NEXT EP. ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('$lastEpisode'),                                                                   
                  Text('nextep', style: TextStyle(color: Colors.white, fontSize: 16)),
                             
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('SEASONS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
                  Text('EPISODES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(                        
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('$seasons', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('$episodes', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Divider(
          //   color: Colors.white,
          // ),
          SizedBox(height: 20),          
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              Text('CREATED BY', style: TextStyle(fontSize: 20, color: Colors.amber, fontWeight: FontWeight.bold)),                      
              Text('$createdby'.toUpperCase(), style: TextStyle(fontSize: 18)),
          ]
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[              
              Icon(Icons.info, size: 30),
              SizedBox(width: 20),
              Text('SEASONS INFO', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold)),                                    
              
          ]
          ),
          SizedBox(height: 20),          
          Center(child: Text('Feature will be added soon...'))
        ],
      )
            )
          ],
        ),
    );
  }
}