import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';

class AppSettings extends StatelessWidget {
  // TODO: adjust theme as per screens e.g. app bar color. Listtile text font etc
  late final String role;
  late final bool showSC, showIT;

  AppSettings({required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == "SC") {
      showSC = true;
      showIT = false;
    } else if (role == "IT") {
      showSC = true;
      showIT = true;
    } else {
      // role == "Student"
      showSC = false;
      showIT = false;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Settings', // TODO: looks off as compared to other screens (newsfeed etc) because it's centered and due to its font size/typeface. Need to discuss with others
          style: GoogleFonts.robotoSlab(
              color: Colors.black,
              textStyle: Theme.of(context).textTheme.headline6
              ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          const Divider(
            height: 70,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
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
          if (showIT)
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
          if (showIT)
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
          if (showIT)
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
  // TODO:
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

/// This is the stateful widget that the main application instantiates.
class EditProfile extends StatefulWidget {
  final bool showSC;
  EditProfile(this.showSC);
  @override
  _EditProfileState createState() => _EditProfileState(showSC);
}

/// This is the private State class that goes with MyStatefulWidget.
class _EditProfileState extends State<EditProfile> {
  final bool showSC;
  String residenceSelection = 'Select Residence Status';
  String yearSelection = 'Select Your Year';
  String schoolSelection = 'Select Your School';
  String schoolOfficeHoursDay = 'Select Office Hours Day';
  TimeOfDay? selectedTime;
  _EditProfileState(this.showSC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        // TODO: Backend part not done
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              DropdownButtonFormField<String>(
                value: yearSelection,
                icon: const Icon(Icons.arrow_drop_down), 
                style: Theme.of(context).inputDecorationTheme.labelStyle, // to match the style with textfields
                onChanged: (String? newValue) {
                  setState(() {
                    yearSelection = newValue!;
                  });
                },
                items: <String>['Select Your Year','First-Year', 'Sophomore', 'Junior', 'Senior', 'Fifth-Year']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: residenceSelection,
                icon: const Icon(Icons.arrow_drop_down), 
                style: Theme.of(context).inputDecorationTheme.labelStyle, // to match the style with textfields
                onChanged: (String? newValue) {
                  setState(() {
                    residenceSelection = newValue!;
                  });
                },
                items: <String>['Select Residence Status','Hostelite', 'Day Scholar']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: schoolSelection,
                icon: const Icon(Icons.arrow_drop_down), 
                style: Theme.of(context).inputDecorationTheme.labelStyle, // to match the style with textfields
                onChanged: (String? newValue) {
                  setState(() {
                    schoolSelection = newValue!;
                  });
                },
                items: <String>['Select Your School', 'MGSHSS', 'SAHSOL', 'SBASSE', 'SDSB', 'SOE']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 25),
              if (showSC)
                DropdownButtonFormField<String>(
                value: schoolOfficeHoursDay,
                icon: const Icon(Icons.arrow_drop_down), 
                style: Theme.of(context).inputDecorationTheme.labelStyle, // to match the style with textfields
                onChanged: (String? newValue) {
                  setState(() {
                    yearSelection = newValue!;
                  });
                },
                items: <String>['Select Office Hours Day','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (showSC) SizedBox(height: 25),
              if (showSC)
                SizedBox(
                // Confirm Button
                width: double.infinity,
                height: 40,
                child: ElevatedButton (
                child: Text("Office hours timeslot"),
                onPressed: () async {
                    selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext? context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context!)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                },
              ),
              ),
              if (showSC) SizedBox(height: 25),
              if (showSC)
                TextFormField(
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Update Account', // header
          style: GoogleFonts.robotoSlab(
              textStyle: Theme.of(context).textTheme.headline6),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        // TODO: Backend part not done
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Column(children: <Widget>[
              const Divider(
                height: 40,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Username"), //TODO: validation check
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration:
                    InputDecoration(labelText: "Role"), //TODO: Drop down menu?
              ),
              SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Category"), //TODO: Drop down menu?
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
      body: Text(
          " TODO: About Sceen's styling etc.\n CS 360 Project: LUMS Student Portal\n By: Group 04\n For: LUMS Student Council\n App Version: v0.1.0"),
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
