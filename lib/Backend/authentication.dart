import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';



class Authentication {
  // creating an instance of firebase
  FirebaseAuth _auth = FirebaseAuth.instance;
  // stream of authentication updates
  Stream<User> get user {
    return _auth.authStateChanges();
  }



  Future<bool> checkVerification () async{
    User temp = _auth.currentUser ;
    await temp.reload() ;
    if (temp.emailVerified){
      return true;
    }
    return false;
  }
  // Sign up with email and password
  Future signUpWithEmailAndPassword (String email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("Success") ;
      await _auth.currentUser.sendEmailVerification();
      print("Verified") ;
    }
    catch (err){
      print(err);
    }
  }
  // login user
  Future loginWithEmailAndPassword (String email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Success");
      print(result);
    }
    catch (err){
      print(err) ;
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