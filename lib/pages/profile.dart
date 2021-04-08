import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';

// TODO: I think we should add an update profile button at the end that links to the settings -> update profile page

class Profile extends StatefulWidget {
  late final String who;
  Profile({required this.who});

  @override
  _ProfileState createState() => _ProfileState(who: who);
}

class _ProfileState extends State<Profile> {
  late final String who;
  _ProfileState({required this.who});

  // member variables
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late final User? thisUser = FirebaseAuth.instance.currentUser;
  late Stream<DocumentSnapshot?> _streamOfProfileData;

  String name = "none";
  String rollno = "none";
  String year = "none";
  String dept = "none";
  String residenceStatus = "none";
  String schoolMajor = "none";
  String officeHours = "none";
  String manifesto = "none";
  String pictureURL = "default";
  String role = "Student";

  void initState() {
    who == "self"
        ? _streamOfProfileData =
            _db.collection("Profiles").doc(thisUser!.uid).snapshots()
        : _streamOfProfileData =
            _db.collection("Profiles").doc(who).snapshots();
    super.initState();
  }

  Widget ProfileBody() {
    final double circleRadius = 80;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6
              ),
        ),
        backgroundColor: Color(0xFFEA5757), // Theme.of(context).primaryColor = Color(0xFFEA5757)
        actions: <Widget>[
          if (who == "self")
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AppSettings(role: role);
                  }),
                );
              },
            )
        ],
      ),
      body: ListView(
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
                            child: pictureURL == "default"
                                ? CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/default-avatar.png"),
                                    backgroundColor: Colors.grey,
                                    radius: circleRadius,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(pictureURL),
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
                  if (year != "none")
                    Text(
                      year,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (dept != "none")
                    Text(
                      dept,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (residenceStatus != "none")
                    Text(
                      residenceStatus,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (schoolMajor != "none")
                    Text(
                      schoolMajor,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (officeHours != "none") SizedBox(height: 15.0),
                  if (officeHours != "none")
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
                  SizedBox(height: 15.0),
                  if (manifesto != "none")
                    Text(
                      "Manifesto:\n" + manifesto,
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot?>(
        stream: _streamOfProfileData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An Error Occured"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            name = snapshot.data!["name"];

            role = snapshot.data!["role"];

            rollno = snapshot.data!["email"];
            rollno = rollno.substring(0, 8); // extracting roll no from email

            try {
              year = snapshot.data!["year"];
            } catch (e) {}

            try {
              dept = snapshot.data!["dept"];
            } catch (e) {}

            try {
              residenceStatus = snapshot.data!["residence_status"];
            } catch (e) {}

            try {
              schoolMajor = snapshot.data!["school"];
              schoolMajor = schoolMajor + ": " + snapshot.data!["major"];
            } catch (e) {}

            try {
              Map officeHoursMap = snapshot.data!["office_hours"];
              officeHours = officeHoursMap["day"]! + " " + officeHoursMap["time"]!;
            } catch (e) {}

            try {
              manifesto = snapshot.data!["manifesto"];
            } catch (e) {}

            try {
              pictureURL = snapshot.data!["picture"];
            } catch (e) {}

            return ProfileBody();
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
