import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter_3/screens/createmoods_screen.dart';
import 'package:learn_flutter_3/screens/welcome_screen.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.displayName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logged In ${loggedInUser.displayName}'),
                  RaisedButton(
                    child: Text('Create Moods'),
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushNamed(context, CreateMoodsScreen.id);
                    },
                  ),
                  RaisedButton(
                    child: Text('Log Out'),
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
