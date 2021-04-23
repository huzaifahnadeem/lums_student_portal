import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Complaint {
  //initializations

  String subject;
  String complaint;
  String? tag;
  String? senderUid;
  String? isResolved = "Pending";
  String? name;
  String? resolution;
  String? resolvedBy;
  List delegatedMembers = [];

  static List categories1 = [
    "General",
    "Disciplinary Committee",
    "Academic",
    "Campus Development",
    "Mental Health",
    "Graduate Affairs",
    "HR-PR"
  ];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //class constructor
  Complaint(
      {required this.subject,
      required this.complaint,
      required this.senderUid});

  // create json object to add to database
  Map<String, dynamic> toMap() {
    return {
      "delegatedMembers": this.delegatedMembers,
      "resolvedBy": this.resolvedBy,
      "resolution": this.resolution,
      "name": this.name,
      "isResolved": this.isResolved,
      "category": this.tag,
      "subject": this.subject,
      "complaint": this.complaint,
      "senderUid": this.senderUid,
      "time": Timestamp.now()
    };
  }

  // add complaint the object to firebase
  Future addComplaintToDB() async {
    CollectionReference complaint = _db.collection('Complaints');
    try {
      await complaint.add(toMap());
      print("Complaint added to database");
    } catch (err) {
      print("An error occurred while adding complaint to the database");
    }
  }

  // delete complaint
  Future deleteComplaint(String complaintID) async {
    CollectionReference complaints = _db.collection('Complaints');
    try {
      await complaints.doc(complaintID).delete();
      return "Post Deleted";
    } catch (err) {
      print(err);
      return "Error Deleting Complaint";
    }
  }
}
