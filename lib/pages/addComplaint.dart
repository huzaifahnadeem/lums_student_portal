import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lums_student_portal/Backend/validators.dart';

import 'package:lums_student_portal/models/complaint.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  Complaint newComplaint = Complaint(subject: '', complaint: '', email: '');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;
  String? email;

  void initState() {
    User? thisUser = FirebaseAuth.instance.currentUser;
    email = thisUser!.email;
    setState(() => newComplaint.email = email);
    _db
        .collection("Profiles")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() => newComplaint.name = result.get("name"));
      });
    });
    super.initState();
  }

  // function to call when user pressed "Add Post" button
  void validate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await newComplaint.addComplaintToDB();
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: <Widget>[
        Icon(
          Icons.done_all,
          color: Colors.white,
          semanticLabel: "Done",
        ),
        Text('Done')
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
                    Container(
                      width: double.infinity,
                      child: DropdownButton(
                        hint: Text("Category"),
                        isExpanded: true,
                        value: newComplaint.tag,
                        focusColor: Colors.red[400],
                        dropdownColor: Colors.red[400],
                        onChanged: (newVal) {
                          setState(() {
                            newComplaint.tag = newVal.toString();
                          });
                        },
                        items: Complaint.categories.map((categoryItem) {
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
                      validator: (val) => headingValidator(
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
                      maxLines: 10,
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
