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
              title: Text('Change password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ChangePassword();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Edit profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return EditProfile();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Update account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return UpdateAccount();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Add account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddAccount();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return About();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Initiate election process'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return InitiateElection();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('End election process'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return EndElection();
                  }),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
                title: Text('Log out'),
                onTap: () async {
                  await Authentication().signOut();
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: Change Password Screen'),
    );
  }
}

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: Edit Profile Screen'),
    );
  }
}

class UpdateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Account', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: Update Account Screen'),
    );
  }
}

class AddAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Account', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: Add Account Screen'),
    );
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: About Sceen'),
    );
  }
}

class InitiateElection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Initiate Election Process', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: Initiate Election Process Sceen'),
    );
  }
}

class EndElection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'End Election', // header
          style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6),
        ),
      ),
      body: Text('TODO: End Election Sceen'),
    );
  }
}