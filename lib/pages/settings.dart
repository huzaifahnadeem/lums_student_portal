import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: 
          GoogleFonts.robotoSlab(
            color: Colors.white,
            textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text("This")
    );
  }
}
