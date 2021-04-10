import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen

class OfficeHoursModel {
  late BuildContext context;
  List<DocumentSnapshot?> snapshots = [];
  List<List<Widget>> tiles = [
    [], // For Monday
    [], // For Tuesday
    [], // For Wednesday
    [], // For Thurs
    [], // For Fri
  ];

  // Constructor:
  OfficeHoursModel(List<DocumentSnapshot?> snapshots, BuildContext context) {
    this.snapshots = snapshots;
    this.context = context;

    snapshots.forEach((thisSCmember) {
      List<int> daysIndices = [];
      try {
        if (thisSCmember!['office_hours']['days'] == 'Mondays and Wednesdays')
          daysIndices = [0, 2];
        else if (thisSCmember!['office_hours']['days'] ==
            'Tuesdays and Thursdays')
          daysIndices = [1, 3];
        else if (thisSCmember!['office_hours']['days'] ==
            'Wednesdays and Fridays') daysIndices = [2, 4];

        for (final day in daysIndices) {
          tiles[day].add(Card(
            child: ListTile(
              leading: thisSCmember!["picture"] != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(thisSCmember!["picture"]),
                      backgroundColor: Colors.grey,
                      radius: 30,
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage("assets/default-avatar.png"),
                      backgroundColor: Colors.grey,
                      radius: 30,
                    ),
              title: Text(thisSCmember["name"]),
              subtitle: Text(thisSCmember!['office_hours']['time']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Profile(
                        who: (thisSCmember!.id)); // function returns a widget
                  }),
                );
              },
            ),
          ));
        }
      } catch (e) {}
    });
  }

  List<String> daysOfTheWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];
}
