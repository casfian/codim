import 'package:codimappp/screens/login.dart';
import 'package:codimappp/screens/plotmap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 
class Plot extends StatefulWidget {
  @override
  _PlotState createState() => _PlotState();
}

class _PlotState extends State<Plot> {

  late bool isLogin = false;

  //check if login or not
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('at plot, FirebaseUser::');
      if (user == null) {
        print('User has signed out!');
        setState(() {
          isLogin = false;
        });
        
      } else {
        print('User is signed in!');
        print(user.email);
        setState(() {
          isLogin = true;
        });
      }
    });
  }
  //====

  @override
  Widget build(BuildContext context) {
    return isLogin ? PlotMap() : Login(returnclass: '/plot');
  }
}