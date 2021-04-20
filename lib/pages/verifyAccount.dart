import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Themes/Theme.dart';

class VerifyAccount extends StatefulWidget {

  @override
  _VerifyAccountState createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  String error = "";

  Future<void> redirectToHome() async{
    var verified = await Authentication().checkVerification();
    if (verified){
      Authentication().signOut();
    }
    else{
      setState(() {
        error = "We still have not received confirmation" ;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(children: <Widget>[
              Icon(
                Icons.error,
                color: secondary_color,
                semanticLabel: "Error",
              ),
              Text('   $error')
            ])));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(30,30,30,30),
        child: Container(
          padding: EdgeInsets.all(2),
          child: Column(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 100,
                color: grey,
              ),
              SizedBox(height: 10, width: 0),
              Flexible(
                child: Text(
                  "Please Verify Your Account",
                  style: GoogleFonts.robotoSlab(textStyle: Theme.of(context).textTheme.headline6),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15, width: 0),
              Flexible(
                child: Text(
                  "We have emailed you a link for your account verification."
                      " Please press the button below once you are done and "
                      "you will be redirected to the login page.",
                  style: GoogleFonts.roboto(textStyle: Theme.of(context).textTheme.caption),
                  //textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30, width: 0),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => redirectToHome(),
                  child: Text('Done',
                      style: GoogleFonts.roboto(textStyle: Theme.of(context).textTheme.headline5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
