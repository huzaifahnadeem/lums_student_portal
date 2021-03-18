import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("News Feed"),
          backgroundColor: Colors.redAccent,
        ),
        body: Center(
          child: RaisedButton(
            child: Text("Sign Out"),
            onPressed: () async {
              await Authentication().signOut();
            },
          ),
        )
    );
  }
}
