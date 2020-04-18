import 'package:flick/pages/detailed_movie.dart';
import 'package:flutter/material.dart';
import 'package:flick/pages/detailed_tv.dart';
import 'package:flick/services/search_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flick/extra/iterablezip.dart';



class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
          
    int searchField = 0;
    double mtop = 60;
    String searched;
    List<String> title, movietitle, votes, votesCount = [];
    List<int> id, movieid = [];
    List<String> backimg = [];
    String typex = 'movie';

    

    void search(String item) async{
    SearchQuery instance = SearchQuery(query: item, type: typex);
    await instance.searchedItems();
    title = instance.titles;
    backimg = instance.backgroundimg;
    votes = instance.votes;
    votesCount = instance.voteCount;
    id = instance.id;
    movieid = instance.movieid;
    movietitle = instance.movietitle;

  }
    RefreshController _refreshController = RefreshController(initialRefresh: false);

    void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
     setState(() {
       Search();
     });
        
    _refreshController.refreshCompleted();    
    
    }

  @override
  void initState() {
    super.initState();
    _onRefresh();
    searched = '->90439043093209';
    search(searched);
  }

  @override
  Widget build(BuildContext context) {  

    return Scaffold(      
      backgroundColor: Colors.black,
      body: SmartRefresher(
        controller: _refreshController,
            onRefresh: _onRefresh,
              child: ListView(
          physics: BouncingScrollPhysics(),
              children: <Widget>[
                Stack(                
                    children: <Widget>
                    [                     
                      Align(
                        alignment: Alignment.center,
                        child: Container(                      
                    padding: EdgeInsets.only(left: 40),                  
                    height: 180,
                    width: 1500,                
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,                      
                            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                            image: AssetImage('assets/search.jpg'),
                        ),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                    ),
                  ),
                      ),
                      Container(
                        width: 10000,
                        height: 180,
                        decoration: BoxDecoration(                      
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [Colors.black, Colors.black26]
                            ),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                    ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 140, left: 0, right: 0),
                      child: TextFormField(     
                          
                    maxLines: 1,         
                    onTap: (){
                      // setState(() {
                      //   _onRefresh();
                      // });
                    },

                    onChanged: (m){
                      setState(() {
                      searched = m;                                         
                      _onRefresh();
                      search(m);
                    });                                                          

                    },
                  onFieldSubmitted: (m){                    
                      setState(() {
                      searched = m;                                         
                      _onRefresh();
                      search(m);
                    });                                                          
                    },
                 decoration: InputDecoration(                                    
                  border: InputBorder.none,                      
                  filled: true,            
                  fillColor: Colors.black.withOpacity(0.1),
                  alignLabelWithHint: false,                
                  labelText: 'Search Movies & Series',                
                  prefixIcon: Icon(Icons.search)
                ),
                ),
                      ),
                  ]
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 25),
                  child: DropdownButton<String>(
                              hint: Text(typex.toUpperCase()),                        
                              items: <String>['movie', 'tv'].map((String value) {
                            return DropdownMenuItem<String>(                          
                              value: value,
                              child: Text(value.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (_) {
                            
                            setState(() {
                              typex = _;
                              print(typex);                              
                            });
                          },
                        ),
                ),
              ],
            ),  
            title == null
            ? Suggestion()                                             
              
            : Search(title: title, backimg: backimg, votes: votes, id: id, type: typex, movieid: movieid, movietitle: movietitle,),

        ]
        ),
      ),
    );
  }
  
}

