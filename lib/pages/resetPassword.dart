import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/validators.dart';

class ResetPassword extends StatefulWidget {
  final Function switchScreen;

  const ResetPassword({Key? key, required this.switchScreen}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String message = "";

  // Function to trigger firebase reset email
  void resetPassword() async {
    message = await Authentication().resetPassword(email);
    print(message);
    widget.switchScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => widget.switchScreen(),
          child: Text("Back",
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 16)),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(30, 10, 30, 30),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_open_sharp,
                size: 200,
                color: Colors.black87,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  "Forgot Your Password?",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(height: 10, width: 0),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  "Enter your email and we’ll send you a link to reset your "
                  "password. You will be redirected to the Login screen after this.",
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              SizedBox(height: 30, width: 0),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (val) => emailValidator(val!, false),
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => resetPassword(),
                  child: Text('Email Me',
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
