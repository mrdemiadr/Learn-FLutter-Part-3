import 'package:flutter/material.dart';
import 'package:learn_flutter_3/screens/createmoods_screen.dart';
import 'package:learn_flutter_3/screens/main_screen.dart';
import 'package:learn_flutter_3/screens/register_screen.dart';
import 'package:learn_flutter_3/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        MainScreen.id: (context) => MainScreen(),
        CreateMoodsScreen.id: (context) => CreateMoodsScreen(),
      },
    );
  }
}
