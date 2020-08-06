import 'package:flutter/material.dart';
import 'Welcome_Screen.dart';

class loadscreen extends StatefulWidget {
  static String id="load_screen";
  @override
  _loadscreenState createState() => _loadscreenState();
}

class _loadscreenState extends State<loadscreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed( Duration(seconds: 2), () {
     //Navigator.pushNamed(context,welcomescreen.id);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(welcomescreen.id, (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('Images/loadscreen.png'),fit: BoxFit.fill)),
    );
  }
}
