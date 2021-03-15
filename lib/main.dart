import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase's core functionality plugin
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase's cloud firestore (the DB) plugin

import 'package:lums_student_portal/pages/splashScreen.dart';
import 'package:lums_student_portal/pages/landingPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}


// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: splashScreen(0),
//       // routes: {
//       //   '/login_student': (context) => LoginStudent(),
//       // },
//     );
//   }
// }

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return splashScreen("Something Went Wrong");
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return splashScreen("Loading ...");
    }

    return appStarts();
  }

  Widget appStarts() {
    // made temporily
    CollectionReference colRef =
          FirebaseFirestore.instance.collection('Profiles');
      return FutureBuilder<DocumentSnapshot>(
        future: colRef.doc("Students").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return splashScreen("Something Went Wrong ...");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();

            return MaterialApp(
              title: 'Welcome to Flutter',
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Welcome to Flutter'),
                ),
                body: Center(child: Text("Dummy data from db: ${data['name']}")),
              ),
            );
          }

          return splashScreen("Loading ...");
        },
      );
  }
}