import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.settings,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.pop();
        //       // Settings();
        //     },
        //   )
        // ],
      ),
      body: Text("This")
    );
  }
}
