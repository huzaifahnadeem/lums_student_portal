import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostItem extends StatefulWidget {
  final DocumentSnapshot post;
  final Function displaySnackBar;
  final String? role ;
  PostItem({required this.post, required this.displaySnackBar, required this.role, Key? key})
      : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // state variables
  late Post postModel;
  String timeDaysAgo = '';
  late bool isSaved;
  String userID = FirebaseAuth.instance.currentUser!.uid;

  void initialize() {
    postModel =
        Post(subject: widget.post['subject'], content: widget.post['content']);
    postModel.id = widget.post.id;
    postModel.convertToObject(widget.post);
    if (postModel.savedPosts.contains(userID)) {
      isSaved = true;
    } else {
      isSaved = false;
    }
  }

  void updatePost() {
    Navigator.pushNamed(context, '/UpdatePost', arguments: postModel);
  }

  // calculate days ago
  void calcDaysAgo() {
    Timestamp postTimeStamp = widget.post['time'];
    int difference = (Timestamp.now().seconds - postTimeStamp.seconds);
    difference = (difference ~/ 86400);
    if (difference > 1) {
      timeDaysAgo = difference.toString() + " days ago";
    } else {
      timeDaysAgo = "today";
    }
  }

  // delete a post
  void deletePost() async {
    String result = await postModel.deletePost(widget.post.id);
    widget.displaySnackBar(result);
  }

  void updateSaveStatus() async {
    await postModel.addSavedPosts(widget.post.id, userID);
    setState(() {
      isSaved = !isSaved;
    });
  }

  void openPoll() {
    Navigator.pushNamed(context, '/poll', arguments: widget.post.id);
  }

  void downloadFile() async {
    await canLaunch(postModel.fileURL!)
        ? await launch(postModel.fileURL!)
        : widget.displaySnackBar("Your device can not launch this url!");
  }

  @override
  Widget build(BuildContext context) {
    calcDaysAgo();
    initialize();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("${widget.post['subject']}",
                style: GoogleFonts.roboto(
                  textStyle: Theme.of(context).textTheme.headline4,
                )),
            trailing: Text(
              "$timeDaysAgo",
              style: Theme.of(context).textTheme.caption,
            ),
            subtitle: Text(
              "${widget.post['category']}",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Column(children: [
            // post content
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SelectableText(
                    "${widget.post['content']}",
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
            ),
            // post pictures
            widget.post['picture_chosen']
                ? Column(
                  children: [
                    SizedBox(height: 20,),
                    CarouselSlider(
                        options: CarouselOptions(
                          height: 400.0,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                        ),
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
                        }).toList()),
                  ],
                )
                : Container(),
          ]),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical:0, horizontal:10),
            subtitle: widget.post['file_chosen']
                ? FittedBox(
                    alignment: Alignment.topLeft,
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Text(
                          "${widget.post['filename']}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        IconButton(
                            icon: new Icon(Icons.download_sharp),
                            onPressed: () => downloadFile())
                      ],
                    ),
                  )
                : Container(),
            trailing: FittedBox(
              child: ButtonBar(
                children: [
                  if (postModel.isPoll) IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: "Open the poll",
                          icon: new Icon(Icons.poll_outlined,
                              color: yellow), //FFFD5E05
                          onPressed: () => openPoll(),
                        ) else Container(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: "Save this post",
                    icon: isSaved
                        ? new Icon(Icons.favorite, color: Theme.of(context).primaryColor)
                        : new Icon(Icons.favorite_outline_sharp),
                    onPressed: () => updateSaveStatus(),
                  ),
                  (widget.role != "Student" && widget.role != null)  ? new IconButton(
                      tooltip: "Delete this post",
                      icon: new Icon(Icons.delete), onPressed: () async {
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Caution" , style: GoogleFonts.roboto(textStyle:Theme.of(context).textTheme.headline6,)),
                              content: Text("Are you sure you want to delete this post? This action can not be undone." , style: GoogleFonts.roboto(textStyle:Theme.of(context).textTheme.bodyText2,)),
                              actions: [
                                TextButton(
                                  child: Text('Yes', style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).primaryColorLight),),
                                  onPressed: () async {
                                    deletePost();
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('No',style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).primaryColorLight),),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                  ): Container(),
                  (widget.role != "Student" && widget.role != null) ? IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: "Edit this post",
                    icon: new Icon(Icons.edit),
                    onPressed: () => updatePost(),
                  ):Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}

class Newsfeed extends StatefulWidget {
  //late final ScrollController scrollController ;
  late final String? role ;
  late final String filter;
  Newsfeed({required this.filter, required this.role, Key? key}) : super(key: key);
  @override
  _NewsfeedState createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  // member variables
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String? filter2;
  late Stream<QuerySnapshot?> _streamOfPostChanges;


  // display snackbar
  void displaySnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: <Widget>[
      Icon(
        Icons.notification_important,
        color: secondary_color,
        semanticLabel: "Error",
      ),
      Text('  $message')
    ])));
  }

  // setting initial state
  void initState() {
    _streamOfPostChanges =
        _db.collection("Posts").orderBy("time", descending: true).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filter2 = Post.categoryMap[widget.filter]!;
    return StreamBuilder<QuerySnapshot?>(
        stream: _streamOfPostChanges,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An Error Occurred"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            var result = snapshot.data!.docs.where((element) =>
                filter2 == "General"
                    ? true
                    : (element['category'] == filter2 ? true : false));
            return ListView.builder(
              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                return PostItem(
                  post: result.toList()[index],
                  displaySnackBar: displaySnackBar,
                  role: widget.role,
                );
              },
            );
          } else {
            return Center(
              child: Text("Please try later"),
            );
          }
        });
  }
}
