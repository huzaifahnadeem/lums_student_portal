import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      // ZUHA ADD ABOUT TEXT HERE
      body: Padding(padding: EdgeInsets.all(20), child: Column(
        children: [
          Flexible(child: Text( "TODO: About Sceen's styling etc.\n CS 360 Project: LUMS Student Portal\n By: Group 04\n For: LUMS Student Council\n App Version: v0.1.0")),
        ],),
      )
    );
  }
}

class EditProfileArgs {
  final bool sc ;
  final String uID = FirebaseAuth.instance.currentUser!.uid ;
  EditProfileArgs({required this.sc});
}

class AppSettings extends StatelessWidget {
  // TODO: adjust theme as per screens e.g. app bar color. Listtile text font etc
  late final String role;
  final bool showSC = true, showIT = true;
  AppSettings({required this.role});


  @override
  Widget build(BuildContext context) {
    /*if (role == "SC") {
      showSC = true;
      showIT = false;
    } else if (role == "IT") {
      showSC = true;
      showIT = true;
    } else {
      // role == "Student"
      showSC = false;
      showIT = false;
    }*/

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Settings', // TODO: looks off as compared to other screens (newsfeed etc) because it's centered and due to its font size/typeface. Need to discuss with others
          style: GoogleFonts.robotoSlab(
              color: Colors.black,
              textStyle: Theme.of(context).textTheme.headline6
              ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Change password'),
              onTap: () {
                Navigator.pushNamed(context, "/changePassword");
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit profile'),
              onTap: () {
                Navigator.pushNamed(context,"/editProfile", arguments: EditProfileArgs(sc: true) );
              },
            ),
            showIT? ListTile(
              leading: Icon(Icons.update),
              title: Text('Update Role'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return UpdateRole();
                  }),
                );
              },
            ): Container(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return About();
                  }),
                );
              },
            ),
            showIT?
              ListTile(
                leading: Icon(Icons.how_to_vote),
                title: Text('Initiate election process'),
                onTap: () {
                  FirebaseFirestore.instance.collection("Election").doc("events").update({"happening":true});
                },
              ):Container(),
            if (showIT)
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('End election process'),
                onTap: () {
                  FirebaseFirestore.instance.collection("Election").doc("events").update({"happening":false});
                },
              ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: () async {
                await Authentication().signOut();
                Navigator.pop(context);
                },
            )
          ]
        ).toList(),
      ),
    );
  }
}


class UpdateRole extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Update Role', // header
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        // TODO: Backend part not done
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              const Divider(
                height: 40,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Username"), //TODO: validation check
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration:
                    InputDecoration(labelText: "Role"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Category"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              SizedBox(
                // Confirm Button
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  // onPressed: () => validate(),
                  onPressed: () => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        semanticLabel: "Error",
                      ),
                      Text('TODO: Backend part not done')
                    ])))
                  },
                  child: Text('Confirm',
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}





