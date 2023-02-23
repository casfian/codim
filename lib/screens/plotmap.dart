import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codimappp/helpers/helper.dart';
import 'package:codimappp/model/user_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlotMap extends StatefulWidget {
  @override
  _PlotMapState createState() => _PlotMapState();
}

class _PlotMapState extends State<PlotMap> {
  //loop starts at zero
  int i = 0;

  late GoogleMapController _controller;

  var _maptype = MapType.normal;
  bool isMapDefault = true;
  double _zoom = 13;
  late Marker marker;
  late Circle circle;

  late List<Marker> allmarkers = [];

  //for drawing polyline, later we will use firebase
  List<Map<String, dynamic>> myPolypoints = [];

  List<Polyline> _polyLine = [];
  List<LatLng> latlngSegment1 = [];

  //create polyline segment
  void createlinesegment(List myList) {
    for (int index = 0; index < myList.length; index++) {
      latlngSegment1.add(LatLng(myList[index]['lat'], myList[index]['lon']));
    }

    //create polylines
    _polyLine.add(Polyline(
      polylineId: PolylineId('line1'),
      visible: true,
      points: latlngSegment1,
      width: 3,
      color: Colors.red,
    ));
  }
  //end for polyline

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  CollectionReference plots = FirebaseFirestore.instance.collection('plots');
  var useruid = '';
  var username = '';
  bool verified = false;
  var email = '';
  var icnumber = '';
  var contactno = '';
  var gender = '';
  var ethnicity = '';
  var paymentcod = '';
  var datedata = '';
  var landowner = '';
  var claimtype = '';
  var acre = '';
  var hectar = '';
  var communitylocal = '';
  var communityvillage = '';
  var district = '';
  var division = '';
  var remark = '';
  var relation = '';
  var fblink = '';
  var ytlink = '';
  var adlink = '';
  List<Map<String, dynamic>> cropdata = [];
  List<Map<String, dynamic>> photodata = [];
  var mapdata;

  Future<void> addPlot(
      String useruid,
      String username,
      bool verified,
      String email,
      String icnumber,
      String contactno,
      String gender,
      String ethnicity,
      String paymentcod,
      String datedata,
      String landowner,
      String claimtype,
      String acre,
      String hectar,
      String communitylocal,
      String communityvillage,
      String district,
      String division,
      String remark,
      String relation,
      String fblink,
      String ytlink,
      String adlink,
      List cropdata,
      List photodata,
      List locationdata,
      mapdata) async {
    // Call the Plot's CollectionReference to add a new plot
    await plots
        .add({
          'useruid': useruid,
          'username': username,
          'verified': false,
          'email': email,
          'icnumber': icnumber,
          'contactno': contactno,
          'gender': gender,
          'ethnicity': ethnicity,
          'paymentcod': paymentcod,
          'datedata': datedata,
          'landowner': landowner,
          'claimtype': claimtype,
          'acre': acre,
          'hectar': hectar,
          'communitylocal': communitylocal,
          'communityvillage': communityvillage,
          'district': district,
          'division': division,
          'remark': remark,
          'fblink': fblink,
          'ytlink': ytlink,
          'adlink': adlink,
          'relation': relation,
          'cropdata': cropdata,
          'photodata': photodata,
          'location': myPolypoints,
          'mapdata': mapdata,
        })
        .then((value) => print("Plot Added"))
        .catchError((error) => print("Failed to add Plot: $error"));
  }

  late bool isLogin = false;
  late bool isDone = false;

  //this we get from firebaseauth in init
  String? _useruid;
  //we will get from Firebase in init
  String? _username;
  String? _useremail;
  String? _userethnicity;
  String? _usergender;
  String? _usericnumber;
  String? _usercontactno;

