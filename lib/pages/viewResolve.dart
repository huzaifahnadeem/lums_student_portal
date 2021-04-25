import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lums_student_portal/Backend/validators.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:lums_student_portal/pages/profile.dart';

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
  late final Timestamp time;

  ViewResolve({
    required this.subject,
    required this.category,
    required this.complaint,
    required this.name,
    required this.isResolved,
    required this.resolution,
    required this.resolvedByName,
    required this.id,
    required this.delegatedMembers,
    required this.scMembers,
    required this.senderUid,
    required this.time,
  });

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
      senderUid: senderUid,
      time: time);
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
  late final Timestamp time;

  String? uid;
  bool isChair = false;
  bool isCategoryChair = false;

  var dictionary = new Map();
  bool _toggled = false;

  late String? newDelegate = "";

  String? resolvedBy;

  late DateTime date;
  late String formatedDate;
  late String formatedTime;

  FirebaseFirestore _db = FirebaseFirestore.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  _ViewResolveState({
    required this.subject,
    required this.category,
    required this.complaint,
    required this.name,
    required this.isResolved,
    required this.resolvedByName,
    required this.resolution,
    required this.id,
    required this.delegatedMembers,
    required this.scMembers,
    required this.senderUid,
    required this.time,
  });

  void initState() {
    setState(() {
      loading = true;
    });
    date = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    formatedTime = DateFormat('HH:mm a').format(date);
    formatedDate = DateFormat.yMMMd().format(date);
    User? thisUser = FirebaseAuth.instance.currentUser;
    uid = thisUser!.uid;
    _db.collection("Chairs").doc(category).get().then((value) {
      if (value.get("uid") == uid) {
        setState(() {
          isCategoryChair = true;
        });
      }
    });
    _db.collection("Chairs").where("uid", isEqualTo: uid).get().then((value) {
      value.docs.forEach((element) {
        if (element.get("uid") == uid) {
          setState(() {
            isChair = true;
          });
        }
      });
      setState(() {
        loading = false;
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
    return loading
        ? LoadingScreen()
        : Scaffold(
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
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: Text(subject,
                                style: GoogleFonts.roboto(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    color: black)),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                            child: Text(category,
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                            child: Text(
                                "Submitted on $formatedDate at $formatedTime",
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                              child: Row(
                                children: [
                                  Text("Submitted by ",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Profile(who: senderUid);
                                      }));
                                    },
                                    child: Text(
                                      '$name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )),
                          (isResolved == "Resolved")
                              ? Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                                  child: Row(
                                    children: [
                                      Text("Resolved by ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Profile(
                                                who: delegatedMembers.last);
                                          }));
                                        },
                                        child: Text(
                                          '$resolvedByName',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.fromLTRB(0, 25, 5, 10),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Complaint",
                                        style: GoogleFonts.roboto(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            color: primary_color)),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                                    child: Text("$complaint",
                                        style: GoogleFonts.roboto(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        )),
                                  )
                                ],
                              )),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 10, 10),
                            child: (isResolved == "Pending" &&
                                    senderUid == delegatedMembers.last &&
                                    isCategoryChair)
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
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        DropdownButtonFormField(
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Delegate Complaint to",
                                                          fillColor:
                                                              Colors.white),
                                                      validator: (val) =>
                                                          dropDownValidator(
                                                              val),
                                                      isExpanded: false,
                                                      value: newDelegate!
                                                              .isNotEmpty
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
                                                                value: mapEntry
                                                                    .key,
                                                                child: Text(
                                                                    mapEntry
                                                                        .value),
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
                                              contentPadding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              title: _toggled == false
                                                  ? Text("Press to Delegate",
                                                      style: GoogleFonts.roboto(
                                                          textStyle: Theme.of(context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          color: primary_color))
                                                  : Text("Press to Resolve",
                                                      style: GoogleFonts.roboto(
                                                          textStyle: Theme.of(context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(fontWeight: FontWeight.bold),
                                                          color: primary_color)),
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
                                                        child:
                                                            Column(children: [
                                                          TextFormField(
                                                            initialValue:
                                                                resolution ==
                                                                        null
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
                                                                    newResolution ==
                                                                            null
                                                                        ? ""
                                                                        : newResolution!),
                                                            onChanged: (val) {
                                                              setState(() =>
                                                                  newResolution =
                                                                      val);
                                                            },
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 30,
                                                                    0, 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                SizedBox(
                                                                  width: 135,
                                                                  height: 40,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      validateResolution();
                                                                    },
                                                                    child: Text(
                                                                        'Update',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline5),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 135,
                                                                  height: 40,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed: () =>
                                                                        showMyDialog(),
                                                                    child: Text(
                                                                        'Resolve',
                                                                        style: Theme.of(context)
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
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            20,
                                                                            0,
                                                                            20),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
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
                                                                              Colors.white),
                                                                      validator:
                                                                          (val) =>
                                                                              dropDownValidator(val),
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
                                                                              newVal.toString();
                                                                        });
                                                                      },
                                                                      items: dictionary
                                                                          .entries
                                                                          .map((mapEntry) =>
                                                                              DropdownMenuItem(
                                                                                value: mapEntry.key,
                                                                                child: Text(mapEntry.value),
                                                                              ))
                                                                          .toList(),
                                                                    )),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            40,
                                                                            0,
                                                                            10),
                                                                child: SizedBox(
                                                                  width: 150,
                                                                  height: 40,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed: () =>
                                                                        delegateDialog(),
                                                                    child: Text(
                                                                        'Delegate',
                                                                        style: Theme.of(context)
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
                                                    initialValue:
                                                        resolution == null
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
                                                            newResolution ==
                                                                    null
                                                                ? ""
                                                                : newResolution!),
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          newResolution = val);
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
                                                          width: 135,
                                                          height: 40,
                                                          child: ElevatedButton(
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
                                                          width: 135,
                                                          height: 40,
                                                          child: ElevatedButton(
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
                                        : (isResolved == "Resolved")
                                            ? Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text("Resolution",
                                                        style: GoogleFonts.roboto(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText2!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                            color:
                                                                primary_color)),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 15, 0, 0),
                                                    child: Text("$resolution",
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        )),
                                                  )
                                                ],
                                              )
                                            : (isResolved == "Unresolved")
                                                ? Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 5, 10, 10),
                                                    child: Text("Unresolved",
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        )),
                                                  )
                                                : Container(),
                          ),
                        ]),
                  ));
  }
}
