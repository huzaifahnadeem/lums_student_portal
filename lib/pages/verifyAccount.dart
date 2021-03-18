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
      setState(() {error = "Unsuccessful" ;});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Verify Your Account")),
      ),
      body: Center(
        child: Column(
          children: [
            Text ("Click On The Verification Link Emailed to You"),
            RaisedButton(
              onPressed: () => redirectToHome()  ,
              padding: EdgeInsets.all(10),
              child: Text("Done"),
            ),
            SizedBox(height: 10),
            Text("$error")
          ],
        ),
      ),
    );
  }
}
