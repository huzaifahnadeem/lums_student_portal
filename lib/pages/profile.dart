import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/settings.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO: make variables such as avatar radius, text sizes, colors etc to make them easily changeable from one location

// Temp data:
String name =
    "Name Placeholder"; // TODO: for placeholder, maybe do that box placeholder animation thing such as the one in fb. screenshotted
final rollno = "22100079";
final year = "Junior";
final dept = "Campus Dev.";
final residenceStatus = "Hostel";
final schoolMajor = "SSE: CS";
final officeHours = "day and time";
final manifesto =
    "Note: Only Name is fetched from DB. Rest of the things are not fetched and placed yet or are placeholders .Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

// TODO: works OK but only name is fetched. Rest of the things are not fetched and placed yet or are placeholders
void fetchUserInfo() async {
  User? thisUser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  var document = await _db.collection('Profiles').doc(thisUser!.uid).get();
  name = document.data()!["name"];
}

class Profile extends StatelessWidget {
  bool showSettings =
      true; // false when using this page to display profiles of SC. True when visiting own profile

  @override
  Widget build(BuildContext context) {
    final double circleRadius = 80;
    fetchUserInfo();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile', // TODO: looks off as compared to other screens (newsfeed etc) because it's centered and due to its font size/typeface. Need to discuss with others
          style: GoogleFonts.robotoSlab(
            color: Colors.white,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFEA5757),
        actions: <Widget>[
          if (showSettings)
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
      body: ListView( // TODO: add If not null dept etc checks
        children: [
          Stack(
            children: <Widget>[
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
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black38,
                                spreadRadius: 5)
                          ],
                        ),
                        child: CircleAvatar(
                            radius:
                                circleRadius + 4, // the profile avatar border
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              // backgroundImage: NetworkImage(
                              //   "https://image.flaticon.com/icons/png/512/147/147144.png"
                              // ),
                              backgroundImage:
                                  AssetImage("assets/default-avatar.png"),
                              backgroundColor: Colors.grey,
                              radius: circleRadius,
                            )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        name,
                        style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
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
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rollno,
                    style: GoogleFonts.robotoSlab(
                      color: Color(0xFF808080),
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    year,
                    style: GoogleFonts.robotoSlab(
                      color: Color(0xFF808080),
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    dept,
                    style: GoogleFonts.robotoSlab(
                      color: Color(0xFF808080),
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    residenceStatus,
                    style: GoogleFonts.robotoSlab(
                      color: Color(0xFF808080),
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    schoolMajor,
                    style: GoogleFonts.robotoSlab(
                      color: Color(0xFF808080),
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox( height: 15.0 ),
                  Text(
                    "Office Hours: " + officeHours,
                    style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  // I think headings like this look nice but not using it currently to make it consistent with the figma screens
                  // Text(
                  //   "Manifesto:",
                  //   style: TextStyle(
                  //       color: Colors.redAccent,
                  //       fontStyle: FontStyle.normal,
                  //       fontSize: 28.0),
                  // ),
                  SizedBox( height: 15.0 ),
                  Text(
                    "Manifesto:",
                    style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    manifesto,
                    style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 18.0,
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
