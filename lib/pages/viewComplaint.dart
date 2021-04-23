import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewComplaint extends StatefulWidget {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String isResolved;
  late final String? resolvedBy;
  late final String? resolution;

  ViewComplaint(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.resolvedBy,
      required this.isResolved,
      required this.resolution});
  @override
  _ViewComplaintState createState() => _ViewComplaintState(
      subject: subject,
      category: category,
      complaint: complaint,
      resolvedBy: resolvedBy,
      isResolved: isResolved,
      resolution: resolution);
}

class _ViewComplaintState extends State<ViewComplaint> {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String isResolved;
  late final String? resolvedBy;
  late final String? resolution;

  _ViewComplaintState(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.resolvedBy,
      required this.isResolved,
      required this.resolution});
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
              "View",
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
        body: SingleChildScrollView(
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
                padding: EdgeInsets.fromLTRB(0, 5, 10, 20),
                child: (isResolved == "Unresolved")
                    ? Text("Unresolved",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45))
                    : (isResolved == "Resolved")
                        ? Text("Resolved by $resolvedBy",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                color: Colors.black45))
                        : (isResolved == "Pending")
                            ? Text("Pending",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45))
                            : null,
              ),
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
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.fromLTRB(0, 20, 5, 10),
                  child: (isResolved == "Resolved")
                      ? Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Resolution",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45)),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Text("$resolution",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black)),
                            )
                          ],
                        )
                      : null),
            ],
          ),
        ));
  }
}
