import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Themes/Theme.dart';

class ViewComplaint extends StatefulWidget {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String isResolved;
  late final String? resolvedBy;
  late final String? resolution;
  late final String timeDaysAgo;

  ViewComplaint(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.resolvedBy,
      required this.isResolved,
      required this.resolution,
      required this.timeDaysAgo});
  @override
  _ViewComplaintState createState() => _ViewComplaintState(
      subject: subject,
      category: category,
      complaint: complaint,
      resolvedBy: resolvedBy,
      isResolved: isResolved,
      resolution: resolution,
      timeDaysAgo: timeDaysAgo);
}

class _ViewComplaintState extends State<ViewComplaint> {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String isResolved;
  late final String? resolvedBy;
  late final String? resolution;
  late final String timeDaysAgo;

  _ViewComplaintState(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.resolvedBy,
      required this.isResolved,
      required this.resolution,
      required this.timeDaysAgo});
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
                padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: Text(subject,
                    style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: black)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child:
                    Text(category, style: Theme.of(context).textTheme.caption),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: Text("Submitted $timeDaysAgo",
                    style: Theme.of(context).textTheme.caption),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: (isResolved == "Unresolved")
                    ? Text("Unresolved",
                        style: Theme.of(context).textTheme.caption)
                    : (isResolved == "Resolved")
                        ? Text("Resolved by $resolvedBy",
                            style: Theme.of(context).textTheme.caption)
                        : (isResolved == "Pending")
                            ? Text("Pending",
                                style: Theme.of(context).textTheme.caption)
                            : null,
              ),
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
                                    .copyWith(fontWeight: FontWeight.bold),
                                color: primary_color)),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                        child: Text("$complaint",
                            style: GoogleFonts.roboto(
                              textStyle: Theme.of(context).textTheme.bodyText1,
                            )),
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
                                  style: GoogleFonts.roboto(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                      color: primary_color)),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                              child: Text("$resolution",
                                  style: GoogleFonts.roboto(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                            )
                          ],
                        )
                      : null),
            ],
          ),
        ));
  }
}
