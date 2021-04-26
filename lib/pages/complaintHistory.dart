import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/pages/viewComplaint.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintHistory extends StatefulWidget {
  @override
  _ComplaintHistoryState createState() => _ComplaintHistoryState();
}

class _ComplaintHistoryState extends State<ComplaintHistory> {
  List<DocumentSnapshot?> documentSnaps = [];
  late Stream<QuerySnapshot?> _streamOfComplaintHistory;

  FirebaseFirestore _db = FirebaseFirestore.instance;
  String? uid;
  String timeDaysAgo = '';

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

  // setting initial state
  void initState() {
    User? thisUser = FirebaseAuth.instance.currentUser;
    uid = thisUser!.uid;
    _streamOfComplaintHistory = _db
        .collection("Complaints")
        .orderBy("time", descending: true)
        .snapshots();
    super.initState();
  }

  Widget complaintHistory() {
    return ListView.builder(
      itemCount: documentSnaps.length,
      itemBuilder: (BuildContext context, int index) {
        calcDaysAgo(documentSnaps[index]!["time"]);
        return (Container(
          child: documentSnaps[index]!["senderUid"] == uid
              ? Card(
                  semanticContainer: true,
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewComplaint(
                            subject: (documentSnaps[index]!["subject"]),
                            complaint: (documentSnaps[index]!["complaint"]),
                            category: (documentSnaps[index]!["category"]),
                            resolvedBy: (documentSnaps[index]!["resolvedBy"]),
                            isResolved: (documentSnaps[index]!["isResolved"]),
                            resolution: (documentSnaps[index]!["resolution"]),
                            time: (documentSnaps[index]!["time"]),
                            delegatedMembers:
                                (documentSnaps[index]!["delegatedMembers"]),
                          ); // function returns a widget
                        }));
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(documentSnaps[index]!["subject"],
                                  style: GoogleFonts.roboto(
                                    textStyle: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.normal),
                                  )),
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
                              subtitle: (documentSnaps[index]!["isResolved"] ==
                                      "Unresolved")
                                  ? Text(
                                      "Unresolved by ${documentSnaps[index]!["resolvedBy"]}",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  : (documentSnaps[index]!["isResolved"] ==
                                          "Resolved")
                                      ? Text(
                                          'Resolved by ${documentSnaps[index]!["resolvedBy"]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        )
                                      : (documentSnaps[index]!["isResolved"] ==
                                              "Pending")
                                          ? Text(
                                              'Pending',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            )
                                          : null,
                              trailing: (documentSnaps[index]!["isResolved"] ==
                                      "Pending")
                                  ? Icon(
                                      Icons.access_time_rounded,
                                      // Icons.highlight_remove_rounded
                                      color: yellow,
                                    )
                                  : (documentSnaps[index]!["isResolved"] ==
                                          "Resolved")
                                      ? Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: green,
                                        )
                                      : (documentSnaps[index]!["isResolved"] ==
                                              "Unresolved")
                                          ? Icon(
                                              Icons.highlight_remove_rounded,
                                              color: primary_lighter,
                                            )
                                          : null,
                            ),
                          ])))
              : null,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
        stream: _streamOfComplaintHistory,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An Error Occured"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(child: Text('No Complaints to Show.'));
            }
            documentSnaps = []; // reset list.
            snapshot.data!.docs.forEach((thisDocumentSnap) {
              documentSnaps.add(thisDocumentSnap);
            });
            return complaintHistory();
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
