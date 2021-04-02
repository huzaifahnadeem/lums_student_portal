import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';
import 'package:transparent_image/transparent_image.dart';
import'package:carousel_slider/carousel_slider.dart';

class PostItem extends StatefulWidget {
  final DocumentSnapshot post;
  final Function displaySnackBar ;
  PostItem({required this.post, required this.displaySnackBar,Key? key}): super(key: key);
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
    widget.displaySnackBar(result);
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
          Column(
            children: [
              // post content
              Padding(
                padding: const EdgeInsets.fromLTRB(15,0,15,0),
                child: Align(
                alignment: Alignment.centerLeft,
                child: Text("${widget.post['content']}", style: Theme.of(context).textTheme.bodyText1,)
                ),
              ),
              SizedBox(height: 20,),
              // post pictures
              widget.post['picture_chosen']? CarouselSlider(
                items: [FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: widget.post['picture_url'],
                  ),
                ],
                options: CarouselOptions(
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: true,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ): Container(),
            ]
          ),
          ListTile(
            subtitle: widget.post['file_chosen']? FittedBox(
              alignment: Alignment.topLeft,
              fit: BoxFit.scaleDown,
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
  late final String filter ;
  Newsfeed({required this.scrollController, required this.filter, Key? key}): super(key: key);
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  // member variables
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String? filter2 ;
  late Stream<QuerySnapshot?> _streamOfPostChanges ;
  var categoryMap = {'DC': 'Disciplinary Committee', 'Academic': 'Academic Policy',
    'General': 'General','Campus': 'Campus Development','Others':"Others"};

  // display snackbar
  void displaySnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.white,
            semanticLabel: "Error",
          ),
          Text('  $message')
        ])));
  }


  // setting initial state
  void initState()  {
    _streamOfPostChanges = _db.collection("Posts").snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    filter2 = categoryMap[widget.filter]!;
    print(filter2);
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
            var result = snapshot.data!.docs.where((element) =>
            filter2 == "General" ? true: (element['category'] == filter2 ? true:false));
            return ListView.builder(
              controller: widget.scrollController,
              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                  return PostItem(post: result.toList()[index], displaySnackBar: displaySnackBar,);
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
