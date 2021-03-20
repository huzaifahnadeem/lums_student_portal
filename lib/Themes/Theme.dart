import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/main.dart';


InputDecorationTheme createInputDecorTheme(){
  InputDecorationTheme initial = ThemeData.light().inputDecorationTheme ;
  return initial.copyWith(
    fillColor: Color(0xFFE8E1E1),
    filled: true,
    hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDCD9D9), width: 1.5),
      borderRadius: const BorderRadius.all( Radius.circular(15.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFDCD9D9), width: 2),
      borderRadius: const BorderRadius.all( Radius.circular(15.0)),
    ),
  );
}

TextTheme createTextTheme (){
  TextTheme initial = ThemeData.light().textTheme ;
  return initial.copyWith(
    // for App Bar Titles
    headline1: initial.headline1.copyWith(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w500,
    ),
    // For buttons
    bodyText2: initial.bodyText2.copyWith(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    )
  );
}

ElevatedButtonThemeData createElevatedButtonTheme(){
  return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFD04343),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
        ),
        elevation: 10,
      )
  );
}

AppBarTheme createAppBarTheme () {
  return AppBarTheme(
      centerTitle: true,
  );
}
/*
ThemeData theme () {

  AppBarTheme mainAppBarTheme (AppBarTheme base){
    return base.copyWith(
      centerTitle: true,
      foregroundColor: Colors.blue ,
    );
  }
  TextTheme mainTextTheme (TextTheme base){
    return base.copyWith(
      bodyText1: base.bodyText1.copyWith(
        fontSize: 15,
        color: Colors.black,
      )
    );
  }
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.redAccent,
    textTheme: mainTextTheme(base.textTheme),
    appBarTheme: mainAppBarTheme(base.appBarTheme),
  ) ;
}*/
