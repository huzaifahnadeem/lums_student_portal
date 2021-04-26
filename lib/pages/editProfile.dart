import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/validators.dart';
import 'package:lums_student_portal/models/profile.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';

class EditProfile extends StatefulWidget {
  final bool showSC;
  final String userId;
  EditProfile({required this.showSC, required this.userId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _EditProfileState extends State<EditProfile> {
  late ProfileModel _profile;
  late bool objectInitialized;
  late Future<DocumentSnapshot?> _future;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final filePicker = FilePicker.platform;
  final _formKey = GlobalKey<FormState>();
  
  TimeOfDay? selectedTime;
  OfficeHours? selectedOfficeHours;

  void deleteProfilePicture(String docID) async {
    String result = '';
    if (_profile.pictureURL != null) {
      result = await _profile.deletePicture(docID);
      setState(() {
        _profile.pictureURL = null;
      });
    } else {
      result = "You currently don't have a profile picture!";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: <Widget>[
      Icon(
        Icons.notification_important,
        color: Colors.white,
        semanticLabel: "Done",
      ),
      Text('  $result')
    ])));
  }

  void update(String docID) async {
    if (_formKey.currentState!.validate()) {
      print(_profile.name);
      String result = await _profile.updateDb(docID);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: <Widget>[
        Icon(
          Icons.notification_important,
          color: Colors.white,
          semanticLabel: "Done",
        ),
        Text('  $result')
      ])));
    }
  }

  void selectPicture() async {
    print("select picture called");
    FilePickerResult? result = await filePicker
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
    // ignore: unnecessary_null_comparison
    if (result != null) {
      _profile.image = File(result.paths[0]!);
      print(_profile.image);
      setState(() {
        _profile.pictureChanged = true;
      });
    } else {
      setState(() {
        _profile.pictureChanged = false;
      });
    }
  }

  String timeObjToString(TimeOfDay givenTime) {
    return (givenTime.hourOfPeriod.toString() == '0' ? '12': givenTime.hourOfPeriod.toString()) +
        ":" +
        (givenTime.minute.toString().length == 1? "0"+givenTime.minute.toString(): givenTime.minute.toString()) +
        " " +
        givenTime.period.toString().substring(10).toUpperCase();
  }

  void updateOfficeHoursInModel() {
    bool updateTime = true;
    if (selectedOfficeHours!.days == "MW") {
      selectedOfficeHours!.days = "Mondays and Wednesdays";
    }
    else if (selectedOfficeHours!.days == "TT") {
      selectedOfficeHours!.days = "Tuesdays and Thursdays";
    }
    else if (selectedOfficeHours!.days == "WF") {
      selectedOfficeHours!.days = "Wednesdays and Fridays";
    }
    else { // case: {day: "None", time: "None"}
      _profile.officeHours = null;
      updateTime = false;
    }
    
    if (updateTime) {
      selectedOfficeHours!.time = timeObjToString(selectedTime!);
      _profile.officeHours = selectedOfficeHours!.toMap();
    }
    
  }

  TimeOfDay timeConvert(String normTime) { // converts from '6:00 AM' to TimeOfDay object
    // source: https://stackoverflow.com/questions/53382971/how-to-convert-string-to-timeofday-in-flutter
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  void initTimeandOfficeHoursObjs() {
    if (_profile.officeHours == null) {
      selectedOfficeHours = new OfficeHours("None", "None");
    }
    else {
      selectedOfficeHours = new OfficeHours(_profile.officeHours!['days'], _profile.officeHours!['time']);
      selectedOfficeHours!.days == "Mondays and Wednesdays"
          ? selectedOfficeHours!.days = "MW"
          : selectedOfficeHours!.days == "Tuesdays and Thursdays"
              ? selectedOfficeHours!.days = "TT"
              : selectedOfficeHours!.days == "Wednesdays and Fridays"
                  ? selectedOfficeHours!.days = "WF"
                  : selectedOfficeHours!.days = "None";
      
      selectedTime = timeConvert(selectedOfficeHours!.time);
    }
  }

  void initState() {
    _future = _db.collection("Profiles").doc(widget.userId).get();
    _profile = ProfileModel(name: '', role: 'Student', email: ''); 
    objectInitialized = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors
                .black, //Changing back button's color to black so that its visible.
          ),
          title: Text('Edit Profile',
              style: GoogleFonts.robotoSlab(textStyle: Theme.of(context).textTheme.headline6)),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<DocumentSnapshot?>(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot?> snapshot) {
            if (snapshot.hasData) {
              //print(snapshot.data!['residence_status']);
              //return (Text("Done"));
              if (!objectInitialized) {
                _profile.convertToObject(snapshot.data!);
                initTimeandOfficeHoursObjs();
                objectInitialized = true;
              }
              return SafeArea(
                  minimum: EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // TODO: Add discard/confirmation dialog box when going back. WillPopScope class might be useful.
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black38,
                                      spreadRadius: 5)
                                ],
                              ),
                              child: InkWell(
                                // Profile Photo
                                //InkWell is similar to GestureDetector but it also has an animation
                                onTap: () async {
                                  return showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        // titleTextStyle: ,
                                        title: Text('Profile Picture',
                                            textAlign: TextAlign.center),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              ListTile(
                                                  leading: new Icon(Icons
                                                      .add_photo_alternate_outlined),
                                                  title: Text('Upload a Photo'),
                                                  onTap: () => {
                                                        selectPicture(),
                                                        Navigator.pop(context),
                                                      }),
                                              ListTile(
                                                  leading: new Icon(Icons
                                                      .highlight_remove_sharp),
                                                  title: Text(
                                                      'Remove Current Photo'),
                                                  onTap: () => {
                                                        deleteProfilePicture(
                                                            snapshot.data!.id),
                                                        Navigator.pop(context),
                                                      }),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                primary: Colors.redAccent),
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                    radius: 80 + 4, // the profile avatar border
                                    backgroundColor: Colors.white,
                                    child: _profile.pictureChanged
                                        ? CircleAvatar(
                                            backgroundImage:
                                                FileImage(_profile.image!),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 15,
                                                      color: Colors.black87,
                                                      spreadRadius: 5)
                                                ],
                                              ),
                                              child: new Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: Colors.grey,
                                            radius: 80,
                                          )
                                        : _profile.pictureURL == null
                                            ? CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/default-avatar.png"),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 15,
                                                          color: Colors.black87,
                                                          spreadRadius: 5)
                                                    ],
                                                  ),
                                                  child: new Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor: Colors.grey,
                                                radius: 80,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    _profile.pictureURL!),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 15,
                                                          color: Colors.black87,
                                                          spreadRadius: 5)
                                                    ],
                                                  ),
                                                  child: new Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                radius: 80,
                                                backgroundColor: Colors.grey,
                                              )),
                              ),
                            ),
                            SizedBox(height: 25),
                            TextFormField(
                              initialValue: _profile.name,
                              decoration: InputDecoration(labelText: "Name"),
                              validator: (val) => generalFieldValidator(val!),
                              onChanged: (val) {
                                setState(() => _profile.name = val);
                              },
                            ),
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DropdownButtonFormField<String>(
                                hint: Text("Hostel Status",),
                                decoration: InputDecoration(labelText: 'Hostel Status'),
                                validator: (val) => dropDownValidator(val),
                                value: _profile.hostel,
                                icon: const Icon(Icons.arrow_drop_down),
                                style: Theme.of(context)
                                    .inputDecorationTheme
                                    .labelStyle!
                                    .copyWith(color: Colors.black),
                                onChanged: (newVal) {
                                  setState(() {
                                    _profile.hostel = newVal.toString();
                                  });
                                },
                                items: _profile.residenceTypes
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DropdownButtonFormField<String>(
                                hint: Text("Year"),
                                decoration: InputDecoration(labelText: 'Year'),
                                validator: (val) => dropDownValidator(val),
                                value: _profile.year,
                                icon: const Icon(Icons.arrow_drop_down),
                                style: Theme.of(context)
                                    .inputDecorationTheme
                                    .labelStyle!
                                    .copyWith(color: Colors.black),
                                onChanged: (newVal) {
                                  setState(() {
                                    _profile.year = newVal.toString();
                                  });
                                },
                                items: _profile.years
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DropdownButtonFormField<String>(
                                hint: Text("School",),
                                decoration: InputDecoration(labelText: 'School'),
                                validator: (val) => dropDownValidator(val),
                                value: _profile.school,
                                icon: const Icon(Icons.arrow_drop_down),
                                style: Theme.of(context)
                                    .inputDecorationTheme
                                    .labelStyle!
                                    .copyWith(color: Colors.black),
                                onChanged: (newVal) {
                                  setState(() {
                                    _profile.school = newVal.toString();
                                  });
                                },
                                items: _profile.schools
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              initialValue: _profile.major,
                              decoration: InputDecoration(labelText: "Major"),
                              validator: (val) => generalFieldValidator(val!),
                              onChanged: (val) {
                                setState(() => _profile.major = val);
                              },
                            ),
                            (_profile.role == "SC" || _profile.role == "IT")
                                ? SizedBox(height: 0)
                                : SizedBox(height: 15),
                            if (_profile.role == "SC" || _profile.role == "IT")
                              Text(
                                "Select Office Hours Days:",
                                style: TextStyle(height: 5, fontSize: 15),
                              ),
                            if (_profile.role == "SC" || _profile.role == "IT")
                              Wrap(spacing: 8.0, children: <Widget>[
                                FilterChip(
                                  label: Text('Mon-Wed'),
                                  selected: selectedOfficeHours!.days == "MW"
                                      ? true
                                      : false,
                                  selectedColor: Theme.of(context).primaryColor,
                                  onSelected: (bool value) {
                                    setState(() {
                                      selectedOfficeHours!.days == "MW"
                                          ? selectedOfficeHours!.days = "None"
                                          : selectedOfficeHours!.days = "MW";
                                    });
                                  },
                                ),
                                FilterChip(
                                  label: Text('Tues-Thurs'),
                                  selected: selectedOfficeHours!.days == "TT"
                                      ? true
                                      : false,
                                  selectedColor: Theme.of(context).primaryColor,
                                  onSelected: (bool value) {
                                    setState(() {
                                      selectedOfficeHours!.days == "TT"
                                          ? selectedOfficeHours!.days = "None"
                                          : selectedOfficeHours!.days = "TT";
                                    });
                                  },
                                ),
                                FilterChip(
                                  label: Text('Wed-Fri'),
                                  selected: selectedOfficeHours!.days == "WF"
                                      ? true
                                      : false,
                                  selectedColor: Theme.of(context).primaryColor,
                                  onSelected: (bool value) {
                                    setState(() {
                                      selectedOfficeHours!.days == "WF"
                                          ? selectedOfficeHours!.days = "None"
                                          : selectedOfficeHours!.days = "WF";
                                    });
                                  },
                                ),
                              ]),

                            if (_profile.role == "SC" || _profile.role == "IT")
                              SizedBox(height: 15),

                            if (_profile.role == "SC" || _profile.role == "IT")
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                  ),
                                  child: Text(
                                    "Office Hours Timeslot: " + (selectedTime != null ? timeObjToString(selectedTime!) : "Not Selected"),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    TimeOfDay? temp = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTime != null? selectedTime!: TimeOfDay.now(),
                                    builder: (BuildContext? context,
                                        Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context!)
                                            .copyWith(
                                                alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );  
                                  setState(() {
                                    selectedTime = temp;
                                  });
                                  },
                                ),
                              ),
                            if (_profile.role == "SC" || _profile.role == "IT")
                              SizedBox(height: 15),

                            if (_profile.role == "SC" || _profile.role == "IT")
                              TextFormField(
                                initialValue: _profile.manifesto,
                                maxLines: null,
                                decoration:
                                    InputDecoration(labelText: "Manifesto"),
                                onChanged: (val) {
                                  setState(() => _profile.manifesto = val);
                                },
                              ),
                            if (_profile.role == "SC" || _profile.role == "IT")
                              SizedBox(height: 15),
                            
                            SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () => {
                                    if (_profile.role != "Student") {
                                        updateOfficeHoursInModel(),
                                      },
                                    update(snapshot.data!.id)
                                  },
                                  child: Text('Update Profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ),
                              ),
                            SizedBox(height: 15),
                            // TODO: Add progress indicator after pressing update button
                          ],
                        )),
                  ));
            } else if (snapshot.hasError) {
              return Text("Error");
            } else {
              return LoadingScreen();
            }
          },
        ));
  }
}