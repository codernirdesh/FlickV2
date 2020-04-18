import 'package:flutter/material.dart';
import 'package:flick/pages/movies.dart';
import 'package:flick/pages/search.dart';
import 'package:flick/pages/tv.dart';
import 'package:flick/pages/watchlist.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      MoviesPage(),
      TvPage(),
      SearchPage(),
      WatchList(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.movie),
        title: (" "),
        activeColor: Colors.pink,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.tv),
        title: (" "),
        activeColor: Colors.teal,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: (" "),
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.watch_later),
        title: (" "),
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
    bottomNavigationBar: PersistentTabView(          
      controller: _controller,
      items: _navBarsItems(),
      screens: _buildScreens(),
      showElevation: false,
      navBarCurve: NavBarCurve.upperCorners,
      backgroundColor: Colors.black,
      iconSize: 30.0,
      navBarStyle:
          NavBarStyle.style5, // Choose the nav bar style with this property
      onItemSelected: (index) {},
    ));
  }
}
