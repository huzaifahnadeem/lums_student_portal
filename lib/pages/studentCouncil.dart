import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:lums_student_portal/pages/scDocuments.dart';
import 'package:lums_student_portal/models/officeHours.dart'; // for profile screen

class StudentCouncil extends StatefulWidget {
  @override
  _StudentCouncilState createState() => _StudentCouncilState();
}

class _StudentCouncilState extends State<StudentCouncil> {
  List<DocumentSnapshot?> documentSnaps =
      []; // to get doc id: documentSnaps[index]!.id. Other data like: documentSnaps[index]!["name"]
  OfficeHoursModel? officeHours;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot?> _councilMembersIDsSnapshot;

  void initState() {
    _councilMembersIDsSnapshot = _db
        .collection("Profiles")
        .where('role', whereIn: ['SC', 'IT']).snapshots();

    super.initState();
  }

  Widget councilProfilesBody(BuildContext context) {
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
              // Profiles Tab:
              ListView.builder(
                itemCount: documentSnaps.length,
                itemBuilder: (BuildContext context, int index) {
                  return (Card(
                    child: ListTile(
                      leading: profilePhotoExists(documentSnaps, index)
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  documentSnaps[index]!["picture"]),
                              backgroundColor: Colors.grey,
                              radius: 30,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/default-avatar.png"),
                              backgroundColor: Colors.grey,
                              radius: 30,
                            ),
                      title: Text(documentSnaps[index]!["name"]),
                      // subtitle: Text('Dept etc'),
                      subtitle: Text(' '),                      
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return (
                              Profile(
                                who: (documentSnaps[index]!
                                    .id))
                              ); // function returns a widget
                          }),
                        );
                      },
                    ),
                  ));
                },
              ),

              // Office Hours Tab:
              ListView.builder(
                itemCount: officeHours!.daysOfTheWeek.length, // = 5
                itemBuilder: (BuildContext context, int index) {
                  return (ExpansionTile(
                    title: Text(
                      officeHours!.daysOfTheWeek[index],
                      style: TextStyle(
                      color: Colors.black,
                    ),
                    ),
                    // expand the current day's tab. On Saturday and Sunday expand all.
                    initiallyExpanded: DateTime.now().weekday >= 6 ? true : index == DateTime.now().weekday - 1, // -1 in DateTime.now().weekday because it represents monday as int 1 but my index refers to monday as 0
                    children: officeHours!.tiles[index].length != 0 // if no office hours for this day
                        ? officeHours!.tiles[index]
                        : [
                            Text(
                              "No office hours scheduled for " +
                                  officeHours!.daysOfTheWeek[index] +
                                  ".",
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 10,),
                          ],
                  ));
                },
              ),

              // Docs Tab:
              SCDocs(),
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
            print(snapshot.error);
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
            documentSnaps.sort(
              (a, b) => a!["name"].toUpperCase().compareTo(b!["name"].toUpperCase()) // uppercase because otherwise compareTo thinks that uppercase letters come before lowercase
            );
            officeHours = new OfficeHoursModel(documentSnaps, context);
            return councilProfilesBody(context);
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
