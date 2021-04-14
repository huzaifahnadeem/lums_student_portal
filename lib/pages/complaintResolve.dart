import 'package:flutter/material.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';
import 'package:lums_student_portal/pages/viewResolve.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lums_student_portal/pages/viewComplaint.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintResolve extends StatefulWidget {
  @override
  _ComplaintResolveState createState() => _ComplaintResolveState();
}

class _ComplaintResolveState extends State<ComplaintResolve> {
  List<DocumentSnapshot?> documentSnaps = [];
  late Stream<QuerySnapshot?> _streamOfComplaintResolve;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  User? thisUser = FirebaseAuth.instance.currentUser;
  String? senderName;
  String? email;
  List forwardList = [];
  String timeDaysAgo = '';

  // setting initial state
  void initState() {
    _streamOfComplaintResolve = _db
        .collection("Complaints")
        .orderBy("time", descending: true)
        .snapshots();
    _db
        .collection("Profiles")
        .where("email", isEqualTo: thisUser!.email)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() => senderName = result.id);
      });
    });
    _db.collection("Profiles").get().then((value) {
      value.docs.forEach((result) {
        if (result.get("role") == "SC" || result.get("role") == "IT") {
          forwardList.add(result.id);
        }
      });
    });
    super.initState();
  }

  Future<void> senderUid() async {}

  // calculate days ago
  void calcDaysAgo(Timestamp complaintTime) {
    int difference = (Timestamp.now().seconds - complaintTime.seconds);
    difference = (difference ~/ 86400);
    if (difference > 1) {
      timeDaysAgo = difference.toString() + " days ago";
    } else {
      timeDaysAgo = "today";
    }
  }

  Widget complaintResolve() {
    return ListView.builder(
      itemCount: documentSnaps.length,
      itemBuilder: (BuildContext context, int index) {
        calcDaysAgo(documentSnaps[index]!["time"]);
        return (Container(
          child: Card(
              semanticContainer: true,
              margin: EdgeInsets.all(10),
              elevation: 4,
              child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewResolve(
                        subject: (documentSnaps[index]!["subject"]),
                        complaint: (documentSnaps[index]!["complaint"]),
                        category: (documentSnaps[index]!["category"]),
                        name: (documentSnaps[index]!["name"]),
                        resolution: (documentSnaps[index]!["resolution"]),
                        isResolved: (documentSnaps[index]!["isResolved"]),
                        resolvedByName: (documentSnaps[index]!["resolvedBy"]),
                        id: (documentSnaps[index]!.id),
                        delegatedMembers:
                            (documentSnaps[index]!["delegatedMembers"]),
                        scMembers: forwardList,
                      ); // function returns a widget
                    }));
                  },
                  child: Column(children: [
                    ListTile(
                      dense: true,
                      title: Text(documentSnaps[index]!["subject"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      trailing: Text(
                        "$timeDaysAgo",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: Text(
                        documentSnaps[index]!["category"],
                        style: Theme.of(context).textTheme.caption,
                      ),
                      subtitle: Text(
                        "Submitted By: ${documentSnaps[index]!["name"]}",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      trailing: (documentSnaps[index]!["isResolved"] ==
                              "Pending")
                          ? Icon(
                              Icons.access_time_rounded,
                              // Icons.highlight_remove_rounded
                              color: Color(0xFFFFB800),
                            )
                          : (documentSnaps[index]!["isResolved"] == "Resolved")
                              ? Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Color(0xFF56BF54),
                                )
                              : (documentSnaps[index]!["isResolved"] ==
                                      "Unresolved")
                                  ? Icon(
                                      Icons.highlight_remove_rounded,
                                      color: Colors.redAccent,
                                    )
                                  : null,
                    ),
                  ]))),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
        stream: _streamOfComplaintResolve,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An Error Occured"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            documentSnaps = []; // reset list.
            snapshot.data!.docs.forEach((thisDocumentSnap) {
              documentSnaps.add(thisDocumentSnap);
            });
            return complaintResolve();
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
