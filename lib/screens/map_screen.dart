import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';


import '../bloc/craft_states.dart';
import '../bloc/home_cubit.dart';
import '../helpers/cache_helper.dart';

class MapScreen extends StatefulWidget {

  final CraftUserModel cubit;

  const MapScreen({Key? key,required this.cubit}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;



   double? lat;
   double? long;
  double? myLat;
  double? myLong;




  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.5, 34.46667),
    zoom: 12,
  );

  // map to store all markers
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // initialize the marker to every user
  initMarkerData(longitude, latitude, name, craftType, specifyId) {
    var markerIdVal = specifyId;
    final markerId = MarkerId(markerIdVal.toString());
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(longitude, latitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(
        title: name,
        snippet: craftType,
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }


  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14); //zoom

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  giveLatLong()async{

    // get other lat and long
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.cubit.uId)
        .get().then((value) {
          setState(() {
            lat = value['latitude'];
            long = value['longitude'];
          });
          print(value['latitude']);
          print(value['longitude']);
    })
        .catchError((error){
          print(error.toString());
    });
  }
  giveMuLatLong()async{

  // get my lat and long
  await FirebaseFirestore.instance
      .collection('users')
      .doc(CacheHelper.getData(key: 'uId'))
      .get().then((value) {
  setState(() {
  myLat = value['latitude'];
  myLong = value['longitude'];
  });
  print(value['latitude']);
  print(value['longitude']);
  })
      .catchError((error){
  print(error.toString());
  });

}

  @override
  void initState() {
    super.initState();

    giveLatLong();
    giveMuLatLong();
  }


  HashSet<Marker> myMarkers = HashSet<Marker>();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {


        if (state is CraftGetLocationErrorState){
          print(state.error);
        }

      },
      builder: (context, state) {
        var myCubit = CraftHomeCubit.get(context);

        return
          Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              elevation: 0,
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'الموقع',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                GoogleMap(
                  padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
                  mapType: MapType.normal,
                  markers: myMarkers,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {

                    _controllerGoogleMap.complete(controller);
                    newGoogleMapController = controller;

                    setState(() {
                      bottomPaddingOfMap = 240;

                      // my marker
                      myMarkers.add(Marker(
                          markerId: const MarkerId('1'),
                          position:  LatLng(myLat!,myLong!),
                          infoWindow: InfoWindow(
                              title: myCubit.UserModel!.name,
                              snippet: myCubit.UserModel!.craftType != '' ?
                              '${myCubit.UserModel!.craftType} || ${myCubit.UserModel!.phone} '
                                  :
                              '${myCubit.UserModel!.phone} '
                              ,
                              onTap: () {
                                print('marker is printed**************************');
                              })
                      ));

                      // other marker
                      myMarkers.add(Marker(
                          markerId: const MarkerId('2'),
                          position:  LatLng(lat!,long!),
                          infoWindow: InfoWindow(
                              title: widget.cubit.name!,
                              snippet: myCubit.UserModel!.craftType != '' ?
                              '${myCubit.UserModel!.craftType} || ${myCubit.UserModel!.phone} '
                                  :
                              '${myCubit.UserModel!.phone} '
                              ,
                              onTap: () {
                                print('marker is printed**************************');
                              })
                      ));
                    });

                    locateUserPosition();
                  },
                ),
              ],
            ),
          );
        },
    );
  }
}

