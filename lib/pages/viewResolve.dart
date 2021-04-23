import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lums_student_portal/Backend/validators.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';

class ViewResolve extends StatefulWidget {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String name;
  late final String isResolved;
  late final String id;
  late final String? resolvedByName;
  late final String? resolution;
  late final List delegatedMembers;
  late final List scMembers;
  late final String senderUid;

  ViewResolve(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.name,
      required this.isResolved,
      required this.resolution,
      required this.resolvedByName,
      required this.id,
      required this.delegatedMembers,
      required this.scMembers,
      required this.senderUid});

  @override
  _ViewResolveState createState() => _ViewResolveState(
      subject: subject,
      category: category,
      complaint: complaint,
      name: name,
      isResolved: isResolved,
      resolution: resolution,
      resolvedByName: resolvedByName,
      id: id,
      delegatedMembers: delegatedMembers,
      scMembers: scMembers,
      senderUid: senderUid);
}

class _ViewResolveState extends State<ViewResolve> {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String name;
  late final String isResolved;
  late final String id;
  late final String? resolvedByName;
  late final String? resolution;
  late String? newResolution;
  late final List delegatedMembers;
  late final List scMembers;
  late final String senderUid;
  String? uid;
  bool isChair = false;

  var dictionary = new Map();
  bool _toggled = false;

