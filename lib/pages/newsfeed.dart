import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PostItem extends StatefulWidget {
  final DocumentSnapshot post;
  PostItem({required this.post, Key? key}): super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // state variables
  late Post postModel ;
  String timeDaysAgo = '';

  void initialize(){
    postModel = Post(subject: widget.post['subject'], content:widget.post['content']);
    postModel.fileChosen = widget.post['file_chosen'];
    postModel.pictureChosen = widget.post['picture_chosen'];
    postModel.fileURL = widget.post['file_url'];
    postModel.pictureURL = widget.post['picture_url'];
  }
  // calculate days ago
  void calcDaysAgo(){
    try {
      Timestamp postTimeStamp = widget.post['time'];
      int difference = (Timestamp.now().seconds - postTimeStamp.seconds);
      difference = (difference~/86400);
      if (difference>1){
        timeDaysAgo = difference.toString() + " days ago";
      }
      else{
        timeDaysAgo = "today" ;
      }
    }
    catch (err){
      print("No Timestamp");
    }
  }

  // delete a post
  void deletePost() async {
    String result = await postModel.deletePost(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    calcDaysAgo();
    initialize();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("${widget.post['subject']}", style: Theme.of(context).textTheme.headline6,),
            trailing: Text("$timeDaysAgo", style: Theme.of(context).textTheme.caption,),
            subtitle: Text("${widget.post['category']}", style: Theme.of(context).textTheme.caption,),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(padding: EdgeInsets.fromLTRB(15, 0, 10, 10),
            child: Column(
              children: [
                // post content
                Align(
                alignment: Alignment.centerLeft,
                child: Text("${widget.post['content']}", style: Theme.of(context).textTheme.bodyText1,)
                ),
                // post pictures
                widget.post['picture_chosen']? Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Image.network(
                      widget.post['picture_url']
                  ),
                ): Container(),
              ]
            )
          ),
          ListTile(
            title: widget.post['file_chosen']? FittedBox(
              child: Row(
                children: [
                  Text("${widget.post['filename']}", style: Theme.of(context).textTheme.bodyText1,),
                  IconButton(
                      icon: new Icon(Icons.download_outlined),
                      onPressed: () => {} )
                ],
              ),
            ): Container(),
            trailing: FittedBox(
              child: ButtonBar(
                children: [
                  IconButton(
                      icon: new Icon(Icons.favorite_outline_sharp),
                      onPressed: () => {}
                      ),
                  IconButton(
                      icon: new Icon(Icons.delete),
                      onPressed: () => deletePost(),
                  ),
                  IconButton(
                      icon: new Icon(Icons.edit),
                      onPressed: () => {}
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );;
  }
}


class Newsfeed extends StatefulWidget {
  late final ScrollController scrollController ;
  Newsfeed({required this.scrollController, Key? key}): super(key: key);
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  // member variables
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot?> _streamOfPostChanges ;
  String? filter ;

  // build post


  // setting initial state
  void initState()  {
    _streamOfPostChanges = _db.collection("Posts").snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot?>(
        stream: _streamOfPostChanges,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text("An Error Occured"),);
          }
          else if (snapshot.connectionState == ConnectionState.waiting){
            return LoadingScreen();
          }
          else if(snapshot.hasData){
            return ListView.builder(
              controller: widget.scrollController,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                  return PostItem(post: snapshot.data!.docs[index]);
              },
            );
          }
          else{
            return Center(child: Text("Please try later"),);
          }
        }
    );
  }
}
