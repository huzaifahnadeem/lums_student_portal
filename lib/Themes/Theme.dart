import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primary_color = Color(0xFFEB5757);
const Color primary_accent = Color(0xFFC93D3D);
const Color secondary_color = Colors.white;
const Color secondary_accent = Color(0xFFE8E8E8); //Color(0xFFEFEAEA)
const Color text3 = Color(0xFFBDBDBD);
const Color text2 = Color(0xFF666565);
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
IconThemeData createIconTheme(){
  return IconThemeData(
    color: Colors.grey,
  );
}
ButtonThemeData createButtonTheme() {
  return ButtonThemeData(
    alignedDropdown: true,
  );
}

SnackBarThemeData createSnackBarTheme() {
  return SnackBarThemeData(
    backgroundColor: primary_accent,
  );
}

InputDecorationTheme createInputDecorTheme() {
  InputDecorationTheme initial = ThemeData.light().inputDecorationTheme;
  return initial.copyWith(

      fillColor: secondary_color,
      filled: true,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: secondary_color, width: 0),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ));
}

TextTheme createTextTheme() {
  TextTheme initial = ThemeData.light().textTheme;
  return initial.copyWith(
    // for App Bar Titles
    headline6: initial.headline6!.copyWith(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),

    // for Post Headings
    headline4: initial.headline4!.copyWith(
      color: text2,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    ),

    // For Captions and other small text
    caption: initial.caption!.copyWith(
      color: text2,
      fontWeight: FontWeight.normal,
    ),
    bodyText1: initial.bodyText1!.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.normal,
    ),
    // For Normal Text
    bodyText2: initial.bodyText2!.copyWith(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.normal,
    ),
    // For Buttons
    headline5: initial.headline5!.copyWith(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.3,
    ),
  );
}

ElevatedButtonThemeData createElevatedButtonTheme() {
  ElevatedButtonThemeData initial = ThemeData().elevatedButtonTheme;
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primary_color,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      //elevation: 10,
    ),
  );
}

AppBarTheme createAppBarTheme() {
  return AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors
          .black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
    ),
  );
}
