import 'package:flutter/material.dart';

String? emailValidator(String email, bool signUp) {
  bool ending = email.endsWith("@lums.edu.pk");
  if (email.isNotEmpty) {
    if (signUp && !ending) {
      return "Sorry! This app is only for the LUMS community";
    } else {
      return null;
    }
  }
  return "Email can not be empty.";
}

String? passwordValidator(String password) {
  if (password.isEmpty) {
    return "Password can not be empty.";
  }
  return null;
}

String? confirmPasswordValidator(String password1, password2) {
  if (password2.isEmpty) {
    return "Field can not be empty.";
  } else if (password1 != password2) {
    return "Passwords do not match!";
  }
  return null;
}

String? headingValidator(String heading) {
  if (heading.isEmpty) {
    return "Heading can not be empty.";
  } else if (heading.length > 30) {
    return "Heading cannot exceed 30 characters.";
  }
  return null;
}

String? postValidator(String post) {
  if (post.isEmpty) {
    return "Field can not be empty.";
  }
  return null;
}

String? complaintValidator(String complaint) {
  if (complaint.isEmpty) {
    return "Field can not be empty.";
  }
  return null;
}

String? dropDownValidator(Object? choice) {
  if (choice == null) {
    return "Please choose an option";
  } else if (choice.toString().isEmpty) {
    return "Please choose an option";
  } else {
    return null;
  }
}

String? emptyNullValidator(String? str) {
  if (str == null) {
    return "Field can not be empty";
  } else if (str.isEmpty) {
    return "Field can not be empty.";
  }
  return null;
}

String? subjectValidator(String subject) {
  if (subject.isEmpty) {
    return "Subject can not be empty.";
  } else if (subject.length > 30) {
    return "Subject cannot exceed 30 characters.";
  }
  return null;
}
