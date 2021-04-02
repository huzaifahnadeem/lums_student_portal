import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/validators.dart';

class AppSettings extends StatelessWidget { // TODO: adjust theme as per screens e.g. app bar color. Listtile text font etc
  // TODO: check role from the DB and change accordingly: might want to make a initShowLevel() function and call before the build widget
  bool showSC = true, showIT = true;
  
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
                    return ChangePassword(); // Use Reset password screen?
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
                    return EditProfile(showSC);
                  }),
                );
              },
            ),
          ),
                    
          if (showIT) Card(
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
        
          if (showIT) Card(
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
          if (showIT) Card( 
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
          if (showIT) Card( 
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

class ChangePassword extends StatelessWidget { // TODO:
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
  final bool showSC;
  EditProfile(this.showSC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form( // TODO: Backend part not done
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Level"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(labelText: "Hostel Status"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(labelText: "School"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),

              if (showSC) TextFormField(
                decoration: InputDecoration(labelText: "Office hours days"), //TODO: Drop down menu? or Chip class? //TODO: SC only check
              ),
              if (showSC) SizedBox(height: 25),
              
              if (showSC) TextFormField(
                decoration: InputDecoration(labelText: "Office hours time slot"), //TODO: Drop down menu? or Chip class? //TODO: SC only check
              ),
              if (showSC) SizedBox(height: 25),

              if (showSC) TextFormField(
                decoration: InputDecoration(labelText: "Manifesto"),
                 maxLines: null,
              ),
              if (showSC) SizedBox(height: 25),
              SizedBox(
                // Confirm Button
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  // onPressed: () => validate(),
                  onPressed: () => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        semanticLabel: "Error",
                      ),
                      Text('TODO: Backend part not done')
                    ])))
                  },
                  child: Text('Confirm',
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class UpdateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'Update Account', // header
    //       style: GoogleFonts.robotoSlab(
    //           color: Colors.white,
    //           textStyle: Theme.of(context).textTheme.headline6),
    //     ),
    //   ),
    //   body: Text('TODO: Update Account Screen'),
    // );
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Update Account', // header
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form( // TODO: Backend part not done
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Username"), //TODO: validation check
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(labelText: "Role"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(labelText: "Category"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              SizedBox(
                // Confirm Button
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  // onPressed: () => validate(),
                  onPressed: () => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.white,
                        semanticLabel: "Error",
                      ),
                      Text('TODO: Backend part not done')
                    ])))
                  },
                  child: Text('Confirm',
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
            ]),
          ),
        ),
      ),
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
      body: Text('TODO: Add Account Screen. Also, is this screen really needed?'),
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

