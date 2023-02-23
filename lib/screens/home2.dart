// import 'package:codimappp/widgets/toprow.dart';
import 'package:codimappp/screens/detailmap.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  //Streams
  final Stream<QuerySnapshot> _announcementStream = FirebaseFirestore.instance
      .collection('anouncements')
      .orderBy('message')
      .limitToLast(1)
      .snapshots();

  final Stream<QuerySnapshot> _plotsStream = FirebaseFirestore.instance
      .collection('plots')
      .orderBy('username')
      //.limitToLast(10)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'OttoMap',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.blue[500]),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: Icon(
                Icons.person_rounded,
                color: Colors.blue,
              ))
        ],
      ),
      body: Column(
        children: [
          //This to show announcements
          Container(
            width: 368,
            height: 25,
            child: StreamBuilder<QuerySnapshot>(
              stream: _announcementStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                      child: Text(
                        data['message'].toString().toUpperCase(),
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          //end announcements
      
          //Top Image
          Stack(children: [
            Image.asset('assets/images/land.png'),
            Positioned(
              left: 20,
              top: 20,
              child: Container(
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ]),
      
          //Menu
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    width: 50,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.green[100],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            //View All Land Points
                            print('See Land Points');
                            Navigator.pushNamed(context, '/viewlandmap');
                          },
                          icon: Icon(
                            Icons.place_outlined,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'View Plots',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 50,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.blue[100],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            //View All Land Points
                            print('See Land Points');
                            Navigator.pushNamed(context, '/plot');
                          },
                          icon: Icon(
                            Icons.place_rounded,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Add Plot',
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 50,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.pink[100],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            //View All Land Points
                            print('See My Plots');
                            Navigator.pushNamed(context, '/viewmyplots');
                          },
                          icon: Icon(
                            Icons.place_rounded,
                            size: 40,
                            color: Colors.pink,
                          ),
                        ),
                        Text(
                          'My Plots',
                          style: TextStyle(fontSize: 14, color: Colors.pink),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          //this to show land Plots
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              'Latest Land Plots',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[500],
              ),
            ),
          ),
          //List of Land Plots
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _plotsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Card(
                      elevation: 1,
                      margin: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: ListTile(
                        leading: Icon(
                          Icons.image,
                          size: 48,
                          color: Color.fromRGBO(128, 128, 128, 0.4),
                        ),
                        title: Text(data['username'].toString().toUpperCase(), style: TextStyle(color: Colors.blue),),
                        subtitle: Text('Coordinate: ${data['mapdata'].toString()} Verified: ${data['verified'].toString()}',
                         style: TextStyle(fontSize: 11),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_sharp,
                          size: 15,
                          color: Color.fromRGBO(128, 128, 128, 0.4),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailMap(docref: document.id.toString())));
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

