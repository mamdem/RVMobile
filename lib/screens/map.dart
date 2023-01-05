import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/models/utils/global.dart' as global;

class MapSample extends StatefulWidget{
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {

  bool isloc = true;
  int index=0;
  late GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map


  @override
  Widget build(BuildContext context) {
    final json = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    setState(() {
      index = json['index'];
    });
    LatLng showLocation = LatLng(global.allDoctors[index]['structure']['latitude'], global.allDoctors[index]['structure']['longitude']); //location to show in map
    Set<Marker> getmarkers() {
      markers.add(Marker( //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      return markers;
    }
    return  Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        backgroundColor: Color(MyColors.primary),
        actions: <Widget>[
          IconButton(
              onPressed: (){
                setState(() {
                  isloc=false;
                });
              },
              icon: Icon(Icons.route)
          ),
          IconButton(onPressed: (){
            setState(() {
              isloc=true;
            });
          },
              icon: Icon(Icons.location_on))
        ],
      ),
      body: way()
    );
  }
  
  Widget showPosition(LatLng showLocation){
    markers.add(Marker( //add third marker
      markerId: MarkerId(showLocation.toString()),
      position: showLocation, //position of marker
      infoWindow: InfoWindow( //popup info
        title: 'Marker Title Third ',
        snippet: 'My Custom Subtitle',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    return GoogleMap( //Map widget from google_maps_flutter package
      zoomGesturesEnabled: true, //enable Zoom in, out on map
      initialCameraPosition: CameraPosition( //innital position in map
        target: showLocation, //initial position
        zoom: 15.0, //initial zoom level
      ),
      markers: markers, //markers to show on map
      mapType: MapType.normal, //map type
      onMapCreated: (controller) { //method called when map is created
        setState(() {
          mapController = controller;
        });
      },
    );
  }

  Widget way(){
    final Completer< GoogleMapController > _controller = Completer();
    const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
    const LatLng destination = LatLng(37.33429383, -122.06600055);

    return GoogleMap(
      initialCameraPosition : CameraPosition(
        target: sourceLocation,
        zoom: 13.5,
      ),
      markers : {
        const Marker(
          markerId: MarkerId("source"),
          position: sourceLocation,
        ),
        const Marker(
          markerId: MarkerId("destination"),
          position : destination,
        ),
      },
      onMapCreated : (mapController) {
        _controller.complete(mapController);
      },
    );
  }
}


