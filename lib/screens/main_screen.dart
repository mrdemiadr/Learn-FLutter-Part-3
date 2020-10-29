import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter_3/screens/createmoods_screen.dart';
import 'package:learn_flutter_3/screens/userdisplayname_screen.dart';
import 'package:learn_flutter_3/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String myDisplayName = 'User';
  var _firebaseFirestore = FirebaseFirestore.instance.collection('moods');
  String imgProfile =
      'https://www.pngkey.com/png/detail/230-2301779_best-classified-apps-default-user-profile.png';
  String namaHero = 'superheroname';
  String moodsHero = '.....';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    streamFirestoreData();
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

  void streamFirestoreData() {
    _firebaseFirestore.doc(loggedInUser.email).snapshots().listen((event) {
      if (event.data() != null) {
        setState(() {
          namaHero = event.data()['namahero'];
          imgProfile = event.data()['urlhero'];
          moodsHero = event.data()['moodstext'];
        });
      }
    });
  }

  void deleteMoods() async {
    await _firebaseFirestore.doc(loggedInUser.email).delete();
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
                  'Helo $myDisplayName, you are $namaHero!',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Moods: $moodsHero',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
                RaisedButton(
                  onPressed: () {
                    deleteMoods();
                    setState(() {
                      imgProfile =
                      'https://www.pngkey.com/png/detail/230-2301779_best-classified-apps-default-user-profile.png';
                      namaHero = 'superheroname';
                      moodsHero = '.....';
                    });
                  },
                  child: Text('Delete moods'),
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
                          Navigator.pushNamed(context, CreateMoodsScreen.id)
                              .whenComplete(
                                () => {streamFirestoreData()},
                          );
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
