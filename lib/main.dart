import 'package:flutter/material.dart';
import 'package:flick/pages/detailed_movie.dart';
import 'package:flick/pages/movies.dart';
import 'package:flick/pages/watchlist.dart';
import 'package:flick/ui/navbar.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // home: Home(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        'watchlist': (context) => WatchList(),
        'detailed_movie': (context) => MovieDetail(),
        'movies': (context) => MoviesPage()
      },      
      
    );
  }
}
