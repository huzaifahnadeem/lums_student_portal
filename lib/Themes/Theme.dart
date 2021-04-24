import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color yellow = Color(0xFFFFB800); // used for poll icon
const Color primary_color = Color(
    0xFFEB5757); // primary color of the app - used for stuff like app bar, splash screen, button colors, save post icon, nav bar icons etc
const Color primary_accent =
    Color(0xFFC93D3D); // primary accent - used in the bottom nav bar
const Color primary_lighter =
    Colors.redAccent; // used for remove icon for polls in add post
const Color secondary_color =
    Colors.white; // app bar title of homepage, background color, input fields.
const Color secondary_darker =
    Color(0xFFE8E8E8); // used when want to differentiate from background white
const Color secondary_lighter =
Color(0xFFF6F6F6); // used as text field input background
const Color grey = Color(
    0xFF666565); // used for headings, captions, most icons. applied to text themes also
const Color green = Color(
    0xFF56BF54); // an alternative color, can be used subtly in some areas for eg used for photo icon in add post
const Color darkBlue = Color(
    0xFF1E64EC); // same as above - eg. used for attachment icon in add post
const Color lightBlue = Color(
    0xFF48D1E3); // same as above - eg. used for add poll option icon in add post
const Color black = Colors
    .black; // used for body texts, unselected icon in nav bar, settings icons, most app bar titles

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
IconThemeData createIconTheme() {
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
      color: black,
      fontSize: 20,
      //fontWeight: FontWeight.w500,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    ),

    // For Captions and other small text
    caption: initial.caption!.copyWith(
      color: grey,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
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
      letterSpacing: 1,
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
    backgroundColor: secondary_color,
    elevation: 0,
    iconTheme: IconThemeData(
      color:
          black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
    ),
  );
}
