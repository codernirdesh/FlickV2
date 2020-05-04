import 'package:Flick/extra/splash.dart';
import 'package:Flick/ui/navbar.dart';
import 'package:flutter/material.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.black,
      theme: ThemeData(
          brightness: Brightness.dark, canvasColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      home: CustomSplash(
        imagePath: 'assets/splash.png',
        animationEffect: 'fade-in',
        home: MyHomePage(),
        duration: 2500,
        type: CustomSplashType.StaticDuration,        
      ),
    );
  }
}

