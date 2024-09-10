import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wahid_uber_app/driver/models/trip_details.dart';
import 'package:wahid_uber_app/global_variables.dart';

class NewTripScreen extends StatefulWidget {
  final TripDetails tripDetails;

  const NewTripScreen({Key? key, required this.tripDetails}) : super(key: key);

  @override
  _NewTripScreenState createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  DatabaseReference? newTripRequestRef;
  String? tripStatus;
  LatLng? tripStartLatLng;
  LatLng? tripEndLatLng;
  List<LatLng>? routePoints;
  BitmapDescriptor? customMarkerIcon;
  StreamSubscription<Position>? _positionStreamSubscription;
  String startOfTrip = 'accepted';
  String durationText = '';
  String buttonText = "ARRIVED";
  GoogleMapController? _googleMapController;
  Marker? driverMarker;

  Color buttonColor = Colors.purple;

  @override
  void initState() {
    super.initState();

    tripStartLatLng = widget.tripDetails.pickup;
    tripEndLatLng = widget.tripDetails.destination;

    if (tripStartLatLng != null && tripEndLatLng != null) {
      fetchRoute(tripStartLatLng!, tripEndLatLng!).then((points) {
        setState(() {
          routePoints = points;
        });
      }).catchError((error) {
        print('Error fetching route: $error');
      });
    }

    _loadCustomMarkerIcon();
    _startLocationUpdates();
  }

  Future<void> _loadCustomMarkerIcon() async {
    customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/car_android.png',
    );
  }

  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    const apiKey = 'AIzaSyBbgLtZvsRAB5DcnPOoirbEi6n4hTsThZ4';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      return decodePolyline(points);
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      points.add(LatLng(
        (lat / 1E5),
        (lng / 1E5),
      ));
    }
    return points;
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 5))
        .listen((Position position) {
      LatLng driverPositionLatlng =
          LatLng(position.latitude, position.longitude);

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: driverPositionLatlng, zoom: 17, tilt: 60);
        _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
        _updateDriverMarker(driverPositionLatlng);
      });

      FirebaseDatabase.instance
          .ref()
          .child('tripRequest')
          .child(widget.tripDetails.tripID!)
          .child('driverLocation')
          .set({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      updateTripDetailsInfo(driverPositionLatlng);
    });
  }

  void _updateDriverMarker(LatLng position) {
    setState(() {
      driverMarker = Marker(
        markerId: const MarkerId('driver'),
        position: position,
        icon: customMarkerIcon ?? BitmapDescriptor.defaultMarker,
      );
    });
  }

  updateTripDetailsInfo(LatLng driverPositionLatlng) async {
    if (driverPositionLatlng == null || tripEndLatLng == null) return;
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${driverPositionLatlng.latitude},${driverPositionLatlng.longitude}&destination=${tripEndLatLng!.latitude},${tripEndLatLng!.longitude}&key=$mapKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['routes'].isNotEmpty) {
        final leg = data['routes'][0]['legs'][0];
        final duration = leg['duration']['text'];

        setState(() {
          durationText = duration;
        });
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: tripStartLatLng ?? const LatLng(0, 0),
                zoom: 14,
              ),
              markers: {
                if (tripStartLatLng != null)
                  Marker(
                    markerId: const MarkerId('start'),
                    position: tripStartLatLng!,
                    icon: customMarkerIcon ??
                        BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                  ),
                if (tripEndLatLng != null)
                  Marker(
                    markerId: const MarkerId('end'),
                    position: tripEndLatLng!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
                if (driverMarker != null) driverMarker!,
              },
              polylines: {
                if (routePoints != null)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: routePoints!,
                    color: Colors.blue,
                    width: 5,
                  ),
              },
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
            ),
          ),
          _buildTripInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildTripInfoPanel() {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text(
            durationText,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.tripDetails.riderName!,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.tripDetails.pickupAddress!,
            style: GoogleFonts.montserrat(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            widget.tripDetails.destinationAdddress!,
            style: GoogleFonts.montserrat(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _onButtonPressed,
            child: Text(
              buttonText,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed() {
    if (startOfTrip == 'accepted') {
      setState(() {
        buttonText = "START TRIP";
        buttonColor = Colors.green;
        startOfTrip = 'arrived';
      });
      FirebaseDatabase.instance
          .ref()
          .child('tripRequest')
          .child(widget.tripDetails.tripID!)
          .child('status')
          .set('arrived');
    } else if (startOfTrip == 'arrived') {
      setState(() {
        buttonText = "END TRIP";
        buttonColor = Colors.red;
        startOfTrip = 'onTrip';
      });
      FirebaseDatabase.instance
          .ref()
          .child('tripRequest')
          .child(widget.tripDetails.tripID!)
          .child('status')
          .set('onTrip');
    } else if (startOfTrip == 'onTrip') {
      FirebaseDatabase.instance
          .ref()
          .child('tripRequest')
          .child(widget.tripDetails.tripID!)
          .child('status')
          .set('ended');
      _positionStreamSubscription?.cancel();
      Navigator.pop(context);
    }
  }
}
