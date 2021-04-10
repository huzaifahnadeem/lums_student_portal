import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primary_color = Color(0xFFEB5757);
const Color primary_accent = Color(0xFFC93D3D);
const Color secondary_color = Colors.white;
const Color secondary_accent = Color(0xFFE8E8E8); //Color(0xFFEFEAEA)
const Color text3 = Color(0xFFBDBDBD);
const Color text2 = Colors.white10;
const Color text1 = Colors.black;
const Color tertiary_color = Color(0xFF56BF54);






//App bar title
//App bar subtitle
//Post Subject
//Category
//Post/poll content
//Attachments
//Bottom bar labels
//Input field content
//Drop down
//Snackbar
//Settings menu tiles

ButtonThemeData createButtonTheme(){
  return ButtonThemeData(
    alignedDropdown: true,
  );
}

SnackBarThemeData createSnackBarTheme () {
  return SnackBarThemeData(
    backgroundColor: primary_accent,
  );
}

InputDecorationTheme createInputDecorTheme(){
  InputDecorationTheme initial = ThemeData.light().inputDecorationTheme ;
  return initial.copyWith(
    fillColor: secondary_color,
    filled: true,
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    ),
    labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondary_color, width: 0),
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    ),
    // errorBorder: OutlineInputBorder(
    //   borderSide: BorderSide(color: inputError, width: 2),
    //   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    // )
  );
}

TextTheme createTextTheme (){
  TextTheme initial = ThemeData.light().textTheme ;
  return initial.copyWith(
    // for App Bar Titles
    headline6: initial.headline6!.copyWith(
      color: Colors.black,
      fontSize: 40,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),
    // For Normal Text
    bodyText2: initial.bodyText2!.copyWith(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
    // For Buttons
    headline5: initial.headline5!.copyWith(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );
}

ElevatedButtonThemeData createElevatedButtonTheme(){
  ElevatedButtonThemeData initial = ThemeData().elevatedButtonTheme ;
  return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primary_color,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
        ),
        //elevation: 10,
      ),
  );
}


AppBarTheme createAppBarTheme () {
  return AppBarTheme(
    centerTitle: true,
    elevation: 0 ,
    iconTheme: IconThemeData(
      color: Colors.black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
  ),
  );
}

