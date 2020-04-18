import 'package:flutter/material.dart';
import 'package:flick/extra/iterablezip.dart';
import 'package:flick/pages/detailed_tv.dart';
import 'package:shimmer/shimmer.dart';


class TvCard extends StatelessWidget {
  TvCard({    
    @required this.listitem,
    @required this.movieid,
    @required this.initialString,
    @optionalTypeArgs this.responsecode
    });

  final List<String> listitem;
  final List<int> movieid;
  final String initialString;
  final int responsecode;

  @override
  Widget build(BuildContext context) {
    return  Container(
                height: 250,
                padding: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
                margin: EdgeInsets.only(top: 0),
                child: Column(
                  children:<Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('$initialString', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                        FlatButton(onPressed: (){}, child: Text('See more', style: TextStyle(color: Colors.white),),)
                    ]
                    ),
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
                                  children:                                   
                                   IterableZip([listitem, movieid]).map((f){
                                     String poster = f[0];
                                     int moviesid = f[1];
                                    return Container(
                                      child:                                                                             
                                       Row(                  
                                        children: <Widget>
                                        [
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(context, new MaterialPageRoute(
                                              builder: (context) =>
                                                TvDetail(movieId: moviesid),
                                                )
                                              );
                                            },
                                            child: ClipRRect(                                     
                                            child: Image.network('https://image.tmdb.org/t/p/w200/$poster',
                                            width: 145,
                                            height: 150,                                          
                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList()                                                                                                                                                                                                    
                                ),
                            ],
                        ),
                      ),
                    ),
                  ]
                  ),
                decoration: BoxDecoration(            
                  color: Colors.black
                )
              );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(                             
            child: Container(
            width: 110,
            height: 150,
            child: Shimmer(                                                                                                                                   
              child: ClipRect(
              child: Container(
              width: 110,
              height: 150,
              color: Colors.white.withOpacity(0.3),                                         
            ),
              ), gradient: LinearGradient(colors: [Colors.white, Colors.white10])
            ),
            color: Colors.white.withOpacity(0.2),                                    
            ),
            );
  }
}

