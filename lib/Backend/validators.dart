import 'dart:ffi';

import 'package:flutter/material.dart';


 String emailValidator(String email, bool signUp){
   bool ending = email.endsWith("@lums.edu.pk");
   if (email.isNotEmpty){
     if (signUp && !ending){
       return "Sorry! This app is only for the Lums community" ;
     }
     else{ return null ;}
   }
   return "Field can not be empty!" ;
}

String passwordValidator(String password){
  if (password.isEmpty){
    return "Field can not be empty!" ;

  }
  return null ;
}