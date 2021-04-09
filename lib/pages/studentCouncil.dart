import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCouncil extends StatefulWidget {
  @override
  _StudentCouncilState createState() => _StudentCouncilState();
}

class _StudentCouncilState extends State<StudentCouncil> {
  List<DocumentSnapshot?> documentSnaps = []; // to get doc id: documentSnaps[index]!.id. Other data like: documentSnaps[index]!["name"]

  FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot?> _councilMembersIDsSnapshot;

  void initState() {
    _councilMembersIDsSnapshot = _db
        .collection("Profiles")
        .where('role', whereIn: ['SC', 'IT']).snapshots();
    super.initState();
  }

  void downloadFile(fileURL) async {
    await canLaunch(fileURL!) ? await launch(fileURL!) : throw 'Could not launch ${fileURL} !';
  }


  Widget councilProfilesBody() {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFEA5757),
            title: Text(
              'Student Council', // header
              style: GoogleFonts.robotoSlab(
                  color: Colors.white,
                  textStyle: Theme.of(context).textTheme.headline6),
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: "Profiles",
                ),
                Tab(
                  text: "Office Hours",
                ),
                Tab(
                  text: "Docs",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                itemCount: documentSnaps.length,
                itemBuilder: (BuildContext context, int index) {
                  return (Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(documentSnaps[index]!["picture"]),
                        // AssetImage("assets/default-avatar.png"),
                        backgroundColor: Colors.grey,
                        radius: 30,
                      ),
                      title: Text(documentSnaps[index]!["name"]),
                      subtitle: Text('Dept etc'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Profile(
                                who: (documentSnaps[index]!.id)); // function returns a widget
                          }),
                        );
                      },
                    ),
                  ));
                },
              ),
              Text("TODO: Office Hours screen"),
              ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.description),
                      title: Text('A Sample Policy File'),
                      trailing: Icon(Icons.file_download),
                      onTap: () {
                        downloadFile("http://www.africau.edu/images/default/sample.pdf");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
        stream: _councilMembersIDsSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An Error Occured"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            documentSnaps = []; // reset list.
            snapshot.data!.docs.forEach((thisDocumentSnap) {
              documentSnaps.add(thisDocumentSnap);
            });
            return councilProfilesBody();
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}