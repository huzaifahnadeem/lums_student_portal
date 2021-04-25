import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/pages/profile.dart';
import 'package:intl/intl.dart';

class ViewComplaint extends StatefulWidget {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String isResolved;
  late final String? resolvedBy;
  late final String? resolution;
  late final String timeDaysAgo;
  late final Timestamp time;
  late final List delegatedMembers;

  ViewComplaint(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.resolvedBy,
      required this.isResolved,
      required this.resolution,
      required this.time,
      required this.delegatedMembers});
  @override
  _ViewComplaintState createState() => _ViewComplaintState(
      subject: subject,
      category: category,
      complaint: complaint,
      resolvedBy: resolvedBy,
      isResolved: isResolved,
      resolution: resolution,
      time: time,
      delegatedMembers: delegatedMembers);
}

class _ViewComplaintState extends State<ViewComplaint> {
  late final String subject;
  late final String category;
  late final String complaint;
  late final String isResolved;
  late final String? resolvedBy;
  late final String? resolution;
  late final Timestamp time;
  late final List delegatedMembers;

  late DateTime date;
  late String formatedDate;
  late String formatedTime;

  _ViewComplaintState(
      {required this.subject,
      required this.category,
      required this.complaint,
      required this.resolvedBy,
      required this.isResolved,
      required this.resolution,
      required this.time,
      required this.delegatedMembers});

  void initState() {
    date = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    formatedTime = DateFormat('HH:mm a').format(date);
    formatedDate = DateFormat.yMMMd().format(date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View",
              style: GoogleFonts.robotoSlab(textStyle:Theme.of(context).textTheme.headline6)
          ),
          elevation: 1,
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
                child: Text("Time: $formatedDate at $formatedTime",

                    // "Submitted on ${time.toDate().day}-${time.toDate().month}-${time.toDate().year} at ${time.toDate().hour}:${time.toDate().minute}",
                    style: Theme.of(context).textTheme.caption),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                child: (isResolved == "Unresolved")
                    ? Text("Unresolved",
                        style: Theme.of(context).textTheme.caption)
                    : (isResolved == "Resolved")
                        ? Row(
                            children: [
                              Text("Resolved by: ",
                                  style: Theme.of(context).textTheme.caption),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Profile(who: delegatedMembers.last);
                                  }));
                                },
                                child: Text(
                                  '$resolvedBy',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
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
                                    .bodyText1!
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