  @override
  void initState() {
    super.initState();

    //To get the useruid from Auth but not from users collection
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _useruid = user?.uid;
        _useremail = user?.email;

        print('useruid:');
        print(_useruid);
        print('username:');
        print(username);
        print('------');

        //so we must read from firebase collection 'users'
        FirebaseFirestore.instance
            .collection('users')
            .where('useruid', isEqualTo: _useruid)
            .get()
            .then((value) {
          value.docs.forEach((result) {
            print(result.data());
            print(result['username']);
            _username = result['username'];
            _usergender = result['gender'];
            _userethnicity = result['ethnicity'];
            _usercontactno = result['contactno'];
            _usericnumber = result['icnumber'];
          });
        });
      });
    });
  }

  @override
  void dispose() {
    //gotta dispose something
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserLocation userLocation = Provider.of<UserLocation>(context);

    void increaseZoom() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: _zoom)));
    }

    void decreaseZoom() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: _zoom)));
    }

    //to draw a circle of user accuracy on Google map
    Set<Circle> circles = Set.from([
      Circle(
        circleId: CircleId('Home'),
        center: LatLng(userLocation.latitude, userLocation.longitude),
        radius: userLocation.accuracy,
        strokeColor: Colors.blue,
        strokeWidth: 1,
        fillColor: Colors.green.withAlpha(50),
      )
    ]);

    //draw a marker when Add Marker button is pressed
    void addMarker(int index) {
      // Create a new Home marker
      print('Marker: $index');
      print(
          'Location: Lat:${userLocation.latitude}, Long: ${userLocation.longitude}, accuracy: ${userLocation.accuracy}');
      allmarkers.add(
        Marker(
          markerId: MarkerId(index.toString()),
          draggable: true,
          onTap: () {
            //
          },
          infoWindow: InfoWindow(
            title: 'Marker: ' + index.toString(),
            snippet: 'Lat: ' +
                userLocation.latitude.toString() +
                ' Long: ' +
                userLocation.longitude.toString() +
                'Accuracy: ' +
                userLocation.accuracy.toString() +
                'm',
            onTap: () {
              print('Maker pressed Index: $index');
            },
          ),
          position: LatLng(userLocation.latitude, userLocation.longitude),
        ),
      );

      //add points for polyline
      myPolypoints.add({
        'lat': userLocation.latitude,
        'lon': userLocation.longitude,
      });
      //end points for polyline
    }

    //when Done button is pressed
    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          isDone = false;
          Navigator.pop(context);
        },
      );

      Widget continueButton = TextButton(
        child: Text("Continue"),
        onPressed: () {
          //==========
          final snackBar =
              SnackBar(content: Text('Done! All points Completed'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print('There are ${allmarkers.length} Markers');
          //==========
          Navigator.pop(context);

          setState(() {
            myPolypoints.add(myPolypoints[0]);
            //then create the line segment
            createlinesegment(myPolypoints);
            //end last point for polyline so that it closes
            isDone = true;
          });

          //we get these data from query firebase 'users' in init
          //here we substitute
          useruid = _useruid!;
          email = _useremail!;
          username = _username!;
          gender = _usergender!;
          contactno = _usercontactno!;
          icnumber = _usericnumber!;
          ethnicity = _userethnicity!;

          //this to make sure the map will be viewed properly in detailmap
          mapdata = {
            'lat': myPolypoints[0]['lat'],
            'lon': myPolypoints[0]['lon'],
            'zoom': _zoom
          };

          //save to firebase here
          print('Save all points to Firebase');
          addPlot(
              useruid,
              username,
              verified,
              email,
              icnumber,
              contactno,
              gender,
              ethnicity,
              paymentcod,
              datedata,
              landowner,
              claimtype,
              acre,
              hectar,
              communitylocal,
              communityvillage,
              district,
              division,
              remark,
              relation,
              fblink,
              ytlink,
              adlink,
              cropdata,
              photodata,
              myPolypoints,
              mapdata);
          //==========
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Done and Close Polyline"),
        content: Text(
            "This will create a new plot and save your land! Are you sure?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Add Plot',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        //backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showMessageBox(context, 'Instruction',
                    'This Map requires user to move and plot points on their land. Once you satisfied with the points, press the Done button to finish.');
              },
              icon: Icon(Icons.info_outline))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Instruction: Move along, press Add point, and once you satisfied press Done'),
              SizedBox(
                height: 10,
              ),
              
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(110, 110, 195, 0.2),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  mapType: _maptype,
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(userLocation.latitude, userLocation.longitude),
                      zoom: _zoom),
                  onMapCreated: mapCreated,
                  myLocationEnabled: true,
                  markers: Set.from(allmarkers),
                  circles: circles,
                  polylines: Set.from(_polyLine),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Coordinates: (Lat:${userLocation.latitude}, Lon: ${userLocation.longitude}) Accuracy: ${userLocation.accuracy}m',
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      print('Toggle Map');
                      setState(() {
                        if (isMapDefault == true) {
                          _maptype = MapType.hybrid;
                          isMapDefault = false;
                        } else {
                          _maptype = MapType.normal;
                          isMapDefault = true;
                        }
                      });
                    },
                    icon: Icon(Icons.change_circle_rounded),
                    color: Colors.cyan,
                  ),
                  IconButton(
                    onPressed: () {
                      print('Increase Zoom');
                      setState(() {
                        _zoom = _zoom + 1.0;
                        increaseZoom();
                        print(_zoom);
                      });
                    },
                    icon: Icon(Icons.arrow_upward),
                    color: Colors.cyan,
                  ),
                  IconButton(
                    onPressed: () {
                      print('Decrease Zoom');
                      setState(() {
                        _zoom = _zoom - 1.0;
                        decreaseZoom();
                        print(_zoom);
                      });
                    },
                    icon: Icon(Icons.arrow_downward),
                    color: Colors.cyan,
                  ),
                  Text(
                    'Zoom Level: $_zoom',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white24,
                ),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: isDone == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                              onPressed: () {
                                //add point
                                setState(() {
                                  i = i + 1;
                                  addMarker(i);
                                  //suppose to add polyline points here
                                });
                                final snackBar =
                                    SnackBar(content: Text('Point Added'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              icon: Icon(Icons.add),
                              label: Text('Add point')),
                          SizedBox(
                            width: 20,
                          ),
                          OutlinedButton(
                              onPressed: () {
                                //done
                                print('done');
                                //check if minimum 3 points, coz you need 3 points to create a polygon
                                if (allmarkers.length < 3) {
                                  // final snackBar = SnackBar(
                                  //     content: Text(
                                  //         'Points Not Enough to complete. You need at least 3 points to plot a complete polygon area.'));
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(snackBar);
                                  showMessageBox(context, 'Sorry',
                                      'You need at least 3 points to plot a complete polyline area.');
                                } else {
                                  showAlertDialog(context);
                                  print('Go Plot the Polylines here');
                                }
                              },
                              
                              child: Text('Done')),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/viewmyplots');
                              },
                              child: Text('Proceed'))
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
