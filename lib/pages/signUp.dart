import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/validators.dart';


class SignUp extends StatefulWidget {
  final Function switchScreen ;

  SignUp({required this.switchScreen, Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // member variables
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "" , password = "", confirmPassword = "";
  String message = "";

  // Form validation Function
  void validate() async {
    if (_formKey.currentState!.validate()) {
      message =
      await Authentication().signUpWithEmailAndPassword(email, password, name);
      if (message != "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: <Widget>[
              Icon(
                Icons.error,
                color: Colors.white,
                semanticLabel: "Error",
              ),
              Text(' $message')
            ])));
        message = "";
      }
    }
  }
  // methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                validator: (val) => emailValidator(val!, false),
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (val) => emailValidator(val!, false),
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
                validator: (val) => passwordValidator(val!),
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Confirm password",
                ),
                obscureText: true,
                onChanged: (val) {
                  setState(() => confirmPassword = val);
                },
                validator: (val) => confirmPasswordValidator(password,val),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => validate(),
                  child: Text('Sign Up',
                    style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headline5)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 0,
                    width: 75,
                  ),
                  Text(
                    "Already have an account?",
                    style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                  TextButton(
                    onPressed: () => widget.switchScreen(),
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
