import 'package:flutter/material.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:lums_student_portal/pages/viewResolve.dart';
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

  // setting initial state
  void initState() {
    _streamOfComplaintResolve = _db.collection("Complaints").snapshots();
    super.initState();
  }

  Widget complaintResolve() {
    return ListView.builder(
      itemCount: documentSnaps.length,
      itemBuilder: (BuildContext context, int index) {
        return (Container(
          child: Card(
              semanticContainer: true,
              margin: EdgeInsets.all(10),
              elevation: 4,
              child: InkWell(
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewComplaint(
                        subject: (documentSnaps[index]!["subject"]),
                        complaint: (documentSnaps[index]!["complaint"]),
                        category: (documentSnaps[index]!["category"]),
                        resolvedBy: (documentSnaps[index]!["resolvedBy"]),
                        isResolved: (documentSnaps[index]!["isResolved"]),
                      ); // function returns a widget
                    }));
                  },
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
                        id: (documentSnaps[index]!.id),
                      ); // function returns a widget
                    }));
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(padding: EdgeInsets.all(10)),
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Text(
                              documentSnaps[index]!["subject"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            )),
                        ListTile(
                          title: Text(
                            documentSnaps[index]!["category"],
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            "Submitted By: ${documentSnaps[index]!["name"]}",
                            style: Theme.of(context).textTheme.caption,
                          ),
                          trailing:
                              (documentSnaps[index]!["isResolved"] == "Pending")
                                  ? Icon(
                                      Icons.access_time_rounded,
                                      // Icons.highlight_remove_rounded
                                      color: Colors.yellow,
                                    )
                                  : (documentSnaps[index]!["isResolved"] ==
                                          "Resolved")
                                      ? Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Colors.greenAccent,
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
