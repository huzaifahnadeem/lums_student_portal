import 'package:flutter/material.dart';
import 'package:lums_student_portal/Backend/authentication.dart';
import 'package:lums_student_portal/models/post.dart';
import 'package:lums_student_portal/pages/saved.dart';
import 'newsfeed.dart';
import 'package:flutter/rendering.dart';
import 'package:lums_student_portal/pages/profile.dart'; // for profile screen




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // creating state variables
  static String filter = "General";
  //late ScrollController scrollController ;
  bool _showFloatingActionButton = true;
  late int _selectedIndex ; // current index of the bottom bar button selected
  late int _numTabs ; // number of tabs to display on each screen - for example 3 for Complaints
  late TabController _tabController; // in-built variable which handles shifting of tabs
  late String appBarTitle ;


  // List of App Bar titles
  List<String> appBarTitles = ["NewsFeed", "Complaints", "SC Profiles"] ;
  // Tab headers for each screen
  List<List<Widget>> _tabsEachScreen = [
    [Tab(text: "Main",), Tab(text: "Saved",)], // for newsfeed section
    [Tab(text: "Main",)],
    [Tab(text: "Main",)],
    [Tab(text: "Main",)]// for the rest, please replace these as you progress
  ];

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

   // member functions
  void initState(){
    super.initState();
    //scrollController = new ScrollController();
     appBarTitle = "NewsFeed" ;
    _selectedIndex = 0 ;
    _numTabs = _tabsEachScreen[_selectedIndex].length;
    _tabController = TabController(length: _numTabs, vsync: this);
    //handleScroll();
  }
  void applyFilter(String value){
     print('apply filter called');
     setState(() {
       filter = value ;
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
    if (newIndex != _selectedIndex){
      setState(() {
        _selectedIndex = newIndex ;
        _numTabs = _tabsEachScreen[_selectedIndex].length;
        _tabController = TabController(length: _numTabs, vsync: this);
      });
    }
  }
  List<Widget> returnBody (){
    List<List<Widget>> views = [
      [
        // news feed subscreens
        Newsfeed(filter: filter),
        Saved( filter: filter)

      ],
      [Text("Complaints")],
      [Text("SC Profiles")],
      [Profile()],
    ] ;
    return views[_selectedIndex];
  }

  // function to apply filter to home screen
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 3? null:AppBar(
        title: Text(appBarTitles[_selectedIndex]),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [ _selectedIndex == 0 ? Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: new Icon(Icons.filter_list, color: Colors.white,),
                isExpanded: false,
                value: filter,
                dropdownColor: Colors.amber,
                onChanged: (newVal) => applyFilter(newVal.toString()),
                items: Post.categories1.map((categoryItem) {
                  return DropdownMenuItem(
                    value: categoryItem ,
                    child: Text(categoryItem, style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),),
                  );
                }).toList(),
              ),
            ),
        ): Container(),
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
