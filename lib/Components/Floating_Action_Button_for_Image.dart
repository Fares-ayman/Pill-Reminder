import 'package:flutter/material.dart';
import 'package:pill_reminder/constants.dart';


class fab extends StatelessWidget {
  final Function ontab;
  final IconData icon;
  fab({this.icon,this.ontab});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: ontab,
      backgroundColor: Ksecond_color,
      foregroundColor: Kmain_color,
      child: Icon(icon,size: 40.0,),
    );
  }
}
