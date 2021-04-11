import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';

class ViewResolve extends StatefulWidget {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String name;
  late final String isResolved;
  late final String id;
  late final String? resolution;

  ViewResolve(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.name,
      required this.isResolved,
      required this.resolution,
      required this.id});

  @override
  _ViewResolveState createState() => _ViewResolveState(
      subject: subject,
      category: category,
      complaint: complaint,
      name: name,
      isResolved: isResolved,
      resolution: resolution,
      id: id);
}

class _ViewResolveState extends State<ViewResolve> {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String name;
  late final String isResolved;
  late final String id;
  late final String? resolution;
  late String? newResolution;
  String? email;
  String? resolvedBy;

  FirebaseFirestore _db = FirebaseFirestore.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  _ViewResolveState(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.name,
      required this.isResolved,
      required this.resolution,
      required this.id});

  void initState() {
    User? thisUser = FirebaseAuth.instance.currentUser;
    email = thisUser!.email;
    _db
        .collection("Profiles")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() => resolvedBy = result.get("name"));
      });
    });

    super.initState();
  }

  String? resolutionValidator(String res) {
    if (res.isEmpty) {
      return "Field can not be empty!";
    }
    return null;
  }

  void validateResolution() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await updateResolution();
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
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

  void validateResolved() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await markResolved();
      await updateResolution();
      await resolvedByUser();
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
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

  void validateUnresolved() async {
    setState(() {
      loading = true;
    });
    await markUnresolved();
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
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

  Future<void> resolvedByUser() {
    return _db
        .collection("Complaints")
        .doc(id)
        .update({"resolvedBy": resolvedBy})
        .then((value) => print("Resolution Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateResolution() {
    return _db
        .collection("Complaints")
        .doc(id)
        .update({"resolution": newResolution})
        .then((value) => print("Resolution Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> markResolved() {
    return _db
        .collection("Complaints")
        .doc(id)
        .update({"isResolved": "Resolved"})
        .then((value) => print("Resolution Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> markUnresolved() {
    return _db
        .collection("Complaints")
        .doc(id)
        .update({"isResolved": "Unresolved"})
        .then((value) => print("Resolution Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // titleTextStyle: ,
          title: Text('Status', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.check_circle_outline_rounded,
                        color: Colors.greenAccent),
                    title: Text('Mark as Resolved'),
                    onTap: () => {
                          validateResolved(),
                          Navigator.pop(context),
                        }),
                ListTile(
                    leading: new Icon(
                      Icons.highlight_remove_rounded,
                      color: Colors.redAccent,
                    ),
                    title: Text('Mark as Unresolved'),
                    onTap: () => {
                          validateUnresolved(),
                          Navigator.pop(context),
                        }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Colors.redAccent),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                // setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(
            color: Colors
                .redAccent, //Changing back button's color to black so that its visible.
          ),
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Text(
              "Resolve",
              style: GoogleFonts.robotoSlab(
                color: Colors.black87,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: false,
          elevation: 3,
        ),
        body: loading
            ? LoadingScreen()
            : SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Text(subject,
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
                      child: Text(category,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54)),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
                        child: Text("Submitted By: $name",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                color: Colors.black45))),
                    Container(
                      // decoration: BoxDecoration(),
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                      child: Text("$complaint",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                      child: (isResolved == "Pending")
                          ? Form(
                              key: _formKey,
                              child: Column(children: [
                                TextFormField(
                                  initialValue:
                                      resolution == null ? "" : resolution,
                                  decoration: InputDecoration(
                                      labelText: "Add Resolution",
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.black12,
                                          ))),
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  validator: (val) =>
                                      resolutionValidator(newResolution!),
                                  onChanged: (val) {
                                    setState(() => newResolution = val);
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            validateResolution();
                                          },
                                          child: Text('Update',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () => showMyDialog(),
                                          child: Text('Resolve',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]))
                          : null,
                    )
                  ],
                ),
              ));
  }
}
