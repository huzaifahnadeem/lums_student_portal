import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'newsfeed.dart';
import 'package:flutter/rendering.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // creating state variables
  late int _selectedIndex ; // current index of the bottom bar button selected
  late int _numTabs ; // number of tabs to display on each screen - for example 3 for Complaints
  late TabController _tabController; // in-built variable which handles shifting of tabs
  late String appBarTitle ;
  static ScrollController scrollController = new ScrollController();
  bool _showFloatingActionButton = true;

  // List of App Bar titles
  List<String> appBarTitles = ["NewsFeed", "Complaints", "SC Profiles", "Profiles"] ;
  // Tab headers for each screen
  List<List<Widget>> _tabsEachScreen = [
    [Tab(text: "Main",), Tab(text: "Saved",)], // for newsfeed section

    [Tab(text: "Main",)],
    [Tab(text: "Main",)],
    [Tab(text: "Main",)], // for the rest, please replace these as you progress
  ];

  // all the sub-screens/tabs for each screen
  // 2D array of size = number of buttons in bottom bar X number of tabs on that screen
   List<List<Widget>> _tabViewsForEachScreen = [
    [
      // news feed subscreens
      Newsfeed(scrollController: scrollController,),
      RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          await Authentication().signOut();
        },
      ),

    ],
     [Text("Complaints")],
     [Text("SC Profiles")],
     [Text("Profiles")], // views/subscreens of other sections - please replace these
  ] ;

   // list of buttons in the bottom nav bar
  List<BottomNavigationBarItem> _bottomBarButtons = <BottomNavigationBarItem> [
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
  ] ;

   // initialising state of the home screen, will be directed to newsfeed screen
   void initState(){
     appBarTitle = "NewsFeed" ;
    _selectedIndex = 0 ;
    _numTabs = _tabsEachScreen[_selectedIndex].length;
    _tabController = TabController(length: _numTabs, vsync: this);
    handleScroll();
    super.initState();
  }

  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  void showFloatingButton() {
    setState(() {
      _showFloatingActionButton = true;
    });
  }
  void hideFloatingButton() {
    setState(() {
      _showFloatingActionButton = false;
    });
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
  }

  // change state when an icon in bottom bar is tapped
  void navigate(int newIndex) {
    if (newIndex != _selectedIndex){
      setState(() {
        _selectedIndex = newIndex ;
        _numTabs = _tabsEachScreen[_selectedIndex].length;
        _tabController = TabController(length: _numTabs, vsync: this);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align( alignment: Alignment.topCenter,child: Text(appBarTitles[_selectedIndex])),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),child: Icon(Icons.filter_list))],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabsEachScreen[_selectedIndex],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabViewsForEachScreen[_selectedIndex],
      ),
      // add a floating action button on the newsfeed screen
      floatingActionButton: _selectedIndex != 0 ? null: Visibility(
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
