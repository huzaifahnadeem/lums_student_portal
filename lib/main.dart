import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase's core functionality plugin
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication service
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/signUpOrLogin.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/pages/addPost.dart';
import 'package:lums_student_portal/pages/home.dart';
import 'package:lums_student_portal/pages/poll.dart';
import 'package:lums_student_portal/pages/updatePost.dart';
import 'package:lums_student_portal/pages/verifyAccount.dart';
import 'package:lums_student_portal/themes/Theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primary_color,
        textTheme: createTextTheme(),
        appBarTheme: createAppBarTheme(),
        inputDecorationTheme: createInputDecorTheme(),
        elevatedButtonTheme: createElevatedButtonTheme(),
        brightness: Brightness.light,
        snackBarTheme: createSnackBarTheme(),
        buttonTheme: createButtonTheme(),
        accentColor: Colors.red
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) { return LandingPage();},
          );
        }
        else if (settings.name == '/AddPost') {
          return MaterialPageRoute(
            builder: (context) { return AddPost();},
          );
        }
        else if (settings.name == '/UpdatePost') {
          final Post post = settings.arguments as Post;
          return MaterialPageRoute(
            builder: (context) { return UpdatePost(post: post);},
          );
        }
        else if (settings.name == '/poll') {
          final String id = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) { return Poll(id: id);},
          );
        }

      },
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  late bool _initialized ;
  late Stream<User?> _streamOfAuthChanges ;

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
    return (!_initialized) ? Scaffold(body: Center(child: CircularProgressIndicator())) : StreamBuilder<User?>( // splash screen called here
      stream: _streamOfAuthChanges,
      builder: (context, snapshot){
        if (snapshot.hasData){
          print("Successful Authentication, Going to Home Screen");
          print(snapshot.data) ;
          if (snapshot.data!.emailVerified) {
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