  late String? newDelegate = "";

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
      required this.resolvedByName,
      required this.resolution,
      required this.id,
      required this.delegatedMembers,
      required this.scMembers,
      required this.senderUid});

  void initState() {
    User? thisUser = FirebaseAuth.instance.currentUser;
    uid = thisUser!.uid;
    _db.collection("Chairs").where("uid", isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) {
        if (element.get("uid") == uid) {
          setState(() {
            isChair = true;
          });
        }
      });
    });
    newResolution = resolution;
    scMembers.remove(senderUid);
    scMembers.remove(uid);
    for (var i = 0; i < scMembers.length; i++) {
      _db.collection("Profiles").doc(scMembers[i]).get().then((value) {
        setState(() {
          dictionary[scMembers[i]] = value.get("name");
        });
      });
    }
    _db.collection("Profiles").doc(uid).get().then((value) {
      setState(() => resolvedBy = value.get("name"));
    });
    super.initState();
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

  Future<void> updateUnresolved() {
    return _db
        .collection("Complaints")
        .doc(id)
        .update({"resolution": null})
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

  Future<void> delegateToMember() {
    return _db
        .collection("Complaints")
        .doc(id)
        .update({"delegatedMembers": delegatedMembers})
        .then((value) => print("Resolution Updated"))
        .catchError((error) => print("Failed to update user: $error"));
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
        Text('  Resolution Updated')
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
        Text('  Resolved')
      ])));
    }
  }

  void validateUnresolved() async {
    setState(() {
      loading = true;
    });
    await markUnresolved();
    await updateUnresolved();
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
      Text('  Unresolved')
    ])));
  }

  void confirmDelegate() async {
    if (_formKey.currentState!.validate()) {
      delegatedMembers.add(newDelegate);
      setState(() {
        loading = true;
      });
      await delegateToMember();
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
        Text('  Delegation Successful')
      ])));
    }
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
                        color: Color(0xFF56BF54)),
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

  Future<void> delegateDialog() async {
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
                Text('Are you sure you want to delegate this complaint?',
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
                  confirmDelegate();
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
                                fontWeight: FontWeight.w600,
                                color: Colors.black54)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                        child: Text(category,
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                color: Colors.black45)),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                          child: Text("Submitted by $name",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45))),
                      (isResolved == "Resolved")
                          ? Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.fromLTRB(0, 5, 10, 10),
                              child: Text("Resolved by $resolvedByName",
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45)),
                            )
                          : Text(""),
                      Container(
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.fromLTRB(0, 20, 5, 10),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Complaint",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45)),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                child: Text("$complaint",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black)),
                              )
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                        child: (isResolved == "Pending" &&
                                senderUid == delegatedMembers.last &&
                                isChair)
                            ? Column(
                                children: [
                                  Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 20, 0, 20),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: DropdownButtonFormField(
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Delegate Complaint to",
                                                      fillColor: Colors.white),
                                                  validator: (val) =>
                                                      dropDownValidator(val),
                                                  isExpanded: false,
                                                  value: newDelegate!.isNotEmpty
                                                      ? newDelegate
                                                      : null,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      newDelegate =
                                                          newVal.toString();
                                                    });
                                                  },
                                                  items: dictionary.entries
                                                      .map((mapEntry) =>
                                                          DropdownMenuItem(
                                                            value: mapEntry.key,
                                                            child: Text(
                                                                mapEntry.value),
                                                          ))
                                                      .toList(),
                                                )),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 40, 0, 10),
                                            child: SizedBox(
                                              width: 150,
                                              height: 40,
                                              child: ElevatedButton(
                                                onPressed: () =>
                                                    delegateDialog(),
                                                child: Text('Delegate',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            : (isResolved == "Pending" &&
                                    isChair &&
                                    uid == delegatedMembers.last)
                                ? Column(
                                    children: [
                                      SwitchListTile(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 20, 0, 20),
                                          title: _toggled == false
                                              ? Text("Press to Delegate")
                                              : Text("Press to Resolve"),
                                          value: _toggled,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _toggled = value;
                                            });
                                          }),
                                      Container(
                                        child: (_toggled == false)
                                            ? Column(children: [
                                                Form(
                                                    key: _formKey,
                                                    child: Column(children: [
                                                      TextFormField(
                                                        initialValue:
                                                            resolution == null
                                                                ? ""
                                                                : newResolution,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Add Resolution Here...",
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                        maxLines: 5,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        validator: (val) =>
                                                            resolutionValidator(
                                                                newResolution!),
                                                        onChanged: (val) {
                                                          setState(() =>
                                                              newResolution =
                                                                  val);
                                                        },
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 30, 0, 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              width: 150,
                                                              height: 40,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  validateResolution();
                                                                },
                                                                child: Text(
                                                                    'Update',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline5),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 150,
                                                              height: 40,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () =>
                                                                    showMyDialog(),
                                                                child: Text(
                                                                    'Resolve',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ]))
                                              ])
                                            : Column(
                                                children: [
                                                  Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 20,
                                                                    0, 20),
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    DropdownButtonFormField(
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  decoration: InputDecoration(
                                                                      hintText:
                                                                          "Delegate Complaint to",
                                                                      fillColor:
                                                                          Colors
                                                                              .white),
                                                                  validator: (val) =>
                                                                      dropDownValidator(
                                                                          val),
                                                                  isExpanded:
                                                                      false,
                                                                  value: newDelegate!
                                                                          .isNotEmpty
                                                                      ? newDelegate
                                                                      : null,
                                                                  onChanged:
                                                                      (newVal) {
                                                                    setState(
                                                                        () {
                                                                      newDelegate =
                                                                          newVal
                                                                              .toString();
                                                                    });
                                                                  },
                                                                  items: dictionary
                                                                      .entries
                                                                      .map((mapEntry) =>
                                                                          DropdownMenuItem(
                                                                            value:
                                                                                mapEntry.key,
                                                                            child:
                                                                                Text(mapEntry.value),
                                                                          ))
                                                                      .toList(),
                                                                )),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 40,
                                                                    0, 10),
                                                            child: SizedBox(
                                                              width: 150,
                                                              height: 40,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () =>
                                                                    delegateDialog(),
                                                                child: Text(
                                                                    'Delegate',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline5),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                      )
                                    ],
                                  )
                                : (isResolved == "Pending" &&
                                        uid == delegatedMembers.last)
                                    ? Column(children: [
                                        Form(
                                            key: _formKey,
                                            child: Column(children: [
                                              TextFormField(
                                                initialValue: resolution == null
                                                    ? ""
                                                    : newResolution,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Add Resolution Here...",
                                                  fillColor: Colors.white,
                                                ),
                                                maxLines: 5,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                validator: (val) =>
                                                    resolutionValidator(
                                                        newResolution!),
                                                onChanged: (val) {
                                                  setState(() =>
                                                      newResolution = val);
                                                },
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 30, 0, 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          validateResolution();
                                                        },
                                                        child: Text('Update',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      height: 40,
                                                      child: ElevatedButton(
                                                        onPressed: () =>
                                                            showMyDialog(),
                                                        child: Text('Resolve',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]))
                                      ])
                                    : (isResolved == "Resolved")
                                        ? Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text("Resolution",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45)),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 15, 0, 0),
                                                child: Text("$resolution",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black)),
                                              )
                                            ],
                                          )
                                        : (isResolved == "Unresolved")
                                            ? Container(
                                                alignment: Alignment.topLeft,
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 10, 10),
                                                child: Text("Unresolved",
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black45)),
                                              )
                                            : Text(""),
                      ),
                    ]),
              ));
  }
}
