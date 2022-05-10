import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';

import '../bloc/craft_states.dart';
import '../bloc/home_cubit.dart';
import 'other_user_profile.dart';

class MapScreen extends StatefulWidget {
  final CraftUserModel cubit;
  final double lat;
  final double long;

  const MapScreen(
      {Key? key, required this.cubit, required this.lat, required this.long})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

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
      myMarkers.add(marker);
    });
  }

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  //LocationPermission? _locationPermission;
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

  HashSet<Marker> myMarkers = HashSet<Marker>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var myCubit = CraftHomeCubit.get(context);

        return Scaffold(
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

                    //initMarkerData(myLong!, myLat!,  myCubit.UserModel!.name, myCubit.UserModel!.craftType,const MarkerId('1'),);
                    // initMarkerData(long!, lat!,   widget.cubit.name!,myCubit.UserModel!.craftType,const MarkerId('2'),);

                    myMarkers.add(
                      Marker(
                        markerId: const MarkerId('1'),
                        position: LatLng(myCubit.cPosition.latitude,
                            myCubit.cPosition.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        infoWindow: InfoWindow(
                          title: myCubit.UserModel!.name,
                          snippet: myCubit.UserModel!.craftType,
                        ),
                      ),
                    );

                    myMarkers.add(Marker(
                      markerId: const MarkerId('2'),
                      position: LatLng(widget.lat, widget.long),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueYellow),
                      infoWindow: InfoWindow(
                          title: widget.cubit.name,
                          snippet: widget.cubit.craftType,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherUserProfile(
                                        userModel: widget.cubit)));
                          },),
                    ),);
                  },);

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
