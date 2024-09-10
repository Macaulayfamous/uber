import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wahid_uber_app/driver/models/trip_details.dart';
import 'package:wahid_uber_app/driver/views/screens/notification_dialog.dart';
=======
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

class PushNotification {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> generateToken() async {
    String? token = await firebaseMessaging.getToken();

    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('token');

    driverRef.set(token);

    firebaseMessaging.subscribeToTopic('drivers');
    firebaseMessaging.subscribeToTopic('users');
    return token;
  }

  startListeningLocation(BuildContext context) async {
    // Handle the case when the app was terminated and is opened by a notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? messageRemote) {
      String tripID = messageRemote!.data['tripID'];

      retriveTripRequestInfo(tripID, context);
    });

    // Handle the case when the app was foreground and is opened by a notification

    FirebaseMessaging.onMessage.listen((RemoteMessage? messageRemote) {
      String tripID = messageRemote!.data['tripID'];
      retriveTripRequestInfo(tripID, context);
    });
    // Handle the case when the app was background and is opened by a notification

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? messageRemote) {
      String tripID = messageRemote!.data['tripID'];
      retriveTripRequestInfo(tripID, context);
    });
  }

  retriveTripRequestInfo(String tripID, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircleAvatar(
<<<<<<< HEAD
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
=======
            child: CircularProgressIndicator(),
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
          ),
        );
      },
    );
    DatabaseReference tripRequestRef =
<<<<<<< HEAD
        FirebaseDatabase.instance.ref().child('tripRequest').child(tripID);
=======
        FirebaseDatabase.instance.ref().child('tripRequest');
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

    tripRequestRef.once().then((datasnapshot) {
      Navigator.pop(context);
      //play notification sound

<<<<<<< HEAD
      TripDetails tripDetailsInfo = TripDetails();

      double pickUpLat = double.parse(
          (datasnapshot.snapshot.value! as Map)['pickupLocation']['latitude']);
      double pickUpLng = double.parse(
          (datasnapshot.snapshot.value! as Map)['pickupLocation']['longitude']);

      tripDetailsInfo.pickup = LatLng(pickUpLat, pickUpLng);
      //destination
      double destinationLat = double.parse((datasnapshot.snapshot.value!
          as Map)['destinationLocation']['latitude']);
      double destinationLng = double.parse((datasnapshot.snapshot.value!
          as Map)['destinationLocation']['longitude']);

      tripDetailsInfo.destination = LatLng(destinationLat, destinationLng);

      //address

      tripDetailsInfo.pickupAddress =
          (datasnapshot.snapshot.value! as Map)['pickupAddress'];

      tripDetailsInfo.destinationAdddress =
          (datasnapshot.snapshot.value! as Map)['destinationAddress'];
      tripDetailsInfo.riderName =
          (datasnapshot.snapshot.value! as Map)['fullName'];

      tripDetailsInfo.tripID = tripID;

      showDialog(
          context: context,
          builder: (context) {
            return NotificationDialog(tripDetails: tripDetailsInfo);
          });
=======
      double.parse(
          (datasnapshot.snapshot.value! as Map)['pickupLocation']['latitude']);
      double.parse(
          (datasnapshot.snapshot.value! as Map)['pickupLocation']['longitude']);

      //destination
      double.parse((datasnapshot.snapshot.value! as Map)['destinationLocation']
          ['latitude']);
      double.parse((datasnapshot.snapshot.value! as Map)['destinationLocation']
          ['longitude']);

      //address

      (datasnapshot.snapshot.value! as Map)['pickupAddress'];

      (datasnapshot.snapshot.value! as Map)['destinationAddress'];
      (datasnapshot.snapshot.value! as Map)['fullName'];
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
    });
  }
}
