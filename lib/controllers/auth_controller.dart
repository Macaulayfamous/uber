import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
<<<<<<< HEAD
=======
import 'package:wahid_uber_app/driver/views/screens/driver_main_screen.dart';
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
import 'package:wahid_uber_app/global_variables.dart';
import 'package:wahid_uber_app/views/screens/bottomNavigation_Screens/main_page.dart';
import 'package:wahid_uber_app/models/user.dart' as userModel;

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  // Sign up method for new users
  Future<void> signUpUsers({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
    String userType = 'normal', // Default user type
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Determine the correct collection based on the user type
      String collection = userType == 'driver' ? 'drivers' : 'users';

      // Reference the correct collection
      DatabaseReference userRef =
          _firebaseDatabase.ref().child('$collection/${credential.user!.uid}');

      Map<String, dynamic> userMap = {
        'id': credential.user!.uid,
        'fullName': fullName,
        'email': email,
        'phone': '', // Initialize as empty or handle separately
        'password': password,
<<<<<<< HEAD
        'userType': 'user', // Default userType set to 'user'
=======
        'token': '', // Initialize or handle token generation
        'userType': userType, // Store user type in the database
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
      };

      await userRef.set(userMap);

<<<<<<< HEAD
=======
      // Set global current user info
      userInfo = userModel.User.fromMap(userMap);

>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
      // Welcome message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🎉 Welcome aboard, $fullName! Your journey starts here!',
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.green,
        ),
<<<<<<< HEAD
      );

      // Navigate to the main page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
=======
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
      );

      // Navigate to the appropriate main page based on user type
      _navigateToMainPage(context, userType);
    } catch (e) {
      print("Sign-up error: $e");
<<<<<<< HEAD

      // Error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🚨 Oops! Something went wrong. Please try signing up again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Sign in method for existing users
  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Welcome back message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '👋 Welcome back! Let\'s get you where you need to go!',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.blue,
        ),
      );

      // Navigate to the main page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
    } catch (e) {
      print("Sign-in error: $e");

      // Error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🚨 Uh-oh! There was a problem signing you in. Please check your credentials and try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fetch current user info
  static Future<void> getCurrentUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser!.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/$userId');

      try {
        final DatabaseEvent event = await userRef.once();
        final DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              Map<String, dynamic>.from(snapshot.value as Map);
          userInfo = userModel.User.fromMap(userData);

          // Success message
          print('🌟 User data successfully retrieved: ${userInfo!.fullName}');
        } else {
          print('⚠️ No data available for this user.');
        }
      } catch (e) {
        print('❌ Error retrieving user data: $e');
      }
    } else {
      print('⚠️ No user is currently signed in.');
    }
  }

  // Method to switch a user to a driver
  Future<void> switchToDriver(BuildContext context) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      // Reference to the user in the users collection
      DatabaseReference userRef = _firebaseDatabase.ref().child('users/$userId');

      try {
        // Fetch user data from users collection
        final DatabaseEvent event = await userRef.once();
        final DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<String, dynamic> userData =
              Map<String, dynamic>.from(snapshot.value as Map);

          // Modify user type to driver
          userData['userType'] = 'driver';

          // Reference to the drivers collection
          DatabaseReference driverRef =
              _firebaseDatabase.ref().child('drivers/$userId');

          // Move user to drivers collection
          await driverRef.set(userData);

          // Remove user from users collection
          await userRef.remove();

          // Success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🚗 You are now a driver! Let\'s get you started!',
                style: TextStyle(fontSize: 16.0),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // No data available for the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ No user data found!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('❌ Error switching to driver: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Error switching to driver. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('⚠️ No user is currently signed in.');
=======

      // Error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🚨 Oops! Something went wrong. Please try signing up again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Determine the correct collection based on the user type
      DatabaseReference userRef =
          _firebaseDatabase.ref().child('users/${credential.user!.uid}');
      DataSnapshot snapshot = await userRef.get();

      if (!snapshot.exists) {
        // If not found in users, check the drivers collection
        userRef =
            _firebaseDatabase.ref().child('drivers/${credential.user!.uid}');
        snapshot = await userRef.get();
      }

      if (snapshot.exists && snapshot.value is Map) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        userInfo = userModel.User.fromMap(userData);
        String userType = userInfo!.userType;

        // Welcome back message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '👋 Welcome back! Let\'s get you where you need to go!',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 16.0),
            ),
            backgroundColor: Colors.blue,
          ),
        );

        // Navigate to the appropriate main page based on user type
        _navigateToMainPage(context, userType);
      } else {
        throw Exception("User data not found");
      }
    } catch (e) {
      print("Sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🚨 Uh-oh! There was a problem signing you in. Please check your credentials and try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> switchUserType(BuildContext context) async {
    String userId = _auth.currentUser!.uid;
    DatabaseReference oldRef;
    DatabaseReference newRef;

    // Determine the current collection based on the user type
    if (userInfo!.userType == 'normal') {
      oldRef = _firebaseDatabase.ref().child('users/$userId');
      newRef = _firebaseDatabase.ref().child('drivers/$userId');
    } else {
      oldRef = _firebaseDatabase.ref().child('drivers/$userId');
      newRef = _firebaseDatabase.ref().child('users/$userId');
    }

    // Toggle between 'normal' and 'driver'
    String newUserType = userInfo!.userType == 'normal' ? 'driver' : 'normal';

    try {
      // Update the userType in the old collection
      await oldRef.update({'userType': newUserType});

      // Move the user to the new collection
      await newRef.set(userInfo!.toMap()); // Move data to the new collection
      await oldRef.remove(); // Remove data from the old collection

      // Fetch the updated data from the new collection
      DataSnapshot snapshot = await newRef.get();
      if (snapshot.exists && snapshot.value is Map) {
        Map<String, dynamic> updatedUserData =
            Map<String, dynamic>.from(snapshot.value as Map);

        // Update the local userInfo object
        userInfo = userModel.User.fromMap(updatedUserData);

        // Display a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🚗 You are now in ${newUserType == 'driver' ? 'Driver' : 'User'} mode!',
              style: GoogleFonts.montserrat(fontSize: 16.0),
            ),
            backgroundColor: Colors.blue,
          ),
        );

        // Navigate to the appropriate main page
        _navigateToMainPage(context, newUserType);
      } else {
        throw Exception("User data not found after switch");
      }
    } catch (e) {
      print("Error switching user type: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🚨 Error switching user type. Please try again.',
            style: GoogleFonts.montserrat(fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToMainPage(BuildContext context, String userType) {
    if (userType == 'driver') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DriverMainScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false,
      );
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
    }
  }
}
