import 'package:codimappp/screens/editcrops.dart';
import 'package:codimappp/screens/editplotdetails.dart';
import 'package:codimappp/screens/editremark.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailMap extends StatefulWidget {
  DetailMap({Key? key, this.docref}) : super(key: key);

  final String? docref;

  @override
  _DetailMapState createState() => _DetailMapState();
}

class _DetailMapState extends State<DetailMap> {
  var collection = FirebaseFirestore.instance.collection('plots');

  late GoogleMapController _controller;
  var _maptype = MapType.normal;
  bool isMapDefault = true;
  double _zoom = 14;
  //float zoom=googleMap.getCameraPosition().zoom;

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  List<Marker> allmarkers = [];
  List<dynamic> amarker = [];
  int nomarker = 0;

  //for drawing polyline, later we will use firebase
  List<Map<String, dynamic>> myPolypoints = [];

  List<Polyline> _polyLine = [];
  List<LatLng> latlngSegment1 = [];

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

  @override
  void initState() {
    super.initState();
    print(widget.docref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(widget.docref).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');
            if (snapshot.hasData) {
              var plotdata = snapshot.data!.data();
              List locationdata = plotdata!['location'];
              var mapdata = plotdata['mapdata'];
              var landowner = plotdata['landowner'];
              var contactno = plotdata['contactno'];
              var claimtype = plotdata['claimtype'];
              var ethnicity = plotdata['ethnicity'];
              var gender = plotdata['gender'];
              var acre = plotdata['acre'];
              var hectar = plotdata['hectar'];
              var communityvillage = plotdata['communityvillage'];
              var district = plotdata['district'];
              var division = plotdata['division'];
              var remark = plotdata['remark'];
              List location = plotdata['location'];
              List crop = plotdata['cropdata'];

              createlinesegment(locationdata);

              void increaseZoom() {
                _controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(mapdata['lat'], mapdata['lon']),
                        zoom: _zoom)));
              }

              void decreaseZoom() {
                _controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(mapdata['lat'], mapdata['lon']),
                        zoom: _zoom)));
              }

              //point here
              print('Start========');
              for (var i = 0; i < locationdata.length; i++) {
                print(locationdata[i]['lat']);
                print(locationdata[i]['lon']);

                ++nomarker;
                allmarkers.add(Marker(
                    markerId: MarkerId(nomarker.toString()),
                    draggable: true,
                    onTap: () {
                      print('Marker $i Tapped');
                    },
                    position:
                        LatLng(locationdata[i]['lat'], locationdata[i]['lon']),
                    infoWindow: InfoWindow(
                        title: 'Coordinate: ' +
                            locationdata[i]['lat'].toString() +
                            ', ' +
                            locationdata[i]['lon'].toString())));
              }
              print('end========');

              print(mapdata['lat']);
              print(mapdata['lon']);
              print(mapdata['zoom']);

              return ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(100, 115, 125, 0.1),
                    ),
                    child: GoogleMap(
                      zoomGesturesEnabled: true,
                      mapType: _maptype,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(mapdata['lat'], mapdata['lon']),
                          zoom: mapdata['zoom'].toDouble()),
                      onMapCreated: mapCreated,
                      myLocationEnabled: true,
                      markers: Set.from(allmarkers),
                      polylines: Set.from(_polyLine),

                      //use this so that gestures works in Googlemap in Listview
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                      //end gesture
                    ),
                  ),

                  // Controls to map
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
                  //end control for map

                  SizedBox(
                    height: 20,
                  ),

                  //coordinates box title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Coordinates',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  //Edit
                                },
                                icon: Icon(Icons.edit, color: Colors.blue))
                          ],
                        ),
                      ),
                    ],
                  ),
                  //coordinates box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: (location.length + 1) * 47,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(225, 225, 225, 0.9),
                    ),
                    child: Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: location.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text('$index'),
                              title: Text(
                                'Lat/Lng: ${location[index]['lat'].toString()} / ${location[index]['lon'].toString()}',
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //info box title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Plot Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditPlotDetails(docref: widget.docref.toString(),)));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  //info box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 170,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(225, 225, 225, 0.9),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Owner: $landowner'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Gender: $gender'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Contactno: $contactno'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Claim Type: $claimtype'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Ethnicity: $ethnicity'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Village: $communityvillage'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Division: $division'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('District: $district'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Acre: $acre'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                    child: Text('Hectar: $hectar'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Crop box title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Crops',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditCrops(docref: widget.docref.toString(),)));
                                },
                                icon: Icon(Icons.edit, color: Colors.blue))
                          ],
                        ),
                      ),
                    ],
                  ),
                  //crop box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: (crop.length + 1) * 28,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(225, 225, 225, 0.9),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: crop.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 25,
                                child: ListTile(
                                  title: Text('${crop[index]}'),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  //remark box title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Remarks',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditRemark(docref: widget.docref.toString(),)));
                                },
                                icon: Icon(Icons.edit, color: Colors.blue))
                          ],
                        ),
                      ),
                    ],
                  ),
                  //remark box
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(225, 225, 225, 0.9),
                    ),
                    child: Row(
                      children: [
                        Text('$remark'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
