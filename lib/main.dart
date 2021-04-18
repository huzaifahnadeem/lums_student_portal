import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase's core functionality plugin
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication service
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/signUpOrLogin.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/pages/addPost.dart';
import 'package:lums_student_portal/pages/changePassword.dart';
import 'package:lums_student_portal/pages/editProfile.dart';
import 'package:lums_student_portal/pages/home.dart';
import 'package:lums_student_portal/pages/poll.dart';
import 'package:lums_student_portal/pages/settings.dart';
import 'package:lums_student_portal/pages/updatePost.dart';
import 'package:lums_student_portal/pages/verifyAccount.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: primary_color,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primary_color,
        textTheme: createTextTheme(),
        appBarTheme: createAppBarTheme(),
        inputDecorationTheme: createInputDecorTheme(),
        elevatedButtonTheme: createElevatedButtonTheme(),
        brightness: Brightness.light,
        snackBarTheme: createSnackBarTheme(),
        buttonTheme: createButtonTheme(),
        accentColor: primary_accent,
        iconTheme: createIconTheme(),

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
        else if (settings.name == '/changePassword') {
          return MaterialPageRoute(
            builder: (context) { return ChangePassword();},
          );
        }
        else if (settings.name == '/editProfile') {
          final EditProfileArgs args = settings.arguments as EditProfileArgs;
          return MaterialPageRoute(
            builder: (context) { return EditProfile(showSC: args.sc, userId: args.uID);},
          );
        }
        else if (settings.name == '/updateAccount') {
          return MaterialPageRoute(
            builder: (context) { return UpdateAccount();},
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
    return (!_initialized) ? LoadingScreen() : StreamBuilder<User?>(
      stream: _streamOfAuthChanges,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            print("Successful Authentication, Going to Home Screen");
            print(snapshot.data);
            if (snapshot.data!.emailVerified) {
              return Home();
            }
            else {
              return VerifyAccount();
            }
          }
          else{
            return SignUpOrLogin();
          }
        }
        else if (snapshot.hasError) {
          return Center(child: Text("Something went wrong! Please try later", style: Theme.of(context).textTheme.bodyText1,));
        }
        else{
          print(snapshot.connectionState);
          return LoadingScreen();
        }
      },

    );
  }
}
