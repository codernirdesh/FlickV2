import 'package:flutter/material.dart';
import 'package:flick/pages/detailed_movie.dart';
import 'package:flick/pages/detailed_tv.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flick/ui/successAlert.dart';
import 'package:flick/extra/iterablezip.dart';


class WatchList extends StatefulWidget {
  
  @override
  _WatchListState createState() => _WatchListState();
  
}

List<String> _list, _img = [];
List <String> title = [];
List<String> moviescover, moviesid = [];


class _WatchListState extends State<WatchList> {


  Future<void> getList() async{

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List <String> list = prefs.getStringList('seriesid');
  List<String > img = prefs.getStringList('seriescoverimg');
  List<String> movieid = prefs.getStringList('moviesId');
  List<String> moviecover = prefs.getStringList('moviecover');
  

  // For movies
  if(movieid == null && moviecover == null){
      setState(() {
        moviescover = [];
        moviesid = [];
      });
  }
  else{
    setState(() {
      moviescover = moviecover;
      moviesid = movieid;
    });
  }

  // For series
  if(list == null && img == null)
    {
      setState(() {
      _list = [];
      _img = [];
      });      
    }
    else{
      setState(() {
      _list = list;
      _img = img;
      });      
    }
    print(moviesid);
    print(moviescover);
    print(_list);
    print(_img);
  }
Future<void> cleanMovieList() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    // List <String> list = preferences.getStringList('moviesId');
    WarningBgAlertBox(
      context: context,
      buttonText: 'CLOSE',      
      messageTextColor: Colors.white,
      ontap: (){
        setState(() {
        List<String> empty = [];        
        preferences.setStringList('moviesId', empty);
        preferences.setStringList('moviecover', empty);
        _onRefresh();
      });
      },
      title: 'DELETE WATCHLIST?',
      titleTextColor: Colors.red,
      infoMessage: 'Click ok to confirm',      
      buttonTextColor: Colors.black,            
      buttonColor: Colors.blue                          
      ); 
  }



  Future<void> cleanList() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    List <String> list = preferences.getStringList('seriesid');
    WarningBgAlertBox(
      context: context,
      buttonText: 'CLOSE',      
      messageTextColor: Colors.white,
      ontap: (){
        setState(() {      
        List<String> empty = [];        
        preferences.setStringList('seriesid', empty);
        preferences.setStringList('seriescoverimg', empty);
        print('$list');
        print('done');       
        _onRefresh();       
      });
      },
      title: 'DELETE WATCHLIST?',
      titleTextColor: Colors.red,      
      infoMessage: 'Click ok to confirm',      
      buttonTextColor: Colors.black,            
      buttonColor: Colors.blue                          
      ); 
  }
  
  RefreshController _refreshController = RefreshController(initialRefresh: true);


  void _onRefresh() {        
    
    setState(() {
    getList();
    _refreshController.refreshCompleted();      

    });    
  }

  @override
  void initState() {

    _onRefresh();
    getList();
    super.initState();

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       backgroundColor: Colors.black,    
      body: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
              child: PageView(            
                    children: 
                    <Widget>[
                       ListView(
                  physics: BouncingScrollPhysics(),
                children: <Widget>[
             Stack(
                   children: <Widget>
                   [

                   Container(
                     margin: EdgeInsets.only(bottom: 20),
                     padding: EdgeInsets.only(bottom: 15, left: 0, top: 20),
                   height: MediaQuery.of(context).size.height / 3.1,
                   width: MediaQuery.of(context).size.width / 1,
                   decoration: BoxDecoration(
                     image: DecorationImage(image: AssetImage('assets/serieswatchlist.jpeg'),
                     fit: BoxFit.fitWidth,                      
                          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                     ),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                   ),
                   ),
                   Container(
                     margin: EdgeInsets.only(bottom: 20),
                     padding: EdgeInsets.only(bottom: 15, top: 20),
                    height: MediaQuery.of(context).size.height / 3.1,
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [Colors.black, Colors.black26]
                              ),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                   ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6, left: 20),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         Text('SERIES WATCHLIST', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                        //  Text(' Swipe LEFT to see Movies Watch List >')
                       ],
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/7, left: 20),
                     child: Text('Swipe LEFT for more >', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/15, left: MediaQuery.of(context).size.width/1.5),
                     child: Column(
                       children: <Widget>[
                         FlatButton.icon(onPressed: (){
                            _onRefresh();                      
                          }, icon: Icon(Icons.replay), label: Text('Update List')),
                         FlatButton.icon(onPressed: (){
                            cleanList();                        
                          }, icon: Icon(Icons.close), label: Text('Clear List')),
                          
                       ],
                     ),
                   )
                 ]
             ),
            
             Container(
                 child: Column(
                   children: IterableZip([_list, _img]).map((f){
                     var list = f[0];
                     var img = f[1];
                     return Stack(
                        children:<Widget>[ 
                          Container(
                         width: MediaQuery.of(context).size.width / 1,
                         height: MediaQuery.of(context).size.height / 3,
                         decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://image.tmdb.org/t/p/w500$img'),
                            fit: BoxFit.fitWidth
                            )
                         ),
                       ),
                       Container(
                         width: MediaQuery.of(context).size.width / 1,
                         height: MediaQuery.of(context).size.height / 3,
                         decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [Colors.black, Colors.black26]
                            ),
                         ),
                       ),
                       InkWell(
                         onTap: (){
                           int x = int.parse(list);
                           Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) =>
                                            TvDetail(movieId: x),
                                )
                            );
                         },
                          child: Container(
                           width: MediaQuery.of(context).size.width / 1,
                           height: MediaQuery.of(context).size.height / 3,
                           decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              colors: [Colors.black, Colors.black12]
                              ),
                           ),
                         ),
                       ),
                       InkWell(
                         onTap: (){
                           int x = int.parse(list);
                           Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) =>
                                            TvDetail(movieId: x),
                                )
                            );
                         },
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.5),
                           child: Column(                           
                             children: <Widget>[                             
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end, 
                                 crossAxisAlignment: CrossAxisAlignment.end,                              
                                 children: <Widget>[                                 
                                   IconButton(icon: Icon(Icons.delete, color: Colors.white, size: 50,),
                                   onPressed: (){
                                     remove(list,  img);                                  
                                   }),
                                 ],
                               ),
                               SizedBox(height: 10),
                               Row(
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: <Widget>[
                                  //  Text('Remove', style: TextStyle(color: Colors.red),),
                                 ],
                               ),
                           ],
                           )
                         ),
                       )
                      ]
                     );
                   }
                   ).toList()
                 )
             )
            ]
          ),





          // Movies WATCHLIST

          Scaffold(
            body: ListView(
                  physics: BouncingScrollPhysics(),
                children: <Widget>[
             Stack(
                   children: <Widget>
                   [

                   Container(
                     margin: EdgeInsets.only(bottom: 20),
                     padding: EdgeInsets.only(bottom: 15, left: 0, top: 20),
                   height: MediaQuery.of(context).size.height / 3.1,
                   width: MediaQuery.of(context).size.width / 1,
                   decoration: BoxDecoration(
                     image: DecorationImage(image: AssetImage('assets/watchlater.jpg'),
                     fit: BoxFit.fitHeight,                      
                          
                     ),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                   ),
                   ),
                   Container(
                     margin: EdgeInsets.only(bottom: 20),
                     padding: EdgeInsets.only(bottom: 15, top: 20),
                    height: MediaQuery.of(context).size.height / 3.1,
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [Colors.black, Colors.black26]
                              ),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                   ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6, left: 20),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         Text('MOVIES WATCHLIST', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                        //  Text('< Swipe RIGHT to see Series Watch List', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),)
                       ],
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/7, left: 20),
                     child: Text('< Swipe RIGHT for more', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/15, left: MediaQuery.of(context).size.width/1.5),
                     child: Column(
                       children: <Widget>[
                         FlatButton.icon(onPressed: (){
                            _onRefresh();            
                          }, icon: Icon(Icons.replay), label: Text('Update List')),
                         FlatButton.icon(onPressed: (){
                            cleanMovieList();                        
                          }, icon: Icon(Icons.close), label: Text('Clear List')),                          
                       ],
                     ),
                   )
                 ]
             ),
             Container(
                 child: Column(
                   children: IterableZip([moviesid, moviescover]).map((f){
                     var list = f[0];
                     var img = f[1];
                     return Stack(
                        children:<Widget>[ 
                          Container(
                         width: MediaQuery.of(context).size.width / 1,
                         height: MediaQuery.of(context).size.height / 3,
                         decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://image.tmdb.org/t/p/w500$img'),
                            fit: BoxFit.fitWidth
                            )
                         ),
                       ),
                       Container(
                         width: MediaQuery.of(context).size.width / 1,
                         height: MediaQuery.of(context).size.height / 3,
                         decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [Colors.black, Colors.black12]
                            ),
                         ),
                       ),
                       InkWell(
                         onTap: (){
                           int x = int.parse(list);
                           Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) =>
                                            MovieDetail(movieId: x),
                                )
                            );
                         },
                          child: Container(
                           width: MediaQuery.of(context).size.width / 1,
                           height: MediaQuery.of(context).size.height / 3,
                           decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              colors: [Colors.black, Colors.black12]
                              ),
                           ),
                         ),
                       ),
                       InkWell(
                         onTap: (){
                           int x = int.parse(list);
                           Navigator.push(context, new MaterialPageRoute(
                                          builder: (context) =>
                                            MovieDetail(movieId: x),
                                )
                            );
                         },
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5.5),
                           child: Column(                           
                             children: <Widget>[                             
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.end, 
                                 crossAxisAlignment: CrossAxisAlignment.end,                              
                                 children: <Widget>[                                 
                                   IconButton(icon: Icon(Icons.delete, color: Colors.white, size: 50,),
                                   onPressed: (){
                                     removemovie(list,  img);                               
                                   }),
                                 ],
                               ),
                               SizedBox(height: 10),
                               Row(
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: <Widget>[
                                  //  Text('Remove', style: TextStyle(color: Colors.red),),
                                 ],
                               ),
                           ],
                           )
                         ),
                       )
                      ]
                     );
                   }
                   ).toList()
                 )
             )
            ]
          ),
          backgroundColor: Colors.black,
          )
          ]
        ),
      )
      );
  }  
  void remove(item, imag) async{
       SharedPreferences preferences = await SharedPreferences.getInstance();
       List <String> list = preferences.getStringList('seriesid');
       List <String> imgm = preferences.getStringList('seriescoverimg');
       list.remove(item);
       imgm.remove(imag);
       preferences.setStringList('seriesid', list);
       preferences.setStringList('seriescoverimg', imgm);
       _onRefresh();
  }

  void removemovie(item, imag) async{
       SharedPreferences preferences = await SharedPreferences.getInstance();
       List <String> list = preferences.getStringList('moviesId');
       List <String> imgm = preferences.getStringList('moviecover');
       list.remove(item);
       imgm.remove(imag);
       preferences.setStringList('moviesId', list);
       preferences.setStringList('moviecover', imgm);
       _onRefresh();
  }
}

