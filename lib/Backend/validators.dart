import 'package:flutter/material.dart';

String? emailValidator(String email, bool signUp) {
  bool ending = email.endsWith("@lums.edu.pk");
  if (email.isNotEmpty) {
    if (signUp && !ending) {
      return "Sorry! This app is only for the Lums community";
    } else {
      return null;
    }
  }
  return "Field can not be empty!";
}

String? passwordValidator(String password) {
  if (password.isEmpty) {
    return "Field can not be empty!";
  }
  return null;
}

String? confirmPasswordValidator(String password1, password2) {
  if (password2.isEmpty) {
    return "Field can not be empty!";
  } else if (password1 != password2) {
    return "The passwords do not match!";
  }
  return null;
}

String? headingValidator(String heading) {
  if (heading.isEmpty) {
    return "Field can not be empty!";
  } else if (heading.length > 30) {
    return "Please choose a shorter heading!";
  }
  return null;
}

String? postValidator(String post) {
  if (post.isEmpty) {
    return "Field can not be empty!";
  }
  return null;
}

  if (complaint.isEmpty) {
    return "Field can not be empty!";
  }
  return null;
}
String? dropDownValidator(Object? choice){
     return "Please choose an option";
   }
   else if(choice.toString().isEmpty){
     return "Please choose an option";
   }
   else{
     return null;
   }
}


