import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';

class ResetPassword extends StatefulWidget {
  final Function switchScreen ;

  const ResetPassword({Key key, this.switchScreen}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final _formKey = GlobalKey<FormState>();
  String email = "";
  String message = "" ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed:() => widget.switchScreen()) ,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed:() async {
                  message = await Authentication().resetPassword(email);
                  print(message);
                  widget.switchScreen();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
