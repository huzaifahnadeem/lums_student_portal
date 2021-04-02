import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('One-line with leading widget'),
              // onTap: () => _tapCallback,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Log out'),
              onTap: () async {
                await Authentication().signOut();
                Navigator.pop(context);
              }
            ),
          ),
        ],
      ),
    );
  }
}
