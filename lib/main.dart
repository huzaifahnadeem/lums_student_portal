import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase's core functionality plugin
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase's cloud firestore (the DB) plugin
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication service
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/signUpOrLogin.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/pages/newsfeed.dart';
import 'package:lums_student_portal/pages/verifyAccount.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
        theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFFD04343),
        textTheme: createTextTheme(),
        appBarTheme: createAppBarTheme(),
        inputDecorationTheme: createInputDecorTheme(),
        elevatedButtonTheme: createElevatedButtonTheme(),
      )
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  bool _initialized ;
  Stream<User> _streamOfAuthChanges ;

  Future initializeFlutterFire() async {
    try{
      await Firebase.initializeApp();
      setState(() {
        _initialized = true ;
        _streamOfAuthChanges = Authentication().user ;
      });
    }
    catch (err){
      print(err);
    }
  }
  void initState()  {
    _initialized = false;
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (!_initialized) ? Text("Waiting for Initialisation") : StreamBuilder<User>( // splash screen called here
      stream: _streamOfAuthChanges,
      builder: (context, snapshot){
        if (snapshot.hasData){
          print("Successful Authentication, Going to Home Screen");
          print(snapshot.data) ;
          if (snapshot.data.emailVerified) {
            return Home();
          }
          else{
            return VerifyAccount();
          }
        }
        else {
          print ("Error During Authentication, Going to Authentication Section");
          print (snapshot.data);
          return SignUpOrLogin();
        }
      },

    );
  }
}
