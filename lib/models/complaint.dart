import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class Complaint {
  //initializations

  String subject;
  String complaint;
  String? tag;
  String? email;
  static List categories = [
    "General",
    "Disciplinary Committee",
    "Academic Policy",
    "Campus Development",
    "Others"
  ];
  static List categories1 = ["General", "DC", "Academic", "Campus", "Others"];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //class constructor
  Complaint(
      {required this.subject, required this.complaint, required this.email});

  // create json object to add to database
  Map<String, dynamic> toMap() {
    return {
      "category": this.tag,
      "subject": this.subject,
      "complaint": this.complaint,
      "email": this.email,
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
