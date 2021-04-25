import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/models/profile.dart';

class Profile extends StatefulWidget {
  late final String who;
  Profile({required this.who});

  @override
  _ProfileState createState() => _ProfileState(who: who);
}

class _ProfileState extends State<Profile> {
  late final String who;
  _ProfileState({required this.who,});

  // member variables
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late final User? thisUser = FirebaseAuth.instance.currentUser;
  late Stream<DocumentSnapshot?> _streamOfProfileData;
  late ProfileModel _profile;

  void initState() {
    who == "self"
        ? _streamOfProfileData =
            _db.collection("Profiles").doc(thisUser!.uid).snapshots()
        : _streamOfProfileData =
            _db.collection("Profiles").doc(who).snapshots();
    super.initState();
  }

  Widget profileBody(BuildContext context) {
    final double circleRadius = 80;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary_color,
        actions: <Widget>[
          // settings button
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
                    return AppSettings(role: _profile.role);
                  }),
                );
              },
            )
        ],
      ),
      body: ListView(
        children: [
          Stack(
            // Profile Picture + Name
            children: <Widget>[
              Container(
                color: Color(0xFFEA5757),
                height: 120.0,
              ),
              Container(
                  // Profile Picture
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
                                blurRadius: 5,
                                color: Colors.black38,
                                spreadRadius: 2)
                          ],
                        ),
                        child: CircleAvatar(
                            radius:
                                circleRadius + 4, // the profile avatar border
                            backgroundColor: Colors.white,
                            child: _profile.pictureURL == null
                                ? CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/default-avatar.png"),
                                    backgroundColor: Colors.grey,
                                    radius: circleRadius,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(_profile.pictureURL!),
                                    radius: circleRadius,
                                  )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        // Name
                        _profile.name,
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
                    _profile.email.substring(
                        0, 8), // using substring to extract roll no from email
                    style: GoogleFonts.robotoSlab(
                      color: Color(0xFF808080),
                      fontSize: 18.0,
                    ),
                  ),
                  if (_profile.year != null)
                    Text(
                      _profile.year!,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (_profile.hostel != null)
                    Text(
                      _profile.hostel!,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (_profile.school != null && _profile.major != null)
                    Text(
                      _profile.school! + ": " + _profile.major!,
                      style: GoogleFonts.robotoSlab(
                        color: Color(0xFF808080),
                        fontSize: 18.0,
                      ),
                    ),
                  if (_profile.officeHours != null) SizedBox(height: 15.0),
                  if (_profile.officeHours != null)
                    Text(
                      "Office Hours:\n" +
                          _profile.officeHours!['days'] +
                          " at " +
                          _profile.officeHours!['time'],
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
                  if (_profile.manifesto != null)
                    Text(
                      "Manifesto:\n" + _profile.manifesto!,
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
            _profile = ProfileModel(
                name: snapshot.data!["name"],
                role: snapshot.data!["role"],
                email: snapshot.data!["email"]);

            try {
              _profile.year = snapshot.data!["year"];
            } catch (e) {}

            try {
              _profile.hostel = snapshot.data!["residence_status"];
            } catch (e) {}

            try {
              _profile.school = snapshot.data!["school"];
              _profile.major = snapshot.data!["major"];
            } catch (e) {}

            try {
              _profile.officeHours = snapshot.data!["office_hours"];
            } catch (e) {}

            try {
              _profile.manifesto = snapshot.data!["manifesto"];
            } catch (e) {}

            try {
              _profile.pictureURL = snapshot.data!["picture"];
            } catch (e) {}

            return profileBody(context);
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
