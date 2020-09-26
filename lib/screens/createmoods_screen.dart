import 'package:flutter/material.dart';

class CreateMoodsScreen extends StatefulWidget {
  static const String id = 'createmoods_screen';
  @override
  _CreateMoodsScreenState createState() => _CreateMoodsScreenState();
}

class _CreateMoodsScreenState extends State<CreateMoodsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}
