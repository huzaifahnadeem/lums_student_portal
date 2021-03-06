import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/Backend/validators.dart';
import 'package:lums_student_portal/Themes/Theme.dart';


class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String oldPassword = "", newPass1 = "", newPass2 = "";

  void updatePassword() async {
    if (_formKey.currentState!.validate()) {
     String result = await Authentication().changePassword(newPass2, oldPassword);

     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: Row(children: <Widget>[
          Icon(
            Icons.notification_important,
            color: secondary_color,
            semanticLabel: "Done",
          ),
          Text('  $result')
       ])));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password", style: GoogleFonts.robotoSlab(textStyle: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 25))),
        elevation: 1,
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(30,10,30,30),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.enhanced_encryption_outlined,
                    size: 100,
                    color: black,
                  ),
                  SizedBox(height: 20),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      "Please validate your current password and provide a new valid password",
                      style: GoogleFonts.roboto(textStyle: Theme.of(context).textTheme.bodyText1),
                    ),
                  ),
                  SizedBox(height: 30, width: 0),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Old Password"),
                    validator: (val) => headingValidator(val!),
                    onChanged: (val) {
                      setState(() => oldPassword = val);
                    },
                  ),
                  SizedBox(height: 20, width: 0),
                  TextFormField(
                    decoration: InputDecoration(labelText: "New Password"),
                    validator: (val) => passwordValidator(val!),
                    onChanged: (val) {
                      setState(() => newPass1 = val);
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Confirm New Password"),
                    validator: (val) => confirmPasswordValidator(newPass1, val!),
                    onChanged: (val) {
                      setState(() => newPass2 = val);
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => updatePassword(),
                      child: Text('Update',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )
        ),
      ),
    );
  }
}
