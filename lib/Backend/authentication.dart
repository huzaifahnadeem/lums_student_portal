import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Authentication {
  // creating an instance of firebase
  FirebaseAuth _auth = FirebaseAuth.instance;
  // creating an instance of firestore
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // stream of asynchronous authentication updates i.e login, sign in, log out
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // check if the user has verified his/her Account
  Future<bool> checkVerification () async{
    User? temp = _auth.currentUser ;
    // to get latest updates
    await temp!.reload() ;
    if (temp.emailVerified){
      CollectionReference profiles = _db.collection('Profiles');
      await profiles.doc(temp.uid).set({
        'name': temp.displayName,
        'email': temp.email,
        'role': 'Student',
        'saved_posts' : null,
        'picture' : null,
        'office_hours': null,
        'manifesto': null,
      }) ;
      return true;
    }
    return false;
  }
  // changePassword
  Future<String> changePassword(String newPassword, String oldPassword) async{
    User? temp = _auth.currentUser ;
    EmailAuthCredential credential = EmailAuthProvider.credential(email: temp!.email!, password: oldPassword) as EmailAuthCredential;
    try {
      await temp.reauthenticateWithCredential(credential);
    } on Exception catch (e) {
      print(e);
      return  "Failed to re-authenticate";
    }
    try {
      await temp.updatePassword(newPassword);
      return "Password updated";
    } on FirebaseAuthException catch (e) {
      if(e.code == 'weak-password'){
        return e.message.toString();
      }
      return  "Updating process failed! please try later";
    }
  }
  // Sign up with email and password
  Future<String> signUpWithEmailAndPassword (String email, String password, String name) async {
    try {
      //  creating an account
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("Success") ;
      await _auth.currentUser!.sendEmailVerification();
      print("Verified") ;
      User? temp = _auth.currentUser ;
      temp!.updateProfile(displayName: name);
      return "";
    }
    on FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use'){
        return "Email already exists!";
      }
      if (e.code == 'weak-password'){
        return e.message.toString();
      }
      return "Error occurred, please try again";
    }
  }
  // login user
  Future loginWithEmailAndPassword (String email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(result);
      return "";
    }
    on FirebaseAuthException catch (err){
      print(err);
      if (err.code == "wrong-password"){
        return "Incorrect Password";
      }
      if (err.code == "invalid-email") {
        return "Invalid Email";
      }
      var code;
      if (err.code == "user-not-found") {
        return "Account Does Not Exist";
      }
      return "error" ;
    }
  }
  // Sign Out
  Future signOut () async {
    try{
      _auth.signOut();
    }
    catch (err){
      print (err);
    }
  }
// Reset Password
  Future<String> resetPassword (String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Reset Email Sent";
    }
    catch (err) {
      print(err);
      return "Error";
    }
  }

}