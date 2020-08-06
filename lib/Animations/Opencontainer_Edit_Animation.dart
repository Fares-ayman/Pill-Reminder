import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pill_reminder/constants.dart';
import 'package:pill_reminder/Screens/Add_information_Screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class opencontaineredit extends StatelessWidget {
  final CalendarController controller;
  final Map<DateTime,List<dynamic>> events;
  final Map<DateTime,List<dynamic>> newevents;
  final SharedPreferences prefs;
  final Function onpress;
  final Function delete;
  final List<dynamic> pr;
  opencontaineredit({this.controller,this.events,this.prefs,this.newevents,this.onpress,this.delete,this.pr});
  @override
  Widget build(BuildContext context) {
    return  OpenContainer(
      closedElevation: 0.0,
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 400),
      openBuilder: (context, action)  {
        return addinformationscreen(controller: controller,events: events,prefs: prefs,newevents: newevents,onpress: onpress,edit_validation: 1,pr: pr,delete: delete,);
      },
      closedBuilder: (context,action) {
        return IconButton(
            icon: Icon(Icons.edit,color: Kmain_color,),onPressed: action,);
      },
    );
  }
}
