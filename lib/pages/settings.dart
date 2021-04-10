import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/backend/validators.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/models/profile.dart';
import 'package:lums_student_portal/pages/profile.dart';

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
                Navigator.pushNamed(context,"/updateAccount");
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



class UpdateAccount extends StatefulWidget {
  @override
  _UpdateAccountState createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final _formKey = GlobalKey<FormState>();
  String emailRoleUpdate = '' ;
  String emailToMakeChair = '';
  ProfileModel profileObject = ProfileModel(email: "", name: "", role: "");
  String? category ;
  String? role ;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // update chair - error handling left
  void updateChair() async {
    bool noerror = true;
    String progress = "Please select category";
    if (_formKey.currentState!.validate() && category!= null) {
      try {
        QuerySnapshot newChair = await db.collection("Profiles").where("email", isEqualTo: emailRoleUpdate).get();
        String idOfNewChair = "";
        if (newChair.docs.length == 0){
          progress = "Email does not exist!";
        }
        else{
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
            color: Colors.white,
            semanticLabel: "Error",
          ),
          Text('  $progress')
        ])));
  }
  void updateRole() async {
    String progress = "Please select Role";
    if (_formKey.currentState!.validate() && role != null) {
      try {
        QuerySnapshot newChair = await db.collection("Profiles").where("email", isEqualTo: emailRoleUpdate).get();
        if (newChair.docs.length == 0){
          progress = "Email does not exist!";
        }
        else{
          String idOfRoleToUpdate = newChair.docs[0].id ;
          DocumentReference profileDocRef = db.collection("Profiles").doc(idOfRoleToUpdate);
          await profileDocRef.update({"role":role});
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
            color: Colors.white,
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
        backgroundColor: Colors.white,
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
                  decoration: InputDecoration(hintText: "Select role"),
                  value: role,
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (newVal) {
                    setState(() {
                      role = newVal.toString();
                    });
                  },
                  items: profileObject.roles.map<DropdownMenuItem<String>>((value) {
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
                  decoration: InputDecoration(hintText: "Select Category"),
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
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                  SizedBox(
                    // Confirm Button
                    height: 40,
                    child: ElevatedButton(
                      // onPressed: () => validate(),
                      onPressed: () => updateChair(),
                      child: Text('Update Chair',
                          style: Theme.of(context).textTheme.headline5),
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





