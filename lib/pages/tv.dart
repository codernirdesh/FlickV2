import 'package:Flick/ui/RoundCards.dart';
import 'package:flutter/material.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TvPage extends StatefulWidget {
  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          ListView(physics: AlwaysScrollableScrollPhysics(), children: <Widget>[
        Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.only(left: 40),
                  height: MediaQuery.of(context).size.height / 3.1,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.dstATop),
                        image: AssetImage('assets/series.jpg'),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 3.1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [Colors.black, Colors.black26]),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3.9, left: 20),
                  child: Text('TV',
                      style: TextStyle(
                          fontSize: 75,
                          color: Colors.white,
                          fontFamily: 'RussoOne',
                          fontWeight: FontWeight.bold))),
              ConnectionStatusBar(
                height: 25,
                width: double.maxFinite,
                color: Colors.redAccent,
                lookUpAddress: 'google.com',
                endOffset: const Offset(0.0, 0.0),
                beginOffset: const Offset(0.0, -1.0),
                animationDuration: const Duration(milliseconds: 200),
                title: Text(
                  'Please check your internet connection :(',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ]),
            RoundCard(
              prefixText: 'POPULAR TV SHOWS',
              type: 'popular',
              movieOrTv: 'tv',
            ),
            SizedBox(height: 20),
            RoundCard(
              prefixText: 'TOP RATED TV SHOWS',
              type: 'top_rated',
              movieOrTv: 'tv',
            ),
            SizedBox(height: 20),
            RoundCard(
              prefixText: 'TV SHOWS AIRING TODAY',
              type: 'airing_today',
              movieOrTv: 'tv',
            ),
            SizedBox(height: 20),
            RoundCard(
              prefixText: 'TV SHOWS AIRING NOW',
              type: 'on_the_air',
              movieOrTv: 'tv',
            ),
          ],
        ),
      ]),
    );
  }
}
