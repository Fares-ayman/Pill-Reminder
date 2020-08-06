import 'package:flutter/material.dart';

class card_widget extends StatelessWidget {
  final Color color;
  final double elevation;
  final Widget child_card;
  final ShapeBorder shapeBorder;
  card_widget({this.color,this.elevation,this.child_card,this.shapeBorder});
  @override
  Widget build(BuildContext context) {
    return  Card(
        color: color,
        elevation: elevation,
        shape:shapeBorder,
        child:child_card
    );
  }
}
