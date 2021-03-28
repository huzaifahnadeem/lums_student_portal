import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/backend/validators.dart';

class Login extends StatefulWidget {
  final Function switchScreen1;

  final Function switchScreen2;

  Login({required this.switchScreen1, required this.switchScreen2, Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // member variables
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String message = "";

  // Form validation Function
  void validate() async {
    print("login");
    if (_formKey.currentState!.validate()) {
      message =
          await Authentication().loginWithEmailAndPassword(email, password);
      print("login function called");
      if (message != "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.white,
            semanticLabel: "Error",
          ),
          Text('  $message')
        ])));
        message = '' ;
      }
    }
  }

  // member functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.fromLTRB(30,0,30,30),
            child: Column(children: <Widget>[
              SizedBox(
                  height: 250,
                  width: 300,
                  child: Image(
                    image: AssetImage("assets/sclogo.png"),
                    color: Theme.of(context).primaryColor,
                  )),
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
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => validate(),
                  child: Text('Log In',
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
              SizedBox(height: 10),
              Row(
                //crossAxisAlignment: CrossAxisAlignment,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                  TextButton(
                    onPressed: () => widget.switchScreen1(),
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              TextButton(
                onPressed: () => widget.switchScreen2(),
                child: Text(
                  'Forgot Your Password?',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
