import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wahid_uber_app/models/user.dart' as userModel;

const String mapKey = "AIzaSyBbgLtZvsRAB5DcnPOoirbEi6n4hTsThZ4";
String uri = "http://192.168.90.217:3000";

User? currentUser;
userModel.User? userInfo;
UserCredential? currentDriverUser;
DatabaseReference? requestRef;
late Position currentPosition;
<<<<<<< HEAD
Position? driverPosition;

StreamSubscription<Position>? homeTapStream;



String driverFullName = '';
int driverTripRequesttemOut = 20;
=======

StreamSubscription<Position>? homeTapStream;

String driverFullName = '';

>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

String? driverPhoneNumber;
int requestTimeOut = 30;
String status = '';
String driverCarDetails = "";
String tripStatusDisplay = 'Driver is Arriving';
