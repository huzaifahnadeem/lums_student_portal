import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:core';


class Post {
  String subject ;
  String content ;
  String? tag ;
  bool isPoll = false , pictureChosen = false, fileChosen = false;
  int numOptions = 0;
  String? pictureURL ;
  File? image, file ;
  String? filename ;
  String? fileURL ;
  List< Map<String,dynamic> > options = [] ;
  static List categories = ["General", "Disciplinary Committee", "Academic Policy", "Campus Development", "Others"];
  static List categories1 = ["General", "DC", "Academic", "Campus", "Others"] ;
  List chooseNumOptions = [0,1,2,3,4] ;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Constructor
  Post({required this.subject, required this.content});

  // create json object to add to database
  Map<String, dynamic> toMap() {
    return {
      "subject": this.subject,
      "content": this.content,
      "category": this.tag,
      "picture_chosen": this.pictureChosen,
      "file_chosen": this.fileChosen,
      "filename": this.filename,
      "poll": this.isPoll,
      "numOptions": this.numOptions,
      "picture_url": this.pictureURL,
      "file_url": this.fileURL,
      "options": this.options,
      "time": Timestamp.now()
    };
  }

  // add n number of options to options list
  void addOptions(){
    if (isPoll) {
      if(options.length > 0) {
        options.clear();
      }
      for (int i = 0 ; i<numOptions ; i++){
        Map<String,dynamic> temp = PollOption("", 0).toMap();
        options.insert(i, temp);
      }
    }
  }

  // upload picture
  Future uploadPicture() async{
    FirebaseStorage _storage = FirebaseStorage.instance;
      try {
      var ref =  _storage.ref().child("postImages/${Path.basename(image!.path)}") ;
      await ref.putFile(image!).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
            pictureURL = value ;
        });
      });
      print("Picture upload done");
    }
    catch (err){
        print("An error occurred while adding picture to the storage");
    }

  }
  // upload a file to firebase storage
  Future uploadFile() async{
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      var ref =  _storage.ref().child("postAttachments/${Path.basename(file!.path)}") ;
      await ref.putFile(file!).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          fileURL = value ;
        });
      });
      print("File upload done");
    }
    catch (err){
      print("An error occurred while adding file to the storage");
    }

  }

  // add the object to firebase
  Future addObjectToDb () async {
    if (pictureChosen) {
      await uploadPicture();
    }
    if (fileChosen) {
      await uploadFile();
    }
    CollectionReference posts = _db.collection('Posts');
    try {
      await posts.add(
          toMap()
      );
      print("Post added to database");
    }
    catch (err){
      print("An error occurred while adding post to the database");
    }
  }
  // delete image from storage
  Future deletePicture() async{
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref = _storage.refFromURL(pictureURL!);
      await ref.delete();
      print("Picture deleted");
    }
    catch(err){
      print("error deleting pictures");
    }
  }
  // delete file from storage
  Future deleteFile() async{
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref = _storage.refFromURL(fileURL!);
      await ref.delete();
      print("file deleted");
    }
    catch(err){
      print("error deleting file");
      print(err);
    }
  }
  // delete post
  Future deletePost(String postID) async {
    CollectionReference posts = _db.collection('Posts');
    try {
      if (pictureChosen){
        await deletePicture();
      }
      if(fileChosen){
        await deleteFile();
      }
      await posts.doc(postID).delete();
      return "Post Deleted";
    }
    catch (err){
      print(err);
      return "Error Deleting Post";
    }
  }

}

class PollOption {
  String option = "";
  int votes = 0 ;
  PollOption(this.option, this.votes);

  Map<String, dynamic> toMap() {
    return {
      "option": this.option,
      "votes": this.votes,
    };
  }
}
