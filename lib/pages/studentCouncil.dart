// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'dart:convert';

class StudentCouncil extends StatefulWidget {
  @override
  _StudentCouncilState createState() => _StudentCouncilState();
}
 

class _StudentCouncilState extends State<StudentCouncil> {
  
  List<DocumentSnapshot?> documentSnaps = []; // to get doc id: docSnap.reference.documentID. Other data like: documentSnaps[Index]!["name"]
  
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot?> _councilMembersIDsSnapshot ;

  void initState() {
    _councilMembersIDsSnapshot = _db.collection("Profiles").where('role', whereIn: ['SC', 'IT']).snapshots();
    super.initState();
  }

  Widget councilProfilesBody() {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFEA5757),
            title: Text('Student Council', // header
                style: GoogleFonts.robotoSlab(
              color: Colors.white,
              textStyle: Theme.of(context).textTheme.headline6
              ),
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
              //controller: widget.scrollController,
              itemCount: documentSnaps.length,
              itemBuilder: (BuildContext context, int index) {
                return (
                  Card(
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
                            return Profile(who: (documentSnaps[index]!.id)); // function returns a widget
                            // return Text(documentSnaps[index]!.id);
                          }),
                        );
                      },
                    ),
                  )
                );
                },
              ),
              
              Text("TODO: Office Hours screen"),
              
              ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Academic Policy'),
                      trailing: Icon(Icons.file_download),
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) {
                      //       return ChangePassword(); // Use Reset password screen?
                      //     }),
                      //   );
                      // },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Harassment Policy'),
                      trailing: Icon(Icons.file_download),
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) {
                      //       return ChangePassword(); // Use Reset password screen?
                      //     }),
                      //   );
                      // },
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
                          
            snapshot.data!.docs.forEach((thisDocumentSnap) {documentSnaps.add(thisDocumentSnap);});
            return councilProfilesBody();
            // return Text("THIS");
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}


// class _StudentCouncilState extends State<StudentCouncil> {
//   // member variables
//   // List<DocumentSnapshot?> documentSnaps = []; 
  
//   // FirebaseFirestore _db = FirebaseFirestore.instance;
//   // late Stream<QuerySnapshot?> _councilMembersIDsSnapshot ;

//   // void initState() {
//   //   _councilMembersIDsSnapshot = _db.collection("Profiles").where('role', isEqualTo: "SC").snapshots();
//   //   super.initState();
//   // }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return StreamBuilder<QuerySnapshot?>(
//   //       stream: _councilMembersIDsSnapshot,
//   //       builder: (context, snapshot) {
//   //         if (snapshot.hasError) {
//   //           return Center(
//   //             child: Text("An Error Occured"),
//   //           );
//   //         } else if (snapshot.connectionState == ConnectionState.waiting) {
//   //           return LoadingScreen();
//   //         } else if (snapshot.hasData) {
                          
//   //           // snapshot.data!.docs.forEach((thisDocumentSnap) {documentSnaps.add(thisDocumentSnap);});
//   //           // return Text(documentSnaps[0]!["name"]);
//   //           return Text("THIS");
//   //         } else {
//   //           return Center(
//   //             child: Text("Please try later"),
//   //           );
//   //         }
//   //       });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xFFEA5757),
//             title: Text('Student Council', // header
//                 style: GoogleFonts.robotoSlab(
//               color: Colors.white,
//               textStyle: Theme.of(context).textTheme.headline6
//               ),
//                 ),
//             centerTitle: true,
//             bottom: TabBar(
//               indicatorColor: Colors.white,
//               tabs: [
//                 Tab(
//                   text: "Profiles",
//                 ),
//                 Tab(
//                   text: "Office Hours",
//                 ),
//                 Tab(
//                   text: "Docs",
//                 ),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               ListView(
//                 children: <Widget>[
//                   Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage:
//                             AssetImage("assets/default-avatar.png"),
//                         backgroundColor: Colors.grey,
//                         radius: 30,
//                       ),
//                       title: Text('Jane Doe'),
//                       subtitle: Text('Here is a second line'),
//                       // onTap: () {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (context) {
//                       //       return functionName(); // function returns a widget
//                       //     }),
//                       //   );
//                       // },
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage:
//                             AssetImage("assets/default-avatar.png"),
//                         backgroundColor: Colors.grey,
//                         radius: 30,
//                       ),
//                       title: Text('John Doe'),
//                       subtitle: Text('Here is a second line'),
//                       // onTap: () {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (context) {
//                       //       return functionName(); // function returns a widget
//                       //     }),
//                       //   );
//                       // },
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage:
//                             AssetImage("assets/default-avatar.png"),
//                         backgroundColor: Colors.grey,
//                         radius: 30,
//                       ),
//                       title: Text('Suleman Khan'),
//                       subtitle: Text('Here is a second line'),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) {
//                             return Profile(who: "BdRsMNRDAWSdKCno0xsVzoLf3Ur1",); // Hard-coded Suleman's UID for testing purposes
//                           }),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Text("TODO: Office Hours screen"),
//               ListView(
//                 children: <Widget>[
//                   Card(
//                     child: ListTile(
//                       leading: Icon(Icons.description),
//                       title: Text('Academic Policy'),
//                       trailing: Icon(Icons.file_download),
//                       // onTap: () {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (context) {
//                       //       return ChangePassword(); // Use Reset password screen?
//                       //     }),
//                       //   );
//                       // },
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: Icon(Icons.description),
//                       title: Text('Harassment Policy'),
//                       trailing: Icon(Icons.file_download),
//                       // onTap: () {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (context) {
//                       //       return ChangePassword(); // Use Reset password screen?
//                       //     }),
//                       //   );
//                       // },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
