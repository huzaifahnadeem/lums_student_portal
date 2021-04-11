import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:core';


class Post {
  String? id ;
  String subject ;
  String content ;
  String? tag ;
  bool isPoll = false , pictureChosen = false, fileChosen = false;
  int numOptions = 0;
  List<dynamic> pictureURL = [] ;
  List<dynamic> images = [] ;
  File? image, file ;
  String? filename ;
  String? fileURL ;
  Timestamp? time;
  List? options ;
  List<dynamic> savedPosts = [];
  List<dynamic> alreadyVoted = [];
  static List categories = ["General", "Disciplinary Committee", "Academic", "Campus Development",
                            "Mental Health", "Graduate Affairs", "HR/PR", "Others"];
  static List categories1 = ["General", "DC", "Academic", "Camp Dev", "Health", "Graduates", "HR/PR", "Others"] ;
  List chooseNumOptions = [2,3,4] ;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Constructor
  Post({required this.subject, required this.content});

  // create json object to add to database
  Map<String, dynamic> toMap() {
    this.time = Timestamp.now();
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
      "time": this.time,
      "saved_posts": this.savedPosts,
      "already_voted": this.alreadyVoted
    };
  }

  void convertToObject(DocumentSnapshot doc) async{
    //print(doc['options']);
    this.subject = doc['subject'];
    this.content = doc['content'];
    this.tag = doc['category'];
    this.pictureChosen = doc['picture_chosen'];
    this.fileChosen = doc['file_chosen'];
    this.filename = doc['filename'];
    this.isPoll = doc['poll'];
    this.numOptions = doc['numOptions'];
    this.pictureURL = doc['picture_url'];
    this.fileURL = doc['file_url'];
    this.options = doc['options'];
    this.time = doc['time'] ;
    this.savedPosts = doc['saved_posts'];
    this.alreadyVoted = doc['already_voted'];
  }
  // add a single option
  void addOption(){
    if (isPoll) {
      if(options == null){
        options = [];
      }
      Map<String, dynamic> temp = PollOption("", 0).toMap();
      options!.insert(numOptions, temp);
      numOptions += 1 ;
    }
  }
  void removeOption(){
    print(numOptions);
    print(options);
    if (isPoll) {
      if(numOptions==2){
        return;
      }
      else{
        print("removing");
        options!.removeLast();
        numOptions -= 1;
      }
    }
  }
  // add n number of options to options list
  void addOptions(){
    if (isPoll) {
      if(options != null) {
        options!.clear();
      }
      options = [];
      for (int i = 0; i < numOptions; i++) {
        Map<String, dynamic> temp = PollOption("", 0).toMap();
        options!.insert(i, temp);
      }

    }
  }

  // upload picture
  Future uploadPicture() async{
    try {
      await Future.wait(images.map((image) async {
        FirebaseStorage _storage = FirebaseStorage.instance ;
        var ref =  _storage.ref().child("postImages/${Path.basename(image!.path)}") ;
        await ref.putFile(image!).whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            pictureURL.add(value) ;
          });
        });
      }));
      print("All pictures Uploaded");
      return true;
    } on Exception catch (e) {
      print("Error uploading one of the pictures");
      return false;
    }
  }
  // upload a file to firebase storage
  Future uploadFile() async{
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      var ref =  _storage.ref().child("postAttachments/${(Path.basename(file!.path)).replaceAll(" ", "").replaceAll("(", "")
      .replaceAll(")", "")}") ;
      await ref.putFile(file!).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          fileURL = value ;
        });
      });
      return true;
    }
    catch (err){
      return false;
    }

  }

  // add the object to firebase
  Future addObjectToDb () async {
    bool progress = true;
    if(progress){
      if (pictureChosen) {
        progress = await uploadPicture();
      }
    }
    if(progress){
      if (fileChosen) {
        progress = await uploadFile();
      }
    }
    else{
      return "Error during picture upload!" ;
    }
    CollectionReference posts = _db.collection('Posts');
    if (progress) {
      try {
        await posts.add(
            toMap()
        );
        print('post uploaded');
        return "Post Uploaded";
      }
      catch (err){
        return "Error during post upload!";
      }
    }
    else{
      if (pictureChosen){
        deletePicture();
      }
      return "Error during file Upload!" ;
    }
  }

  // update object to firebase
  Future updateObjectToDb (bool fileReset, bool pictureReset) async {
    bool progress = true;
    if(progress){
      if (pictureChosen && pictureReset) {
        progress = await uploadPicture();
      }
    }
    if(progress){
      if (fileChosen && fileReset) {
        progress = await uploadFile();
      }
    }
    else{
      return "Error during picture upload!" ;
    }
    CollectionReference posts = _db.collection('Posts');
    if (progress) {
      try {
        await posts.doc(id).set(
            toMap()
        );
        return "Post Updated";
      }
      catch (err){
        return "Error during post upload!";
      }
    }
    else{
      if (pictureChosen){
        deletePicture();
      }
      return "Error during file Upload!" ;
    }
  }
  // delete image from storage
  Future deletePicture() async{
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await Future.wait(pictureURL.map((url) async {
        FirebaseStorage _storage = FirebaseStorage.instance;
        Reference ref = _storage.refFromURL(url);
        await ref.delete();
      }));
      if(id != null){
        DocumentReference post = _db.collection('Posts').doc(id);
        post.update({'picture_url': [], 'picture_chosen': false});
      }
      print("All pictures deleted");
      return true;
    }
    catch(err){
      print("error deleting pictures");
      return false;
    }
  }
  // delete file from storage
  Future deleteFile() async{
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference ref = _storage.refFromURL(fileURL!);
      await ref.delete();
      if(id != null){
        DocumentReference post = _db.collection('Posts').doc(id);
        post.update({'file_url': null, 'file_chosen': false,  'filename': null});
      }
      print("file deleted");
      return true;
    }
    catch(err){
      print("error deleting file");
      return false;
    }
  }
  // delete post
  Future deletePost(String postID) async {
    CollectionReference posts = _db.collection('Posts');
    bool progress = true;
    try {
      if (pictureChosen && progress){
        progress = await deletePicture();
      }
      if(progress) {
        if (fileChosen) {
          progress = await deleteFile();
        }
      }
      else{ return "Error during picture deletions";}
      if(progress){
        await posts.doc(postID).delete();
        return "Post Deleted";
      }
      else{return "Error during file deletion";}
    }
    catch (err){
      print(err);
      return "Error Deleting Post";
    }
  }

  Future addSavedPosts(String postID, String userID) async{
    DocumentReference postref = _db.collection('Posts').doc(postID);
    if (this.savedPosts.contains(userID)){
      postref.update({'saved_posts': FieldValue.arrayRemove([userID])});
    }
    else{
      postref.update({'saved_posts': FieldValue.arrayUnion([userID])});
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
