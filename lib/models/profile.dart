import 'dart:io';

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
  List schools = ["SSE", "HSS", "SDSB", "SAHSOL", "EDU"];
  List years = ["Freshman", "Sophomore", "Junior", "Senior"];
  File? image;
  bool pictureChanged = false;
  Profile({required this.email, required this.name, required this.role});
  // delete picture
  Future deletePicture(String docID) async{
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref = _storage.refFromURL(pictureURL!);
      await ref.delete();
      DocumentReference profile = _db.collection('Profiles').doc(docID);
      pictureURL = null ;
      await profile.update({'picture': null});
      return "Profile picture deleted";
    }
    catch(err){
      return ("Error deleting profile picture");
    }
  }
  // update profile doc
  Future updateDb(String docID) async{
    bool pictureUploadSuccess = true;
    // if picture changed first update that
    if(pictureChanged){
      FirebaseStorage _storage = FirebaseStorage.instance ;
      try {
        var ref =  _storage.ref().child("profilePictures/${Path.basename(image!.path)}") ;
        await ref.putFile(image!).whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            pictureURL = value;
          });
        });
      } on Exception catch (e) {
        pictureUploadSuccess = false;
      }
    }
    CollectionReference profile = _db.collection('Profiles');
    if (pictureUploadSuccess) {
      try {
        await profile.doc(docID).set(
            toMap()
        );
        return "Profile updated!";
      }
      catch (err){
        return "Error during profile update!";
      }
    }
    else{ return "Error during picture update!";}
  }


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