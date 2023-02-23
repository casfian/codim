import 'package:codimappp/screens/detailmap.dart';
import 'package:codimappp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewMyPlots extends StatefulWidget {
  //if specific data query
  @override
  _ViewMyPlotsState createState() => _ViewMyPlotsState();
}

class _ViewMyPlotsState extends State<ViewMyPlots> {
  late bool isLogin = false;
  String? _useruid;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print('at viewmyplots, FirebaseUser::');
      if (user == null) {
        print('User is signed out!');
        setState(() {
          isLogin = false;
        });
      } else {
        print('User is signed in @ viewmyplots');
        print(user.uid);
        _useruid = user.uid;

        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_useruid);
    return isLogin
        ? ViewMyPlotsWidget(useruid: _useruid)
        : Login(returnclass: '/viewmyplots');
  }
}

class ViewMyPlotsWidget extends StatefulWidget {
  ViewMyPlotsWidget({Key? key, this.useruid}) : super(key: key);

  final String? useruid;

  @override
  _ViewMyPlotsWidgetState createState() => _ViewMyPlotsWidgetState();
}

class _ViewMyPlotsWidgetState extends State<ViewMyPlotsWidget> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _plotsStream = FirebaseFirestore.instance
        .collection('plots')
        .where('useruid', isEqualTo: widget.useruid.toString())
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Plots',
            style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/plot');
            },
            icon: Icon(Icons.add),
            color: Colors.blue,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.close),
            color: Colors.white,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _plotsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text(
                      document.id.toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    subtitle: Text(
                        'Coordinate: ${data['mapdata']['lat'].toString()} ${data['mapdata']['lon'].toString()} verified: ${data['verified'].toString().toUpperCase()}',
                        style: TextStyle(fontSize: 11)),
                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailMap(docref: document.id.toString())));
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
