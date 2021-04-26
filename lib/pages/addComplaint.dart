import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/validators.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/models/complaint.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  Complaint newComplaint = Complaint(subject: '', complaint: '', senderUid: '');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  User? thisUser = FirebaseAuth.instance.currentUser;
  String? uid;
  bool loading = false;
  List updateList = [];
  List chairsList = [];

  void initState() {
    uid = thisUser!.uid;
    setState(() => newComplaint.senderUid = uid);
    _db.collection("Profiles").doc(uid).get().then((value) {
      setState(() => newComplaint.name = value.get("name"));
    });
    _db.collection("Chairs").get().then((value) {
      value.docs.forEach((result) {
        if (result.get("uid").toString() != "" && result.get("uid") != null) {
          chairsList.add(result.id);
        }
      });
    });
    super.initState();
  }

  Future<void> delegateTo() async {
    return _db.collection("Chairs").doc(newComplaint.tag).get().then((value) {
      updateList.add(value.get("uid"));
      setState(() {
        newComplaint.delegatedMembers = updateList;
      });
    });
  }

  Future<void> delagateToGenral() async {
    return _db.collection("Chairs").doc("General").get().then((value) {
      updateList.add(value.get("uid"));
      setState(() {
        newComplaint.delegatedMembers = updateList;
      });
    });
  }

  // function to call when user pressed "Add Post" button
  void validate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      if (chairsList.contains(newComplaint.tag)) {
        print("here");
        await delegateTo();
      } else {
        print("delagating to genral");
        await delagateToGenral();
      }
      await newComplaint.addComplaintToDB();
      setState(() {
        updateList.clear();
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: <Widget>[
        Icon(
          Icons.done_all,
          color: Colors.white,
          semanticLabel: "Done",
        ),
        Text('  Complaint Lodged')
      ])));
    }
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lodge Complaint?',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.bodyText2)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Once you submit, your complaint will be sent to the Student Council')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: primary_color),
              child: Text('Cancel', textAlign: TextAlign.left),
              onPressed: () {
                Navigator.of(context).pop();
                // setState(() {});
              },
            ),
            TextButton(
                style: TextButton.styleFrom(primary: black),
                onPressed: () {
                  Navigator.of(context).pop();
                  validate();
                },
                child: Text('Yes')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
            ? LoadingScreen()
            : SafeArea(
                minimum: EdgeInsets.fromLTRB(30, 30, 30, 30),
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "Select category",
                        ),
                        validator: (val) => dropDownValidator(val),
                        isExpanded: false,
                        value: newComplaint.tag,
                        onChanged: (newVal) {
                          setState(() {
                            newComplaint.tag = newVal.toString();
                          });
                        },
                        items: Post.categories.map((categoryItem) {
                          return DropdownMenuItem(
                            value: categoryItem,
                            child: Text(categoryItem),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),

                    // heading input field
                    TextFormField(
                      cursorColor: primary_color,
                      decoration: InputDecoration(
                        hintText: "Add subject...",
                        fillColor: Colors.white,
                      ),
                      validator: (val) => subjectValidator(
                          newComplaint.subject), // check subject length
                      onChanged: (val) {
                        setState(() => newComplaint.subject = val);
                      },
                    ),
                    // complaint input field
                    TextFormField(
                      cursorColor: primary_color,
                      decoration: InputDecoration(
                        hintText: "Write your complaint here...",
                        fillColor: Colors.white,
                      ),
                      maxLines: null,
                      validator: (val) =>
                          complaintValidator(newComplaint.complaint),
                      onChanged: (val) {
                        setState(() => newComplaint.complaint = val);
                      },
                    ),
                    SizedBox(height: 100),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => showMyDialog(),
                        child: Text('Submit',
                            style: Theme.of(context).textTheme.headline5),
                      ),
                    ),
                    SizedBox(height: 10),
                  ]),
                ))));
  }
}
