import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/settings.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Temp data:
String name = "Huzaifah Nadeem";
final rollno = "22100079";
final year = "Junior";
final dept = "Campus Dev.";
final residenceStatus = "Homstel";
final schoolMajor = "SSE: CS";
final manifesto =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

// works OK but commented out temporarily to work on other things first:
// void fetchUserInfo() async { 
//   User? thisUser = FirebaseAuth.instance.currentUser;
//   FirebaseFirestore _db = FirebaseFirestore.instance;
//   var document = await _db.collection('Profiles').doc(thisUser!.uid).get();
//   name = document.data()!["name"];
// }

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double circleRadius = 75;
    // fetchUserInfo();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Color(0xFFEA5757),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AppSettings();
              }),
            );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: <Widget> [
              Container(
                color: Color(0xFFEA5757),
                height: 120.0,
              ),
              
              Container(
              child: Container(
                width: double.infinity,
                height: 250.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black38, spreadRadius: 5)],
                        ),
                        child: CircleAvatar(
                          radius: circleRadius+5,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                          // backgroundImage: NetworkImage(
                          //   "https://image.flaticon.com/icons/png/512/147/147144.png"
                          // ),
                          backgroundImage: AssetImage("assets/default-avatar.png"),
                          backgroundColor: Colors.grey,
                          radius: circleRadius,
                          )
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        name,
                        style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontSize: 22.0,
                          textStyle: Theme.of(context).textTheme.headline6),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              )),
            
            ],
          ),
          
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manifesto:",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontStyle: FontStyle.normal,
                        fontSize: 28.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    manifesto,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}