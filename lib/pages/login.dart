import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatefulWidget {

  final Function switchScreen1 ;
  final Function switchScreen2 ;
  Login({this.switchScreen1, this.switchScreen2, Key key}): super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // member variables
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String message = "" ;

  // member functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In', style: GoogleFonts.robotoSlab(textStyle: Theme.of(context).textTheme.headline1),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(20),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spac,
                children: <Widget> [
                  SizedBox(height : 200, width: 200, child: Image(image: AssetImage("assets/sclogo.png"))),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Email"
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height:25),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Password",
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height:25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:() async {
                        await Authentication().loginWithEmailAndPassword(email, password);
                      },
                      child: Text('Submit', style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget> [
                      SizedBox(
                        height:0,
                        width: 85,
                      ),
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                      TextButton(
                        onPressed:() => widget.switchScreen1(),
                        child: Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).primaryColor, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    onPressed:() => widget.switchScreen2(),
                    child: Text(
                      'Forgot Your Password?',
                      style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
