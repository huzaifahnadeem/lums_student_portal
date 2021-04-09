import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lums_student_portal/backend/validators.dart';
import 'package:lums_student_portal/models/profile.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';

class EditProfile extends StatefulWidget {
  final bool showSC;
  final String userId;
  EditProfile({required this.showSC, required this.userId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _EditProfileState extends State<EditProfile> {

  late Profile _profile ;
  late bool objectInitialized ;
  late Future<DocumentSnapshot?> _future;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final filePicker = FilePicker.platform;
  final _formKey = GlobalKey<FormState>();

  TimeOfDay? selectedTime;

  void initState(){
    _future = _db.collection("Profiles").doc(widget.userId).get();
    _profile = Profile(name: '', role: 'student', email: '');
    objectInitialized = false;
    super.initState();
  }

  void deleteProfilePicture(String docID) async {
    String result = '';
    if (_profile.pictureURL != null){
      result = await _profile.deletePicture(docID);
    }
    else{
      result ="You currently don't have a profile picture!";
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
  void update(String docID) async{
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


  void selectPicture() async{
    FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png']
    );
    // ignore: unnecessary_null_comparison
    if(result != null) {
      _profile.image = File(result.paths[0]!);
      setState(() {
        _profile.pictureChanged = true;
      });
    } else {
      setState(() {
        _profile.pictureChanged = false ;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .black, //Changing back button's color to black so that its visible. TODO: text button instead of <- icon?
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.headline6
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
          if(snapshot.hasData){
            //print(snapshot.data!['residence_status']);
            //return (Text("Done"));
            if(!objectInitialized){
              _profile.convertToObject(snapshot.data!);
              objectInitialized = true;
            }
            return SafeArea(
              minimum: EdgeInsets.fromLTRB(30,10,30,30),
              child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _profile.name ,
                          decoration: InputDecoration(labelText: "Name"),
                          validator: (val) => headingValidator(val!),
                          onChanged: (val) {
                            setState(() => _profile.name = val);
                          },
                        ),
                        TextFormField(
                          initialValue: _profile.major ,
                          decoration: InputDecoration(labelText: "Major"),
                          validator: (val) => headingValidator(val!),
                          onChanged: (val) {
                            setState(() => _profile.major = val);
                          },
                        ),
                        if (_profile.role == "SC member" || _profile.role == "IT") TextFormField(
                          initialValue: _profile.manifesto ,
                          decoration: InputDecoration(labelText: "Manifesto"),
                          validator: (val) => headingValidator(val!),
                          onChanged: (val) {
                            setState(() => _profile.manifesto = val);
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton(
                            hint: Text("Year"),
                            value: _profile.year,
                            dropdownColor: Colors.deepOrange,
                            onChanged: (newVal) {
                              setState(() {_profile.year = newVal.toString() ;});
                            },
                            items: _profile.years.map((categoryItem) {
                              return DropdownMenuItem(
                                value: categoryItem ,
                                child: Text(categoryItem),
                              );
                            }).toList(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton(
                            hint: Text("Hostel Status"),
                            value: _profile.hostel,
                            dropdownColor: Colors.deepOrange,
                            onChanged: (newVal) {
                              setState(() {_profile.hostel = newVal.toString() ;});
                            },
                            items: _profile.residenceTypes.map((categoryItem) {
                              return DropdownMenuItem(
                                value: categoryItem ,
                                child: Text(categoryItem),
                              );
                            }).toList(),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton(
                            hint: Text("School"),
                            value: _profile.school,
                            dropdownColor: Colors.lightGreen,
                            onChanged: (newVal) {
                              setState(() {_profile.school = newVal.toString() ;});
                            },
                            items: _profile.schools.map((categoryItem) {
                              return DropdownMenuItem(
                                value: categoryItem ,
                                child: Text(categoryItem),
                              );
                            }).toList(),
                          ),
                        ),
                        IconButton(
                          tooltip: "Photo",
                          icon: new Icon(Icons.add_photo_alternate_outlined),
                          onPressed: () => selectPicture(),
                        ),
                        IconButton(
                          tooltip: "Photo",
                          icon: new Icon(Icons.highlight_remove_sharp),
                          onPressed: () => deleteProfilePicture(snapshot.data!.id),
                        ),
                        //// INSERT TIME AND DAY PICKER HERE, extract day and time as a string
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => update(snapshot.data!.id),
                            child: Text('Update Profile',
                                style: Theme.of(context).textTheme.headline5),
                          ),
                        ),
                      ],
                    )
                  ),
              )
            );
          }
          else if(snapshot.hasError){
            return Text("Error");
          }
          else{
            return LoadingScreen();
          }
        },
      )
    );
  }

}

/*String residenceSelection = 'Select Residence Status';
  String yearSelection = 'Select Your Year';
  String schoolSelection = 'Select Your School';
  String schoolOfficeHoursDay = 'Select Office Hours Day';*/
/*
Form(
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
),*/
