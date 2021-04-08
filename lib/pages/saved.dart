import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/themes/progessIndicator.dart';
import 'package:transparent_image/transparent_image.dart';
import'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostItem extends StatefulWidget {
  final DocumentSnapshot post;
  final String userID ;
  PostItem({required this.post, required this.userID, Key? key}): super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // state variables
  late Post postModel ;
  String timeDaysAgo = '';
  late bool isSaved ;

  void initialize(){
    postModel = Post(subject: widget.post['subject'], content:widget.post['content']);
    postModel.id = widget.post.id ;
    postModel.convertToObject(widget.post);
    if(postModel.savedPosts.contains(widget.userID)){
      isSaved = true ;
    }
    else{
      isSaved = false ;
    }
  }
  // calculate days ago
  void calcDaysAgo(){
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

  void updateSaveStatus() async {
    await postModel.addSavedPosts(widget.post.id, widget.userID);
    setState(() {
      isSaved = !isSaved ;
    });
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
                    options: CarouselOptions(
                      height: 400.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ) ,
                    items: postModel.pictureURL.map((imgUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: FadeInImage.memoryNetwork(
                              fit: BoxFit.fill,
                              placeholder: kTransparentImage,
                              image: imgUrl,
                            ),
                          );
                        },
                      );
                    }).toList()
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
                    icon: isSaved? new Icon(Icons.favorite, color: Colors.red,):new Icon(Icons.favorite_outline_sharp),
                    onPressed: () => updateSaveStatus(),
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


class Saved extends StatefulWidget {
  //late final ScrollController scrollController ;
  late final String filter ;
  Saved({required this.filter, Key? key}): super(key: key);
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  // member variables
  String userID = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String? filter2 ;
  late Stream<QuerySnapshot?> _streamOfSavedPostChanges ;
  var categoryMap = {'DC': 'Disciplinary Committee', 'Academic': 'Academic Policy',
    'General': 'General','Campus': 'Campus Development','Others':"Others"};

  // setting initial state
  void initState()  {
    _streamOfSavedPostChanges = _db.collection("Posts").where("saved_posts", arrayContains: userID).snapshots();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    filter2 = categoryMap[widget.filter]!;
    print(filter2);
    return StreamBuilder<QuerySnapshot?>(
        stream: _streamOfSavedPostChanges,
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
              //controller: widget.scrollController,
              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                return PostItem(post: result.toList()[index], userID: userID,);
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
