import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/pages/saved.dart';
import 'newsfeed.dart';
import 'package:flutter/rendering.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen
import 'package:lums_student_portal/pages/studentCouncil.dart'; // for Student Council screen
import 'package:lums_student_portal/pages/addComplaint.dart'; // for adding complaint
import 'package:lums_student_portal/pages/complaintHistory.dart'; // for complaint History
import 'package:lums_student_portal/pages/complaintResolve.dart'; // for ressolving complaint

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // creating state variables
  static String filter = "General";
  //late ScrollController scrollController ;
  bool _showFloatingActionButton = true;
  late int _selectedIndex; // current index of the bottom bar button selected
  late int
      _numTabs; // number of tabs to display on each screen - for example 3 for Complaints
  late TabController
      _tabController; // in-built variable which handles shifting of tabs
  late String appBarTitle;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String? userRole;

  // List of App Bar titles
  List<String> appBarTitles = ["NewsFeed", "Complaints", "SC Profiles"];
  // Tab headers for each screen
  List<List<Widget>> _tabsEachScreen = [
    [
      Tab(
        text: "Main",
      ),
      Tab(
        text: "Saved",
      )
    ], // for newsfeed section
    [
      Tab(
        text: "Add Complaint",
      ),
      Tab(
        text: "History",
      ),
    ],
    [
      Tab(
        text: "Main",
      )
    ],
    [
      Tab(
        text: "Main",
      )
    ] // for the rest, please replace these as you progress
  ];

  // list of buttons in the bottom nav bar
  List<BottomNavigationBarItem> _bottomBarButtons = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.report),
      label: 'Complaints',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'SC Profiles',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  // member functions
  void initState() {
    // to check role of user and display appropriate pages
    User? thisUser = FirebaseAuth.instance.currentUser;
    _db
        .collection("Profiles")
        .where("email", isEqualTo: thisUser!.email)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() => userRole = result.get("role"));
        if (result.get("role") == "SC" || result.get("role") == "IT") {
          _tabsEachScreen[1].add(Tab(
            text: "Resolve",
          ));
        }
      });
    });

    super.initState();
    //scrollController = new ScrollController();
    appBarTitle = "NewsFeed";
    _selectedIndex = 0;
    _numTabs = _tabsEachScreen[_selectedIndex].length;
    _tabController = TabController(length: _numTabs, vsync: this);
    //handleScroll();
  }

  void applyFilter(String value) {
    print('apply filter called');
    setState(() {
      filter = value;
    });
  }

  void dispose() {
    //scrollController.removeListener(() {});
    //scrollController.dispose();
    super.dispose();
  }

  /*void showFloatingButton() {
    if(mounted){setState(() {
      _showFloatingActionButton = true;
    });}
  }
  void hideFloatingButton() {
    if (mounted){setState(() {
      _showFloatingActionButton = false;
    });}
  }
  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloatingButton();
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloatingButton();
      }
    });
  }*/
  // change state when an icon in bottom bar is tapped
  void navigate(int newIndex) {
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
        _numTabs = _tabsEachScreen[_selectedIndex].length;
        _tabController = TabController(length: _numTabs, vsync: this);
      });
    }
  }

  List<Widget> returnBody() {
    List<List<Widget>> views = [
      [
        // news feed subscreens
        Newsfeed(filter: filter),
        Saved(filter: filter)
      ],
      [
        AddComplaint(),
        ComplaintHistory(),
        if (userRole == "SC" || userRole == "IT") ComplaintResolve()
      ],
      [StudentCouncil()],
      [
        Profile(who: "self")
      ], // who is used to specify whose profile you want to see. "self" keyword is used for own profile. For SC members pass their UID in who field as string
    ];
    return views[_selectedIndex];
  }

  // function to apply filter to home screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex >= 2
          ? null
          : AppBar(
              title: Align(
                  alignment: Alignment.topLeft,
                  child: Text(appBarTitles[_selectedIndex])),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                _selectedIndex == 0
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: new Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                            isExpanded: false,
                            value: filter,
                            dropdownColor: Colors.amber,
                            onChanged: (newVal) =>
                                applyFilter(newVal.toString()),
                            items: Post.categories1.map((categoryItem) {
                              return DropdownMenuItem(
                                value: categoryItem,
                                child: Text(
                                  categoryItem,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Container(),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: _tabsEachScreen[_selectedIndex],
                indicatorColor: Colors.white,
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: returnBody(),
      ),
      // add a floating action button on the newsfeed screen
      floatingActionButton: _selectedIndex != 0
          ? null
          : Visibility(
              visible: _showFloatingActionButton,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, '/AddPost');
                },
                label: const Text('Add Post'),
                icon: const Icon(Icons.add_box_sharp),
                backgroundColor: Colors.red,
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomBarButtons,
        currentIndex: _selectedIndex,
        onTap: (index) => navigate(index),
      ),
    );
  }
}
