import 'package:flutter/material.dart';
import 'package:lums_student_portal/pages/login.dart';
import 'package:lums_student_portal/pages/signUp.dart';



class SignUpOrLogin extends StatefulWidget {
  @override
  _SignUpOrLoginState createState() => _SignUpOrLoginState();
}


class _SignUpOrLoginState extends State<SignUpOrLogin> {
  // ignore: non_constant_identifier_names
  bool sign_up = false ;

  void toggleView(){
    setState(() {
      sign_up = !sign_up ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return sign_up ? SignUp(switchScreen: toggleView) : Login(switchScreen: toggleView) ;
  }

}
