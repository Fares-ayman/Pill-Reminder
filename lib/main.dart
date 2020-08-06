import 'package:flutter/material.dart';
import 'package:pill_reminder/Screens/Loading_Screen.dart';
import 'Screens/Welcome_Screen.dart';
import 'Screens/Add_information_Screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: loadscreen.id,
      routes: {
        loadscreen.id:(context)=>loadscreen(),
        welcomescreen.id:(context)=>welcomescreen(),
//          addinformationscreen.id:(context)=>addinformationscreen(),
      },
    );
  }
}

