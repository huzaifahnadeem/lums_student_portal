import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/validators.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/models/profile.dart';

/*class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'About', // header
            style: GoogleFonts.robotoSlab(
                textStyle: Theme.of(context).textTheme.headline6),
          ),
        ),
        // ZUHA ADD ABOUT TEXT HERE
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                  child: Text(
                      "\nCS 360 Project: LUMS Student Portal\n\nBy: Group 04\n\nFor: LUMS Student Council\n\n App Version: v0.1.0",
                  style: Theme.of(context).textTheme.bodyText2,)),
            ],
          ),
        ));
  }
}*/

class EditProfileArgs {
  final bool sc;
  final String uID = FirebaseAuth.instance.currentUser!.uid;
  EditProfileArgs({required this.sc});
}

class AppSettings extends StatelessWidget {
  // TODO: adjust theme as per screens e.g. app bar color. Listtile text font etc
  late final String role;
  AppSettings({required this.role});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings', // TODO: looks off as compared to other screens (newsfeed etc) because it's centered and due to its font size/typeface. Need to discuss with others
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: grey),
              title: Text('Change password', style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText1)),
              onTap: () {
                Navigator.pushNamed(context, "/changePassword");
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: grey),
              title: Text('Edit profile', style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText1)),
              onTap: () {
                Navigator.pushNamed(context,"/editProfile", arguments: EditProfileArgs(sc: true) );
              },
            ),
            (role == 'IT')? ListTile(
              leading: Icon(Icons.update, color: grey),
              title: Text('Update Role', style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText1)),
              onTap: () {
                Navigator.pushNamed(context,"/updateAccount");
              },
            ): Container(),
            (role == 'IT')?
              ListTile(
                leading: Icon(Icons.how_to_vote, color: grey),
                title: Text('Initiate election process', style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.bodyText1)),
                onTap: () {
                  FirebaseFirestore.instance.collection("Election").doc("events").update({"happening":true});
                },
              ):Container(),
            if ((role == 'IT'))
              ListTile(
                leading: Icon(Icons.cancel_outlined, color: grey),
                title: Text('End election process', style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.bodyText1)),
                onTap: () {
                  FirebaseFirestore.instance.collection("Election").doc("events").update({"happening":false});
                },
              ),
            AboutListTile(
              icon: Icon(Icons.info_outlined, color: grey),
              child: Text("About", style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText1)
              ),
              applicationIcon: CircleAvatar(
                backgroundImage: (AssetImage("assets/sclogo.png")),
                backgroundColor: secondary_color,
                radius: 30,
              ),
              applicationVersion: "v1.0.0",
              applicationLegalese: "@ Lums Student Council",
              aboutBoxChildren: [SizedBox(height: 20,),Text("Made by Group 04 in CS 360",style: Theme.of(context).textTheme.bodyText1,)],

            )
            /*ListTile(
              leading: Icon(Icons.info_outlined, color: grey),
              title: Text('About', style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText1)),
              onTap: ()  {
                showAboutDialog(
                  context: context,
                  applicationName: "Lums Student Portal",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "This application is owned by the Lums Student Council\n",
                  applicationIcon: CircleAvatar(
                    backgroundImage: AssetImage("assets/sclogo.png"),
                    backgroundColor: Colors.grey,
                    radius: 10,
                  ),
                  children: [Text("Made by Group 04 in CS 360",style: Theme.of(context).textTheme.bodyText1,)]
                );
                //Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
              },
            ),*/,
            ListTile(
              leading: Icon(Icons.logout, color: grey),
              title: Text('Log out', style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText1)),
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

class UpdateAccount extends StatefulWidget {
  @override
  _UpdateAccountState createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final _formKey = GlobalKey<FormState>();
  String emailRoleUpdate = '';
  String emailToMakeChair = '';
  ProfileModel profileObject = ProfileModel(email: "", name: "", role: "");
  String? category;
  String? role;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // update chair - error handling left
  void updateChair() async {
    bool noerror = true;
    String progress = "Please select category";
    if (_formKey.currentState!.validate() && category != null) {
      try {
        QuerySnapshot newChair = await db
            .collection("Profiles")
            .where("email", isEqualTo: emailRoleUpdate)
            .get();
        String idOfNewChair = "";
        if (newChair.docs.length == 0) {
          progress = "Email does not exist!";
        } else {
          idOfNewChair = newChair.docs[0].id;
          DocumentReference chairDocRef = db.collection("Chairs").doc(category);
          await chairDocRef.update({"uid": idOfNewChair});
          progress = "Chair Updated";
        }
      } on Exception catch (e) {
        progress = "Update Failed!";
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: <Widget>[
      Icon(
        Icons.notification_important,
        color: secondary_color,
        semanticLabel: "Error",
      ),
      Text('  $progress')
    ])));
  }

  void updateRole() async {
    String progress = "Please select Role";
    if (_formKey.currentState!.validate() && role != null) {
      try {
        QuerySnapshot newChair = await db
            .collection("Profiles")
            .where("email", isEqualTo: emailRoleUpdate)
            .get();
        if (newChair.docs.length == 0) {
          progress = "Email does not exist!";
        } else {
          String idOfRoleToUpdate = newChair.docs[0].id;
          DocumentReference profileDocRef =
              db.collection("Profiles").doc(idOfRoleToUpdate);
          await profileDocRef.update({"role": role});
          progress = "Role Updated";
        }
      } on Exception catch (e) {
        progress = "Update Failed! The email may not exist";
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: <Widget>[
      Icon(
        Icons.notification_important,
        color: secondary_color,
        semanticLabel: "Error",
      ),
      Text('  $progress')
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Role', // header
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Form(
        key: _formKey,
        // TODO: Backend part not done
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Username (email)"),
                validator: (val) => headingValidator(val!),
                onChanged: (val) {
                  setState(() => emailRoleUpdate = val);
                },
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButtonFormField<String>(
                  validator: (val) => dropDownValidator(val),
                  decoration: InputDecoration(labelText: "Select role"),
                  value: role,
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (newVal) {
                    setState(() {
                      role = newVal.toString();
                    });
                  },
                  items: profileObject.roles
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButtonFormField<String>(
                  validator: (val) => dropDownValidator(val),
                  decoration: InputDecoration(labelText: "Select Category"),
                  value: category,
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (newVal) {
                    setState(() {
                      category = newVal.toString();
                    });
                  },
                  items: Post.categories.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    // Confirm Button
                    height: 40,
                    child: ElevatedButton(
                      // onPressed: () => validate(),
                      onPressed: () => updateRole(),
                      child: Text('Update Role',
                          style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 17)),
                    ),
                  ),
                  SizedBox(
                    // Confirm Button
                    height: 40,
                    child: ElevatedButton(
                      // onPressed: () => validate(),
                      onPressed: () => updateChair(),
                      child: Text('Update Chair',
                          style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 17)),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
