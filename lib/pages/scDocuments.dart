import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:url_launcher/url_launcher.dart';

class SCDocs extends StatefulWidget {
  @override
  _SCDocsState createState() => _SCDocsState();
}

class _SCDocsState extends State<SCDocs> {
  List<DocumentSnapshot?> documentSnaps = []; // to get doc id: documentSnaps[index]!.id. Other data like: documentSnaps[index]!["name"]

  FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot?> _allDocsSnapshot;

  void initState() {
    _allDocsSnapshot = _db.collection("Documents").snapshots();

    super.initState();
  }

  void downloadFile(fileURL) async {
    await canLaunch(fileURL!)
        ? await launch(fileURL!)
        : throw 'Could not launch ${fileURL} !';
  }

  Widget thisDocumentCard(index) {
    Widget toReturn = Text("");
    try {
        toReturn = Card(
        child: ListTile(
          leading: Icon(Icons.description),
          title: Text(documentSnaps[index]!["name"]),
          trailing: Icon(Icons.file_download),
          onTap: () {
            downloadFile(documentSnaps[index]!["url"]);
          },
        ),
        );
      }
      catch (e) {
        toReturn = Card(
        child: ListTile(
          leading: Icon(Icons.description),
          title: Text("Error reading this document", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          trailing: Icon(Icons.file_download),
          onTap: () {
            downloadFile(documentSnaps[index]!["url"]);
          },
        ),
        );
      }
      return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
        stream: _allDocsSnapshot,
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

            return (ListView.builder(
              // Profiles tab
              itemCount: documentSnaps.length,
              itemBuilder: (BuildContext context, int index) {
                return (
                  thisDocumentCard(index)
                );
              },
            ));
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
