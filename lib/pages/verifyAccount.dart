import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';

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
                color: Colors.white,
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
                size: 200,
                color: Colors.black87,
              ),
              SizedBox(height: 10, width: 0),
              Flexible(
                child: Text(
                  "Please Verify Your Account",
                  style: Theme.of(context).textTheme.headline6 ,
                ),
              ),
              SizedBox(height: 10, width: 0),
              Flexible(
                child: Text(
                  "We have emailed you a link for your account verification."
                      " Please press the button below once you have verified and "
                      "you will be redirected to the login page.",
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              SizedBox(height: 30, width: 0),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => redirectToHome(),
                  child: Text('Done',
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
