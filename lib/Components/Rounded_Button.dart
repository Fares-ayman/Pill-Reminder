import 'package:flutter/material.dart';

class rounded_button extends StatelessWidget {
  final Color color;
  final String TextName;
  final Function OnPressed;
  rounded_button({this.color,this.TextName,this.OnPressed});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: OnPressed,
        minWidth: 150.0,
        height: 42.0,
        child: Text(
          TextName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
