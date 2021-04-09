

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';


class Profile{
  late String email ;
  late String name ;
  late String role ;
  String? major ;
  String? manifesto ;
  String? pictureURL;
  String? hostel ;
  String? school;
  String? year;
  Map<String, dynamic>? officeHours ;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List roles = ["Student", "SC member", "IT"];
  List residenceTypes = ['Hostel', 'Day Scholar'];
  List schools = ["SSE", "HSS", "SDSB", "SAHSOL", "Edu"];
  List years = ["Freshman", "Sophomore", "Junior", "Senior"];
  Profile({required this.email, required this.name, required this.role});

  // update profile doc

  Map<String, dynamic> toMap() {
    return {
      "email": this.email,
      "name": this.name,
      "role": this.role,
      "major": this.major,
      "manifesto": this.manifesto,
      "picture": this.pictureURL,
      "hostel": this.hostel,
      "school": this.school,
      "year": this.year,
      "office_hours": this.officeHours
    };
  }
  void convertToObject(DocumentSnapshot doc){
    if (doc.exists){
      this.email = doc['email'];
      this.name = doc['name'];
      this.role = doc['role'];
      this.major = doc['major'];
      this.manifesto = doc['manifesto'];
      this.pictureURL = doc['picture'];
      this.hostel = doc['residence_status'];
      this.school = doc['school'];
      this.year = doc['year'];
      this.officeHours = doc['office_hours'];
    }
  }
}

class OfficeHours{
  String days = "" ;
  String time = "" ;
  OfficeHours(this.days, this.time);
  Map<String, dynamic> toMap() {
    return {
      "days": this.days,
      "time": this.time,
    };
  }
}