import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileName extends StatefulWidget {
  static const String id = 'useprofilename_screen';

  @override
  _UserProfileNameState createState() => _UserProfileNameState();
}

class _UserProfileNameState extends State<UserProfileName> {
  final _auth = FirebaseAuth.instance;
  User _registeredUser;
  String _profileName;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      _registeredUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Set Your Profile Name',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                onChanged: (value) {
                  _profileName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Profile Name',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: () {
                      _registeredUser.delete();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        await _registeredUser.updateProfile(
                            displayName: _profileName);
                        if (_profileName != null) {
                          Navigator.pushReplacementNamed(
                              context, MainScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
