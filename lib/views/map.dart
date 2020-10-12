import 'dart:async';

import 'package:chatApp/helper/Constants.dart';
import 'package:chatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class myMap extends StatefulWidget {
  final name;
  myMap({this.name});
  @override
  _myMapState createState() => _myMapState();
}

double lat = 0;
double long = 0;
String name1;

class _myMapState extends State<myMap> {
  Set<Marker> _markers = {};
  bool _loading = false;
  getuserlocation() async {
    await FirebaseFirestore.instance
        .collection('location')
        .doc(widget.name)
        .get()
        .then((value) {
      lat = double.parse(value.data()['Location'][0]);
      long = double.parse(value.data()['Location'][1]);
      print(lat);
      print(long);
      setState(() {
        _loading = false;
        _markers.add(Marker(
          infoWindow: InfoWindow(
            title: widget.name,
          ),
          markerId: MarkerId('<MARKER_ID>'),
          position: LatLng(lat, long),
        ));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _loading = true;
    });
    getuserlocation();
    name1 = widget.name;
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var cp = CameraPosition(
      target: LatLng(lat, long),
      zoom: 50,
      tilt: 50,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name + "'s" + " " + "Live Location"),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: GoogleMap(
                initialCameraPosition: cp,
                markers: _markers,
              )));
  }
}
