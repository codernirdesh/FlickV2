import 'package:Flick/pages/MovieDetail.dart';
import 'package:Flick/pages/TvDetail.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Flick/ui/successAlert.dart';
import 'package:Flick/extra/iterablezip.dart';
import 'package:flip_card/flip_card.dart';

class WatchList extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

List<dynamic> _list, _img = [];
List<dynamic> title = [];
List<dynamic> moviescover, moviesid = [];
bool started = false;

class _WatchListState extends State<WatchList> {
  Future<void> getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> list = prefs.getStringList('seriesid');
    List<dynamic> img = prefs.getStringList('seriescoverimg');
    List<dynamic> movieid = prefs.getStringList('moviesId');
    List<dynamic> moviecover = prefs.getStringList('moviecover');

    // For series
    if (list == null && img == null) {
      setState(() {
        _list = [];
        _img = [];
      });
    } else {
      setState(() {
        _list = list;
        _img = img;
      });
    }
// For movies
    if (movieid == null && moviecover == null) {
      setState(() {
        moviescover = [];
        moviesid = [];
      });
    } else {
      setState(() {
        moviescover = moviecover;
        moviesid = movieid;
      });
    }
    setState(() {
      started = true;
    });
  }

  Future<void> cleanList(String idtype, String covertype) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    WarningBgAlertBox(
        context: context,
        buttonText: 'CLOSE',
        messageTextColor: Colors.white,
        ontap: () {
          setState(() {
            List<String> empty = [];
            preferences.setStringList(idtype, empty);
            preferences.setStringList(covertype, empty);
            _onRefresh();
          });
        },
        title: 'DELETE WATCHLIST?',
        titleTextColor: Colors.red,
        infoMessage: 'Click ok to confirm',
        buttonTextColor: Colors.black,
        buttonColor: Colors.blue);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() {
    setState(() {
      getList();
      _refreshController.refreshCompleted();
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: FlipCard(
          onFlip: () {
            _onRefresh();
          },
          flipOnTouch: true,
          direction: FlipDirection.HORIZONTAL,
          front: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child:
                ListView(physics: BouncingScrollPhysics(), children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.only(bottom: 15, left: 0, top: 20),
                  height: MediaQuery.of(context).size.height / 3.1,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/serieswatchlist.jpeg'),
                        fit: BoxFit.fitWidth,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.dstATop),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.only(bottom: 15, top: 20),
                  height: MediaQuery.of(context).size.height / 3.1,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.black, Colors.black26]),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 6, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('TV\nWATCHLIST',
                          style: TextStyle(
                              fontFamily: 'RussoOne',
                              fontSize: 50,
                              fontWeight: FontWeight.bold)),
                      //  Text(' Swipe LEFT to see Movies Watch List >')
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 7, left: 20),
                  child: Text('Tap here to see Movie watchlist',
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {
                                _onRefresh();
                              },
                              icon: Icon(Icons.replay),
                              label: Text('Update List')),
                          FlatButton.icon(
                              onPressed: () {
                                cleanList('seriesid', 'seriescoverimg');
                              },
                              icon: Icon(Icons.close),
                              label: Text('Clear List')),
                        ],
                      ),
                    ],
                  ),
                )
              ]),              
              started == false
                  ? Text('')
                  : Container(
                      child: Column(
                          children: IterableZip([_list, _img]).map((f) {
                      dynamic list = f[0];
                      dynamic img = f[1];
                      return Stack(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(img == null
                                      ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                      : 'https://image.tmdb.org/t/p/w500$img'),
                                  fit: BoxFit.fitWidth)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [Colors.black, Colors.black12]),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            int x = int.parse(list);
                            {
                              pushNewScreen(
                                context,
                                screen: TvDetail(movieId: x),
                                withNavBar: false,
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  colors: [Colors.black, Colors.black12]),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            int x = int.parse(list);
                            {
                              pushNewScreen(
                                context,
                                screen: TvDetail(movieId: x),
                                withNavBar: false,
                              );
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.only(right: 10),
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height / 5.5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                          onPressed: () {
                                            remove(list, img, 'seriesid',
                                                'seriescoverimg');
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
                              )),
                        )
                      ]);
                    }).toList()))
            ]),
          ),
          back: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
            Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(bottom: 15, left: 0, top: 20),
                height: MediaQuery.of(context).size.height / 3.1,
                width: MediaQuery.of(context).size.width / 1,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/watchlater.jpg'),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(bottom: 15, top: 20),
                height: MediaQuery.of(context).size.height / 3.1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [Colors.black, Colors.black26]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 6, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('MOVIE WATCHLIST',
                        style: TextStyle(
                            fontFamily: 'RussoOne',
                            fontSize: 50,
                            fontWeight: FontWeight.bold)),
                    //  Text('< Swipe RIGHT to see Series Watch List', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 7, left: 20),
                child: Text('Tap here to see TV watchlist',
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 15,                    
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton.icon(
                                  onPressed: () {
                                    _onRefresh();
                                  },
                                  icon: Icon(Icons.replay),
                                  label: Text('Update List')),
                        FlatButton.icon(
                            onPressed: () {
                              cleanList('moviesId', 'moviecover');
                            },
                            icon: Icon(Icons.close),
                            label: Text('Clear List')),
                      ],
                    ),
                  ],
                ),
              )
            ]),
            Container(
                child: started == false
                    ? Text(' _')
                    : Column(
                        children: IterableZip([moviesid, moviescover]).map((f) {
                        dynamic list = f[0];
                        dynamic img = f[1];
                        return Stack(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(img == null
                                        ? 'https://i.ibb.co/CvCHJ7N/error.png'
                                        : 'https://image.tmdb.org/t/p/w500$img'),
                                    fit: BoxFit.fitWidth)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [Colors.black, Colors.black12]),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              int x = int.parse(list);
                              {
                                pushNewScreen(
                                  context,
                                  screen: MovieDetail(movieId: x),
                                  withNavBar: false,
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1,
                              height: MediaQuery.of(context).size.height / 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    colors: [Colors.black, Colors.black12]),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              int x = int.parse(list);
                              {
                                pushNewScreen(
                                  context,
                                  screen: MovieDetail(movieId: x),
                                  withNavBar: false,
                                );
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.only(right: 10),
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        5.5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 50,
                                            ),
                                            onPressed: () {
                                              remove(list, img, 'moviesId',
                                                  'moviecover');
                                            }),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        //  Text('Remove', style: TextStyle(color: Colors.red),),
                                      ],
                                    ),
                                  ],
                                )),
                          )
                        ]);
                      }).toList()))
          ]),
        ));
  }

  void remove(item, imag, String typeid, String typecover) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> list = preferences.getStringList(typeid);
    List<String> imgm = preferences.getStringList(typecover);
    list.remove(item);
    imgm.remove(imag);
    preferences.setStringList(typeid, list);
    preferences.setStringList(typecover, imgm);
    _onRefresh();
  }
}