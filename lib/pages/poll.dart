import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Poll extends StatelessWidget {
  final String id;
  late Stream<DocumentSnapshot?> _streamPoll;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Poll({required this.id, Key? key}) : super(key: key);


  int countVotes(List options){
    int count = 0 ;
    for (int i = 0 ; i<options.length ; i++){
      count += options[i]['votes'] as int;
    }
    return count;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Poll", style: GoogleFonts.robotoSlab(textStyle: Theme.of(context).textTheme.headline6)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color(0xFFEB5757), //change your color here
          ),
        ),
        body: StreamBuilder<DocumentSnapshot?>(
            stream: _db.collection("Posts").doc(id).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("An Error Occurred"));
              }
              else if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingScreen();
              }
              else if (snapshot.hasData) {
                if (snapshot.data!.exists) {
                  List options = snapshot.data!.data()!['options'];
                  List alreadyVotedArray = snapshot.data!
                      .data()!['already_voted'];
                  bool voted = alreadyVotedArray.contains(userID);
                  int totalVotes = countVotes(options);
                  return ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PollItem(id: id, index: index, content: options[index]['option'],
                          votes: options[index]['votes'], voted: voted, totalVotes: totalVotes, user: userID);
                    },
                  );
                }
                else {
                  return Center(child: Text("Document Does not exist"),);
                }
              }
              else {
                return Center(child: Text("Please try later"),);
              }
            }
        )
    );
  }
}

class PollItem extends StatefulWidget {
  final String id;
  final int index;
  final String content;
  final int votes;
  final bool voted;
  final int totalVotes;
  final String user ;

  const PollItem(
      {required this.id, required this.index, required this.content, required this.votes, required this.voted, required this.totalVotes,
        required this.user, Key? key}) : super(key: key);

  @override
  _PollItemState createState() => _PollItemState();
}

class _PollItemState extends State<PollItem> {
  bool filled = false;

  void selected(BuildContext context) async {
    if (widget.voted) {
      //
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.white,
              semanticLabel: "Done",
            ),
            Text(' You have already voted')
          ])));
    }
    else {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('Posts').doc(widget.id);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          throw Exception("Post Does Not Exist");
        }
        else {
          List optionsArray = snapshot.data()!['options'];
          optionsArray[widget.index]['votes'] += 1;
          transaction.update(documentReference, {'options': optionsArray, 'already_voted':FieldValue.arrayUnion([widget.user])});
        }
      });
    }
    print("option selected");
  }
  void _handleTapDown(TapDownDetails e){
    setState(() {
      filled = true ;
    });
  }
  void _handleTapUp(TapUpDetails e){
    setState(() {
      filled = false ;
    });
  }
  void _handleTapCancel(){
    setState(() {
      filled = false ;
    });
  }
  @override
  Widget build(BuildContext context) {
    double percentage = (widget.votes / widget.totalVotes);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.voted? Container():GestureDetector(
                  onTap: () => selected(context),
                  onTapDown: (e) => _handleTapDown(e),
                  onTapUp: (e) => _handleTapUp(e),
                  onTapCancel: () => _handleTapCancel(),
                  child: filled? new Icon(Icons.radio_button_checked_outlined):new Icon(Icons.radio_button_unchecked_outlined),
                  ),
                SizedBox(width: 10),
                Flexible(child: Text(widget.content, style: GoogleFonts.roboto(textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15)))
                )
              ],
            ),
            SizedBox(height: 10),
            widget.voted ? new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 50,
              animation: true,
              lineHeight: 23.0,
              animationDuration: 2000,
              percent: percentage,
              center: Text("${(percentage * 100).round()} %", style: GoogleFonts.roboto(textStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black, fontSize: 15))),
              linearStrokeCap: LinearStrokeCap.roundAll,
              backgroundColor: Color(0xFFE8E8E8),
              progressColor: Color(0xFF3A7BEC),
            ) : Container(),
          ]
      ),
    );
  }
}

