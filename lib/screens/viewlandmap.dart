import 'package:codimappp/model/user_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ViewLandMap extends StatefulWidget {
  @override
  _ViewLandMapState createState() => _ViewLandMapState();
}

class _ViewLandMapState extends State<ViewLandMap> {
  //Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController controller;

  //map points
  var _maptype = MapType.normal;
  bool isMapDefault = true;
  double _zoom = 6;

  //for the Markers
  List<Marker> allmarkers = [];
  List<dynamic> amarker = [];
  int nomarker = 0;

  //for drawing polyline, later we will use firebase
  List<Map<String, dynamic>> myPolypoints = [];

  List<Polyline> _polyLine = [];
  List<LatLng> latlngSegment = [];

  //create polyline segment
  void createlinesegment(List myList, List<LatLng> mysegment) {
    for (int index = 0; index < myList.length; index++) {
      mysegment.add(LatLng(myList[index]['lat'], myList[index]['lon']));
    }

    //create polylines
    _polyLine.add(Polyline(
      polylineId: PolylineId('line1'),
      visible: true,
      points: mysegment,
      width: 3,
      color: Colors.red,
    ));
  }
  //end for polyline

  void getLocationfromFirebase() {
    // with query, if no query just delete where
    FirebaseFirestore.instance
        .collection('plots')
        .where('verified', isEqualTo: true)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      //first Loop to get array list of markers
      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; ++i) {
          print(querySnapshot.docs[i].data()['location']);
          amarker = querySnapshot.docs[i].data()['location'];
          //second loop to get each marker
          if (amarker.isNotEmpty) {
            for (int j = 0; j < amarker.length; ++j) {
              //print(amarker[j]);
              print('Marker no: $nomarker');
              ++nomarker;
              setState(() {
                print(amarker[j]['lat']);
                print(amarker[j]['lon']);
                print('object $j: ----');
                allmarkers.add(Marker(
                    markerId: MarkerId(nomarker.toString()),
                    draggable: true,
                    onTap: () {
                      print('Marker $j Tapped');
                    },
                    position: LatLng(amarker[j]['lat'], amarker[j]['lon']),
                    infoWindow:
                        InfoWindow(title: 'Marker ' + nomarker.toString())));
              });

              //add points for polyline
              //I undouble parse this
              myPolypoints
                  .add({'lat': amarker[j]['lat'], 'lon': amarker[j]['lon']});
              //end for polyline

            }

            //add last points for polyline which is the first point

            myPolypoints.add(myPolypoints[0]);
            print('MyPolypoints: $myPolypoints');
            //after that create the full line segment
            createlinesegment(myPolypoints, latlngSegment);
            print('Create Polyline $i');

            //end last point for polyline so that it closes
          }
        }
      }
    });
  }

  void mapCreated(controller) {
    setState(() {
      controller = controller;
    });
  }

  @override
  void initState() {
    getLocationfromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    UserLocation userLocation = Provider.of<UserLocation>(context);


    // void increaseZoom() {
    //   _controller.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(userLocation.latitude, userLocation.longitude), zoom: _zoom)));
    // }

    // void decreaseZoom() {
    //   _controller.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(userLocation.latitude, userLocation.longitude), zoom: _zoom)));
    // }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('View Plots',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        //backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Verified land points'),
            SizedBox(
              height: 20,
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(100, 115, 125, 0.1),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                mapType: _maptype,
                initialCameraPosition: CameraPosition(
                    target: LatLng(userLocation.latitude, userLocation.longitude), zoom: _zoom),
                onMapCreated: mapCreated,
                myLocationEnabled: true,
                markers: Set.from(allmarkers),
                //polylines: Set.from(_polyLine),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Controls: ',
                  style: TextStyle(
                      color: Colors.cyan, fontWeight: FontWeight.bold),
                ),
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
                // IconButton(
                //   onPressed: () {
                //     print('Increase Zoom');
                //     setState(() {
                //       _zoom = _zoom + 1.0;
                //       increaseZoom();
                //       print(_zoom);
                //     });
                //   },
                //   icon: Icon(Icons.arrow_upward),
                //   color: Colors.cyan,
                // ),
                // IconButton(
                //   onPressed: () {
                //     print('Decrease Zoom');
                //     setState(() {
                //       _zoom = _zoom - 1.0;
                //       decreaseZoom();
                //       print(_zoom);
                //     });
                //   },
                //   icon: Icon(Icons.arrow_downward),
                //   color: Colors.cyan,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
