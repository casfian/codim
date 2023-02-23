import 'package:codimappp/screens/intro.dart';
import 'package:codimappp/screens/plotmap.dart';
import 'package:codimappp/screens/profile.dart';
import 'package:codimappp/screens/viewlandmap.dart';
import 'package:codimappp/screens/viewmyplots.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentindex = 2;

  List pages = [PlotMap(), ViewLandMap(), Intro(), ViewMyPlots(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: pages[currentindex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.add_location, title: 'Plot'),
          TabItem(icon: Icons.map, title: 'Map'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.list_alt_outlined, title:'List'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: 2,
        onTap: (int i) {
          setState(() {
            currentindex = i;
          });
          
        },
      ),
    );
  }
}
