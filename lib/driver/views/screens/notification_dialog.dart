import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wahid_uber_app/controllers/Places_controller.dart';
import 'package:wahid_uber_app/driver/models/trip_details.dart';
import 'package:wahid_uber_app/driver/views/screens/new_trip_screen.dart';
import 'package:wahid_uber_app/global_variables.dart';
import 'package:wahid_uber_app/services/handle_http_response.dart';

class NotificationDialog extends StatefulWidget {
  final TripDetails tripDetails;

  const NotificationDialog({super.key, required this.tripDetails});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  String tripRequestStatus = '';
  cancelNotificationDialog() {
    const oneTickPerSeconds = Duration(seconds: 1);
    var timerCountDown = Timer.periodic(oneTickPerSeconds, (timer) {
      requestTimeOut = requestTimeOut - 1;
      if (tripRequestStatus == 'accepted') {
        timer.cancel();
        requestTimeOut = 20;
      }
      if (requestTimeOut == 0) {
        Navigator.pop(context);
        timer.cancel();
        requestTimeOut = 20;
      }
    });
  }

  @override
  void initState() {
    cancelNotificationDialog();
    super.initState();
  }

  checkAvailabiltyofTripreuqest(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircleAvatar(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
    print('failed but my tripid is ${widget.tripDetails.tripID}');

    DatabaseReference driverTripStatusRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('newTripStatus');

    await driverTripStatusRef.once().then((snap) {
      Navigator.pop(context);
      Navigator.pop(context);
      String newTripStatusValue = '';
      if (snap.snapshot.value != null) {
        newTripStatusValue = snap.snapshot.value.toString();
        print('my tripid is ${widget.tripDetails.tripID}');
      } else {
        showSnackBar(context, 'Trip Request not found');
      }

      if (newTripStatusValue == widget.tripDetails.tripID) {
        print('in tripid is ${widget.tripDetails.tripID}');
        driverTripStatusRef.set('accepted');
        PlacesController.turnOffLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return NewTripScreen(
            tripDetails: widget.tripDetails,
          );
        }));
      } else if (newTripStatusValue == 'cancelled') {
        showSnackBar(context, 'Trip has been cancelled by user');
      } else if (newTripStatusValue == 'timeout') {
        showSnackBar(context, 'Trip request timed out');
      } else {
        showSnackBar(context, 'Trip removed');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black54,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Changed background color for better visibility
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Trip Request',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pickup Address: ${widget.tripDetails.pickupAddress}',
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Destination Address: ${widget.tripDetails.destinationAdddress}',
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Rider Name: ${widget.tripDetails.riderName}',
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: ${widget.tripDetails.phone}',
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Payment Method: ${widget.tripDetails.paymentMethod}',
              style: GoogleFonts.montserrat(color: Colors.black),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Cancel action
                    Navigator.of(context).pop(); // Close dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Accept action
                    // Add your logic here
                    setState(() {
                      tripRequestStatus = 'accepted';
                    });

                    checkAvailabiltyofTripreuqest(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Accept',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
