import 'dart:io';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
=======
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wahid_uber_app/provider/app_data.dart';
<<<<<<< HEAD
import 'package:wahid_uber_app/views/screens/auth/login_screen.dart';
=======
import 'package:wahid_uber_app/provider/user_provider.dart';
import 'package:wahid_uber_app/views/screens/auth/register_screen.dart';
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.locationWhenInUse.isDenied.then((value) {
    if (value == true) {
      Permission.locationWhenInUse.request();
    }
  });
  await Permission.notification.isDenied.then((value) {
    if (value == true) {
      Permission.notification.request();
    }
  });
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyB_SdqRX8aYQ6LgUneHgQ4Nudw2EIIE-uc",
            appId: '1:107113386007:android:b6faa5a9aa0f3b41318c52',
            messagingSenderId: '107113386007',
            projectId: 'uber-app-439a2',
            storageBucket: "uber-app-439a2.appspot.com",
          ),
        )
      : await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) {
        return AppData();
      },
    ),
<<<<<<< HEAD
   
=======
    ChangeNotifierProvider(
      create: (_) {
        return UserProvider();
      },
    ),
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
<<<<<<< HEAD
      home: FirebaseAuth.instance.currentUser != null
          ?  DriverMainScreen()
          : const LoginScreen(),
=======
      home: 
           const RegisterScreen(),
>>>>>>> a3b5d309ba0e5bc1122c503e92ed1cde193ff3c1
    );
  }
}