class Search extends StatelessWidget {
  const Search({
    Key key,
    @optionalTypeArgs this.title,
    @optionalTypeArgs this.backimg,
    @optionalTypeArgs this.votes,
    @optionalTypeArgs this.votesCount,
    @optionalTypeArgs this.id,
    @optionalTypeArgs this.type,
    @optionalTypeArgs this.movietitle,
    @optionalTypeArgs this.movieid,

  }) : super(key: key);
  final List<String> title;
  final List<String> movietitle;
  final List<String> backimg;
  final List<String> votes;
  final List<String> votesCount;
  final List<int> id;
  final List<int> movieid;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 2, right: 2, bottom: 50),
      child: Column(
        children: IterableZip([title, backimg, votes, id, movieid, movietitle]).map((x){
          String title = x[0];
          String img = x[1];
          String votes = x[2];
          int id = x[3];
          int movieidx = x[4];
          String movietitlex = x[5];
          
          

          if(img == 'null'){
            img = 'https://images.wallpaperscraft.com/image/popcorn_dish_corn_111130_1280x720.jpg';
          }
          else{
            img = 'https://image.tmdb.org/t/p/w200/$img';
          }

          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  InkWell(
                    
                        onTap: (){
                          
                          Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) =>
                                          type == 'movie'
                                          ? MovieDetail(movieId: movieidx)
                                          : TvDetail(movieId: id),
                                          )
                                        );
                        },
                        child: Container(             
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 1,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            repeat: ImageRepeat.repeat,                              
                            image: NetworkImage('$img')
                            )
                        ),
                        ),
                  ),
                    
                    InkWell(
                      
                        onTap: (){
                          
                          Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) =>
                                          type == 'movie'
                                          ? MovieDetail(movieId: movieidx)
                                          : TvDetail(movieId: id),
                                          )
                                        );
                        },
                      child: Container(             
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.black, Colors.black26]),
                        borderRadius: BorderRadius.circular(20),                            
                      ),
                      ),
                    ),
                    InkWell(
                      
                        onTap: (){
                          
                          Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) =>
                                        type == 'movie'
                                        ? MovieDetail(movieId: movieidx)
                                        :  TvDetail(movieId: id),
                                          )
                                        );
                        },
                      child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          colors: [Colors.black, Colors.black26]),
                        borderRadius: BorderRadius.circular(20),                            
                      ),
                      ),
                    ),
                    
                       InkWell(
                         
                        onTap: (){
                          
                          Navigator.push(context, new MaterialPageRoute(
                                        builder: (context) =>
                                        type == 'movie'
                                        ? MovieDetail(movieId: movieidx)
                                        : TvDetail(movieId: id),
                                          )
                                        );
                        },
                            child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              type == 'movie'
                                        
                              ? Text('$movietitlex'.toUpperCase(), style: TextStyle(
                                      color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)
                                  )
                              : Text('$title'.toUpperCase(), style: TextStyle(
                                      color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)
                                  ),
                                  SizedBox(height: 0),
                                  Text('Rating  $votes', style: TextStyle(
                                  color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text('Tap to see detail')                                  
                                  
                            ],
                          ),
                      ),
                       ),
                ],
              ),
                
                
            ],
          );
        }).toList()
        
      ),
    );
  }
}

class Suggestion extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 90),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    MovieDetail(movieId: 278),
                )
            );
            },
                  child: Text(
                   'Shawshank Redemption',
                   style: TextStyle(
                     color: Colors.amber,                            
                   ),
                   ),
          ),
               SizedBox(height: 30),
               InkWell(
                 onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    MovieDetail(movieId: 238),
                )
            );
            },
                    child: Text(
                   'God Father',
                   style: TextStyle(
                     color: Colors.amber,                            
                   ),
                   ),
               ),
                 SizedBox(height: 30),
                 InkWell(
                   onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    MovieDetail(movieId: 497637),
                )
            );
            },
                    child: Text(
                   'Parasite',
                   style: TextStyle(
                     color: Colors.amber,                            
                   ),
                   ),
                 ),
                 SizedBox(height: 30),
                 InkWell(
                   onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    TvDetail(movieId: 1396),
                )
            );
            },
                    child: Text(
                   'Breaking Bad',
                   style: TextStyle(
                     color: Colors.amber,                            
                   ),
                   ),
                 ),
                 SizedBox(height: 30),
                 InkWell(
                   onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    TvDetail(movieId: 1399),
                )
            );
            },
                    child: Text(
                   'Game of Thrones',
                   style: TextStyle(
                     color: Colors.amber,                            
                   ),
                   ),
                 ),
                 SizedBox(height: 30),
                 InkWell(
                   onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                    builder: (context) =>
                    TvDetail(movieId: 60625),
                )
            );
            },
                    child: Text(
                   'Rick and Morty',
                   style: TextStyle(
                     color: Colors.amber,                            
                   ),
                   ),
                 ),
                 SizedBox(height: 30)

        ]
      )
    );
  }
  
}

   