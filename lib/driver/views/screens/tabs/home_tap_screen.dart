import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wahid_uber_app/driver/pus_notifications/push_notification.dart';
<<<<<<< HEAD
import 'package:wahid_uber_app/global_variables.dart'; // Ensure this import includes your global variables
=======
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

class HomeTapScreen extends StatefulWidget {
  const HomeTapScreen({super.key});

  @override
  State<HomeTapScreen> createState() => _HomeTapScreenState();
}

class _HomeTapScreenState extends State<HomeTapScreen> {
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? controllerGoogleMap;
<<<<<<< HEAD
=======
  Position? currentPosition;
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
  List<Color> colorTheme = [
    const Color(0xFF102DE1),
    const Color(0xCC0D6EFF),
  ];
  String title = 'GO ONLINE';
  bool isDriverAvailable = false;
  DatabaseReference? newTripRequestRef;
<<<<<<< HEAD

  _getCurrentLocation() async {
    try {
      Position positionofUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);

      currentPosition = positionofUser;
      driverPosition = currentPosition; // Use the global driverPosition

      LatLng positionofUserLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: positionofUserLatLng, zoom: 15);
=======
  _getCurrentLocation() async {
    try {
      Position positionofUSer = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentPosition = positionofUSer;
      LatLng positionofUSerLatlng =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: positionofUSerLatlng, zoom: 15);
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

      if (controllerGoogleMap != null) {
        controllerGoogleMap!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      }
    } catch (e) {
      // Handle the exception (e.g., show an error message)
      print("Error fetching location: $e");
    }
<<<<<<< HEAD
  }

  goOnlineNow() {
    // All online drivers
    Geofire.initialize('onlineDrivers');
    Geofire.setLocation(FirebaseAuth.instance.currentUser!.uid,
        currentPosition.latitude, currentPosition.longitude);

    newTripRequestRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('newTripStatus');
    newTripRequestRef!.set('waiting');
    newTripRequestRef!.onValue.listen((event) {});
  }

  setAndGetLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if (isDriverAvailable) {
        Geofire.setLocation(FirebaseAuth.instance.currentUser!.uid,
            currentPosition.latitude, currentPosition.longitude);
      }

      LatLng positionLatLng = LatLng(position.latitude, position.longitude);

      controllerGoogleMap!
          .animateCamera(CameraUpdate.newLatLng(positionLatLng));
    });
  }

  goOffline() {
    // Stop sharing live location updates
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
    newTripRequestRef?.onDisconnect();
    newTripRequestRef?.remove();
    newTripRequestRef = null;
  }

  initializePushNotification() {
    PushNotification pushNotification = PushNotification();
    pushNotification.generateToken();
    pushNotification.startListeningLocation(context);
  }

  @override
  void initState() {
    initializePushNotification();
    super.initState();
  }

=======
  }

  goOnlineNow() {
    //all online drivers

    Geofire.initialize('onlineDrivers');
    Geofire.setLocation(FirebaseAuth.instance.currentUser!.uid,
        currentPosition!.latitude, currentPosition!.longitude);

    newTripRequestRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('newTripStatus');
    newTripRequestRef!.set('waiting');
    newTripRequestRef!.onValue.listen((event) {});
  }

  setAndgetLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(FirebaseAuth.instance.currentUser!.uid,
            currentPosition!.latitude, currentPosition!.longitude);
      }

      LatLng positionLatlng = LatLng(position.latitude, position.longitude);

      controllerGoogleMap!
          .animateCamera(CameraUpdate.newLatLng(positionLatlng));
    });
  }

  goOfline() {
    //stop sharing live location updates
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
    newTripRequestRef!.onDisconnect();
    newTripRequestRef!.remove();
    newTripRequestRef = null;
  }

  initializePushNotification() async {
    PushNotification pushNotification = PushNotification();
    await pushNotification.generateToken();
    await pushNotification.startListeningLocation(context);
  }

  @override
  void initState() {
    initializePushNotification();
    super.initState();
  }

>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            padding: const EdgeInsets.only(top: 136),
            mapType: MapType.terrain,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              _googleMapController.complete(controllerGoogleMap);
              _getCurrentLocation();
            },
            initialCameraPosition: _kGooglePlex,
          ),

          // Go offline/online button
          Positioned(
            top: 61,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 319,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(colors: colorTheme),
                  ),
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          print('entering');
                          showModalBottomSheet(
                            isDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 230,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(0.7, 0.7),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 11,
                                      ),
                                      Text(
                                        (!isDriverAvailable)
                                            ? "GO ONLINE"
                                            : "GO OFFLINE",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 21,
                                      ),
                                      Text(
                                        (!isDriverAvailable)
<<<<<<< HEAD
                                            ? "You are about to go online , you will become available to receive trip requests from users."
                                            : "You are about to go offline , you will stop receiving trip requests from users.",
=======
                                            ? "You are about to go online , you will become avaialble to recive trip request from users"
                                            : "you are about to go offline , you will stop reciving trip request from users",
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          OutlinedButton(
<<<<<<< HEAD
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
=======
                                            onPressed: () {},
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                                            child: Text(
                                              'BACK',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (!isDriverAvailable) {
<<<<<<< HEAD
                                                // Go online
                                                goOnlineNow();
                                                setAndGetLocationUpdates();
=======
                                                //go online
                                                //get driver location updates
                                                goOnlineNow();
                                                setAndgetLocationUpdates();
                                                goOnlineNow();
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                                                Navigator.pop(context);
                                                setState(() {
                                                  colorTheme = [
                                                    Colors.purple,
                                                    const Color(0xFF102DE1),
                                                  ];
<<<<<<< HEAD
=======

>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                                                  title = 'GO OFFLINE';
                                                  isDriverAvailable = true;
                                                });
                                              } else {
<<<<<<< HEAD
                                                // Go offline
                                                goOffline();
                                                Navigator.pop(context);
                                                setState(() {
                                                  colorTheme = [
                                                    Colors.green,
                                                    const Color(0xFF102DE1),
                                                  ];
                                                  title = 'GO ONLINE';
                                                  isDriverAvailable = false;
                                                });
=======
                                                //go offline stop the driver location updates
                                                Navigator.pop(context);
                                                goOfline();
                                                setState(
                                                  () {
                                                    colorTheme = [
                                                      Colors.green,
                                                      const Color(0xFF102DE1),
                                                    ];

                                                    title = 'GO ONLINE';
                                                    isDriverAvailable = false;
                                                  },
                                                );
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: title == "GO ONLINE"
                                                    ? const Color(0xFF102DE1)
                                                    : Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'CONFIRM',
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Text(
                            title,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
<<<<<<< HEAD
                      // Positioned widgets should be inside the Stack directly
=======

                      // Positioned widgets should be inside the Stack directly

>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                      Positioned(
                        left: 278,
                        top: 19,
                        child: Opacity(
                          opacity: 0.5,
                          child: Container(
                            width: 60,
                            height: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 12,
                                color: const Color(0xFF103DE5),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 311,
                        top: 36,
                        child: Opacity(
                          opacity: 0.3,
                          child: Container(
                            width: 5,
                            height: 5,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 281,
                        top: -10,
<<<<<<< HEAD
                        child: Container(
                          width: 60,
                          height: 60,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset(
                            'assets/images/uber1.png',
=======
                        child: Opacity(
                          opacity: 0.3,
                          child: Container(
                            width: 20,
                            height: 20,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
          ),
=======
          )
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
        ],
      ),
    );
  }
}
