import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pill_reminder/constants.dart';
import 'package:pill_reminder/Screens/Add_information_Screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class opencontainer extends StatelessWidget {
  final CalendarController controller;
  final Map<DateTime,List<dynamic>> events;
  final Map<DateTime,List<dynamic>> newevents;
  final SharedPreferences prefs;
  final Function onpress;
  opencontainer({this.controller,this.events,this.prefs,this.newevents,this.onpress});
  @override
  Widget build(BuildContext context) {
    return  OpenContainer(
      closedColor: Kmain_color,
      closedElevation: 10.0,
      closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),

      ),
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 400),
      openBuilder: (context, action)  {
        return addinformationscreen(controller: controller,events: events,prefs: prefs,newevents: newevents,onpress: onpress,edit_validation: 0,);
      },
      closedBuilder: (context,action) {
        return FloatingActionButton(
          onPressed: action,
          backgroundColor: Kmain_color,
          foregroundColor: Ksecond_color,
          child: Icon(Icons.add_alarm),
        );
      },
    );
  }
}
