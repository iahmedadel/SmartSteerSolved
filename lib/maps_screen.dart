import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(0.0, 0.0); // Default location

  @override
  void initState() {
    super.initState();
    _locateUser();
  }

  Future<void> _locateUser() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enable location services")),
      );
      return;
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Location permissions are permanently denied")),
        );
        return;
      }
    }

    // Get the user's current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
