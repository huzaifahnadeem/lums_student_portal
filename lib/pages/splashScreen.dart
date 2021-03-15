import 'package:flutter/material.dart';

class splashScreen extends StatefulWidget {
  String _loadingStatus;
  splashScreen(String loadingStatus) {
    _loadingStatus = loadingStatus;
  }

  @override
  splashScreenState createState() => new splashScreenState(_loadingStatus);
}

class splashScreenState extends State<splashScreen> {
  String _loadingStatus;
  splashScreenState(String loadingStatus) {
    _loadingStatus = loadingStatus;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Placeholder for Splash screen'),
          ),
          body: Center(child: Text(_loadingStatus)),
        ),
      );
  }
}