import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lums_student_portal/Themes/Theme.dart';
import 'package:lums_student_portal/Themes/progessIndicator.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/pages/saved.dart';
import 'newsfeed.dart';
import 'package:flutter/rendering.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen
import 'package:lums_student_portal/pages/studentCouncil.dart'; // for Student Council screen
import 'package:lums_student_portal/pages/addComplaint.dart'; // for adding complaint
import 'package:lums_student_portal/pages/complaintHistory.dart'; // for complaint History
import 'package:lums_student_portal/pages/complaintResolve.dart'; // for ressolving complaint
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lums_student_portal/Themes/Theme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // creating state variables
  static String filter = "General";
  //late ScrollController scrollController ;
  bool _showFloatingActionButton = true;
  bool loading = false;
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
        text: "Feed",
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
      label: 'Newsfeed',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.error_outline),
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
    setState(() {
      loading = true;
    });
    User? thisUser = FirebaseAuth.instance.currentUser;
    _db.collection("Profiles").doc(thisUser!.uid).get().then((value) {
      setState(() => userRole = value.get("role"));
      if (value.get("role") == "SC" || value.get("role") == "IT") {
        _tabsEachScreen[1].add(Tab(
          text: "Resolve",
        ));
      }
      setState(() {
        loading = false;
      });
    });
    appBarTitle = "NewsFeed";
    _selectedIndex = 0;
    _numTabs = _tabsEachScreen[_selectedIndex].length;
    _tabController = TabController(length: _numTabs, vsync: this);
    super.initState();
  }

  void applyFilter(String value) {
    print('apply filter called');
    setState(() {
      filter = value;
    });
  }

  void dispose() {
    super.dispose();
  }

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
        // news feed sub screens
        Newsfeed(filter: filter, role: userRole),
        Saved(filter: filter)
      ],
      [
        AddComplaint(),
        ComplaintHistory(),
        if (userRole == "SC" || userRole == "IT") ComplaintResolve()
      ],
      [StudentCouncil()],
      [
        Profile(who: "self",)
      ], // who is used to specify whose profile you want to see. "self" keyword is used for own profile. For SC members pass their UID in who field as string
    ];
    return views[_selectedIndex];
  }

  // function to apply filter to home screen
  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : Scaffold(
            appBar: _selectedIndex >= 2
                ? null
                : AppBar(
                    title: Text(
                      appBarTitles[_selectedIndex],
                      style: GoogleFonts.robotoSlab(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: secondary_color)),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    actions: [
                      _selectedIndex == 0
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: new Icon(
                                    Icons.filter_list,
                                    color: secondary_color,
                                    size: 15,
                                  ),
                                  isExpanded: false,
                                  value: filter,
                                  dropdownColor: Theme.of(context).accentColor,
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
                                            .copyWith(color: secondary_color),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                    bottom: TabBar(
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: _tabController,
                      tabs: _tabsEachScreen[_selectedIndex],
                      indicatorColor: secondary_color,
                    ),
                  ),
            body: TabBarView(
              controller: _tabController,
              children: returnBody(),
            ),
            // add a floating action button on the News feed screen
            floatingActionButton: (_selectedIndex != 0)
                ? null
                : (userRole != "Student")
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/AddPost');
                          },
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                            size: 40,
                          ),
                          backgroundColor: secondary_color,
                        ),
                      )
                    : null,
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 12,
              //showUnselectedLabels: false,
              unselectedFontSize: 10,
              unselectedIconTheme: IconThemeData(
                color: grey,
              ),
              selectedIconTheme: IconThemeData(
                color: Theme.of(context).accentColor,
              ),
              backgroundColor: secondary_color,
              type: BottomNavigationBarType.fixed,
              items: _bottomBarButtons,
              currentIndex: _selectedIndex,
              onTap: (index) => navigate(index),
            ),
          );
  }
}
