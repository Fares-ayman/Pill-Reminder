import 'package:flutter/material.dart';
import 'package:pill_reminder/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Card_Widget.dart';

class calenderwidget extends StatelessWidget {
  final CalendarController controller;
   final Map<DateTime,List<dynamic>> events;
   final Function onday;
  calenderwidget({this.controller,this.events,this.onday});
  @override
  Widget build(BuildContext context) {
    return card_widget(
        color: Ksecond_color,
        elevation: 15.0,
        shapeBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Ksecond_color)),
          child_card:TableCalendar(
            events: events,
              initialCalendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: Kcalender_headersstyle,
              onDaySelected:onday,
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) =>
                    Container(
                      margin: EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: Kcalender_selectedday_decoration,
                      child: Text(date.day.toString(),style: Kcalender_selectedday_textstyle,),
                    ),
                todayDayBuilder: (context, date, events) =>
                    Container(
                      margin: EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: Kcalender_today_decoration,
                      child: Text(date.day.toString(),style: Kcalender_today_textstyle,),
                    ),
              ),
              calendarController: controller),
        );
  }
}
