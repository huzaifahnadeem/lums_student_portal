import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';


class SignUp extends StatefulWidget {
  final Function switchScreen ;

  SignUp({this.switchScreen, Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // member variables
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  // methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Center(
              child: Text('Sign Up')
          )
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget> [
              TextField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed:() async {
                  await Authentication().signUpWithEmailAndPassword(email, password);
                },
                child: Text('Submit'),
              ),
              TextButton(
                onPressed:() => widget.switchScreen(),
                child: Text('Login'),
              )
            ]
        ),
      ),
    );
  }
}
