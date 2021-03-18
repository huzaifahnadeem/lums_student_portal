import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';



class Login extends StatefulWidget {

  final Function switchScreen ;
  Login({this.switchScreen, Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // member variables
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  // member functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Center(
              child: Text('Login')
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
                  await Authentication().loginWithEmailAndPassword(email, password);
                },
                child: Text('Submit'),
              ),
              TextButton(
                onPressed: () => widget.switchScreen(),
                child: Text('Sign Up'),
              ),

            ]
        ),
      ),
    );
  }
}
