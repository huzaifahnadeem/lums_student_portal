import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lums_student_portal/Backend/validators.dart';

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

  void initState() {
    uid = thisUser!.uid;
    setState(() => newComplaint.senderUid = uid);
    _db.collection("Profiles").doc(uid).get().then((value) {
      setState(() => newComplaint.name = value.get("name"));
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

  // function to call when user pressed "Add Post" button
  void validate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await delegateTo();
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
          // titleTextStyle: ,
          title: Text('Confirmation', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to lodge this complaint?',
                    textAlign: TextAlign.center)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Colors.redAccent),
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                // setState(() {});
              },
            ),
            TextButton(
                style: TextButton.styleFrom(primary: Colors.redAccent),
                onPressed: () {
                  Navigator.of(context).pop();
                  validate();
                },
                child: Text('Yes'))
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
                minimum: EdgeInsets.fromLTRB(30, 50, 30, 30),
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            hintText: "Select Category",
                            fillColor: Colors.white),
                        validator: (val) => dropDownValidator(val),
                        isExpanded: false,
                        value: newComplaint.tag,
                        onChanged: (newVal) {
                          setState(() {
                            newComplaint.tag = newVal.toString();
                          });
                        },
                        items: Complaint.categories1.map((categoryItem) {
                          return DropdownMenuItem(
                            value: categoryItem,
                            child: Text(categoryItem),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    // heading input field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Add Subject",
                        fillColor: Colors.white,
                      ),
                      validator: (val) => subjectValidator(
                          newComplaint.subject), // check subjet lenght
                      onChanged: (val) {
                        setState(() => newComplaint.subject = val);
                      },
                    ),

                    SizedBox(height: 20),
                    // complaint input field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Write Complaint",
                        fillColor: Colors.white,
                      ),
                      maxLines: 9,
                      keyboardType: TextInputType.multiline,
                      validator: (val) =>
                          complaintValidator(newComplaint.complaint),
                      onChanged: (val) {
                        setState(() => newComplaint.complaint = val);
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => showMyDialog(),
                        child: Text('Lodge Complaint',
                            style: Theme.of(context).textTheme.headline5),
                      ),
                    ),
                  ]),
                ))));
  }
}
