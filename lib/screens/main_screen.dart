import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter_3/screens/createmoods_screen.dart';
import 'package:learn_flutter_3/screens/userdisplayname_screen.dart';
import 'package:learn_flutter_3/screens/welcome_screen.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  dynamic myDisplayName = 'User';
  String imgProfile =
      'https://www.pngkey.com/png/detail/230-2301779_best-classified-apps-default-user-profile.png';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      if (loggedInUser.displayName != null) {
        myDisplayName = loggedInUser.displayName;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imgProfile),
                  radius: 80.0,
                ),
                Text(
                  'Helo $myDisplayName, you are Superheroname!',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Moods: ........',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        iconSize: 35.0,
                        tooltip: 'Set Profile Name',
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          Navigator.pushNamed(context, UserDisplayName.id)
                              .whenComplete(
                            () => setState(
                              () => {getCurrentUser()},
                            ),
                          );
                        },
                      ),
                      IconButton(
                        iconSize: 35.0,
                        tooltip: 'Create Moods',
                        icon: Icon(Icons.person_add),
                        onPressed: () {
                          Navigator.pushNamed(context, CreateMoodsScreen.id);
                        },
                      ),
                      IconButton(
                        iconSize: 35.0,
                        tooltip: 'Log Out',
                        icon: Icon(Icons.power_settings_new),
                        onPressed: () {
                          _auth.signOut();
                          Navigator.pushReplacementNamed(
                              context, WelcomeScreen.id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
