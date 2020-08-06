import 'package:flutter/material.dart';
import 'package:pill_reminder/constants.dart';
import 'package:pill_reminder/Components/Textfield.dart';
import 'package:pill_reminder/Components/Floating_Action_Button_for_Image.dart';
import 'package:pill_reminder/Components/Rounded_Button.dart';
import 'package:pill_reminder/Classes/Pill_Reminder.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class addinformationscreen extends StatefulWidget {
  static String id = "add_information_screen";
  final CalendarController controller;
  final Map<DateTime, List<dynamic>> events;
  final Map<DateTime, List<dynamic>> newevents;
  final SharedPreferences prefs;
  final Function onpress;
  final Function delete;
  final int edit_validation;
  List<dynamic> pr;
  addinformationscreen(
      {this.controller,
      this.events,
      this.prefs,
      this.newevents,
      this.onpress,
      this.edit_validation,
      this.pr,
      this.delete});
  @override
  _addinformationscreenState createState() => _addinformationscreenState();
}

class _addinformationscreenState extends State<addinformationscreen> {

  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TimeOfDay _timeOfDay = new TimeOfDay.now();
  String selection_repeat = "For Once Time";
  bool visible_mg_txt = true;
  bool visible_repeat_txt = true;
  int number_of_image = 1;

  final medicine_name_controller = TextEditingController();
  final number_of_taken_controller = TextEditingController();
  final number_of_dose_controller = TextEditingController();
  final time_controller = TextEditingController();
  final number_of_repeat_controller = TextEditingController();
  final duration_controller = TextEditingController();

  void increase() {
    number_of_image += 1;
    if (number_of_image > 10) number_of_image = 1;
    if (number_of_image == 6 ||
        number_of_image == 7 ||
        number_of_image == 8 ||
        number_of_image == 9 ||
        number_of_image == 10)
      visible_mg_txt = false;
    else
      visible_mg_txt = true;
  }

  void decrease() {
    number_of_image -= 1;
    if (number_of_image < 1) number_of_image = 10;
    if (number_of_image == 6 ||
        number_of_image == 7 ||
        number_of_image == 8 ||
        number_of_image == 9 ||
        number_of_image == 10)
      visible_mg_txt = false;
    else
      visible_mg_txt = true;
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newmap = {};
    map.forEach((key, value) {
      newmap[key.toString()] = map[key];
    });
    return newmap;
  }

  Future<Null> _selecttime(BuildContext context) async {
    final TimeOfDay picker = await showTimePicker(
        context: context,
        initialTime: _timeOfDay,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Kmain_color,
              accentColor: Kmain_color,
              dialogBackgroundColor: Kbackgroundcolor_timepicker,
              colorScheme: ColorScheme.light(primary: Kmain_color),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        });
    if (picker != null && picker != _timeOfDay) {
      setState(() {
        _timeOfDay = picker;
        List<String> period = _timeOfDay.period.toString().split('.');
        time_controller.text = _timeOfDay.hour.toString() +
            ':' +
            _timeOfDay.minute.toString() +
            " " +
            period[1];
      });
    }
  }

  void save_data_in_calender_day(int duration, int repeat, pill_reminder pr) {
    setState(() {
      List<dynamic> pillreminder = [];
      pillreminder.add(pr.time_of_medicine);
      pillreminder.add(pr.number_of_image);
      pillreminder.add(pr.medicine_name);
      pillreminder.add(pr.number_of_dose);
      pillreminder.add(pr.number_of_taken);
      pillreminder.add(pr.status_of_repeat);
      pillreminder.add(pr.number_of_repeat);
      pillreminder.add(pr.duration);
      for (int i = 0; i <= duration; i++) {
        if (widget.events[widget.controller.selectedDay
                .add(Duration(days: (i * repeat)))] !=
            null) {
          widget.events[widget.controller.selectedDay
                  .add(Duration(days: (i * repeat)))]
              .add(pillreminder);
        } else {
          widget.events[widget.controller.selectedDay
              .add(Duration(days: (i * repeat)))] = [pillreminder];
        }
        if (widget.newevents[widget.controller.selectedDay
                .add(Duration(days: (i * repeat)))] !=
            null) {
          widget.newevents[widget.controller.selectedDay
                  .add(Duration(days: (i * repeat)))]
              .add(pillreminder);
        } else {
          widget.newevents[widget.controller.selectedDay
              .add(Duration(days: (i * repeat)))] = [pillreminder];
        }
        widget.prefs.setString("events", json.encode(encodeMap(widget.events)));
        widget.prefs
            .setString("newevents", json.encode(encodeMap(widget.newevents)));
      }
    });
  }

  void save_data_in_calender_hour(int duration, int repeat, pill_reminder pr) {
    List<String> time = pr.time_of_medicine.split(':');
    String hour = time[0];
    List<String> time_min = time[1].split(' ');
    String min = time_min[0];

    DateTime temp = DateTime(
        widget.controller.selectedDay.year,
        widget.controller.selectedDay.month,
        widget.controller.selectedDay.day,
        int.parse(hour),
        int.parse(min),
        0,
        0);

    setState(() {
      int count = 0;
      for (int i = 0;; i++) {
        TimeOfDay time_temp = TimeOfDay(
            hour: temp.add(Duration(hours: i * repeat)).hour,
            minute: temp.add(Duration(hours: i * repeat)).minute);
        List<String> period = time_temp.period.toString().split('.');
        List<dynamic> pillreminder = [];

        pillreminder.add(temp.add(Duration(hours: i * repeat)).hour.toString() +
            ':' +
            temp.add(Duration(hours: i * repeat)).minute.toString() +
            " " +
            period[1]);
        pillreminder.add(pr.number_of_image);
        pillreminder.add(pr.medicine_name);
        pillreminder.add(pr.number_of_dose);
        pillreminder.add(pr.number_of_taken);
        pillreminder.add(pr.status_of_repeat);
        pillreminder.add(pr.number_of_repeat);
        pillreminder.add(pr.duration);
        if (temp.add(Duration(hours: i * repeat)).day !=
            widget.controller.selectedDay.add(Duration(days: count)).day) {
          count++;
        }
        if ((temp.add(Duration(hours: i * repeat)).day -
                widget.controller.selectedDay.day) ==
            duration) break;
        if (widget.events[
                widget.controller.selectedDay.add(Duration(days: count))] !=
            null) {
          widget
              .events[widget.controller.selectedDay.add(Duration(days: count))]
              .add(pillreminder);
        } else {
          widget.events[widget.controller.selectedDay
              .add(Duration(days: count))] = [pillreminder];
        }
        if (widget.newevents[
                widget.controller.selectedDay.add(Duration(days: count))] !=
            null) {
          widget.newevents[
                  widget.controller.selectedDay.add(Duration(days: count))]
              .add(pillreminder);
        } else {
          widget.newevents[widget.controller.selectedDay
              .add(Duration(days: count))] = [pillreminder];
        }

        widget.prefs.setString("events", json.encode(encodeMap(widget.events)));
        widget.prefs
            .setString("newevents", json.encode(encodeMap(widget.newevents)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (selection_repeat == "For Once Time")
        visible_repeat_txt = false;
      else
        visible_repeat_txt = true;

      if (widget.edit_validation == 1) {
        number_of_image = int.parse(widget.pr[1]);
        medicine_name_controller.text = widget.pr[2];
        number_of_taken_controller.text = widget.pr[4];
        if (int.parse(widget.pr[1])<=5)
          {
            visible_mg_txt = true;
            number_of_dose_controller.text = widget.pr[3];
          }
        else
          visible_mg_txt = false;
        time_controller.text = widget.pr[0];
        selection_repeat = widget.pr[5];
        if (selection_repeat == "For Once Time")
          visible_repeat_txt = false;
        else {
          visible_repeat_txt = true;
          number_of_repeat_controller.text = widget.pr[6];
          duration_controller.text = widget.pr[7];
        }
      }
    });
//    notification=notification_plugin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      resizeToAvoidBottomInset: false,
      backgroundColor: Kmain_color,
      body: SingleChildScrollView(
          child: Container(

            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Images/background_screen.png'),
                    fit: BoxFit.fill)),
            child: SafeArea(

                child: Form(
                  key: _formkey,
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                     Flexible(
                       flex: 2,
                       child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              fab(
                                ontab: () {
                                  setState(() {
                                    decrease();
                                  });
                                },
                                icon: Icons.chevron_left,
                              ),
                              CircleAvatar(
                                backgroundColor: Kmain_color,
                                radius: 55.0,
                                child: Image.asset('Images/meds$number_of_image.png'),
                              ),
                              fab(
                                ontab: () {
                                  setState(() {
                                    increase();
                                  });
                                },
                                icon: Icons.chevron_right,
                              )
                            ],
                          ),
                     ),
                      Flexible(
                        child: text_field(
                          hint_text: 'Medicine Name',
                          controller: medicine_name_controller,
                          enable_status: true,
                          textinput_type: TextInputType.text,
                          validate: (String value)
                          {
                            if (value.isEmpty)
                              return "! Medicine Name is Required";
                          },
                        ),
                      ),
                      Flexible(
                        child: text_field(
                          hint_text: 'Number of Taken',
                          controller: number_of_taken_controller,
                          enable_status: true,
                          textinput_type: TextInputType.number,
                          validate: (String value)
                          {
                            if (value.isEmpty)
                              return "! Number of Taken is Required";
                          },
                        ),
                      ),
                      Flexible(
                        child: Visibility(
                          visible: visible_mg_txt,
                          child: text_field(
                            hint_text: 'Number of Dose in mg',
                            controller: number_of_dose_controller,
                            enable_status: true,
                            textinput_type: TextInputType.number,
                          validate: (String value)
                          {
                            if (value.isEmpty && number_of_image<6)
                              return "! Number of Dose is Required";
                          },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: text_field(
                                hint_text: 'Choose your Time ➡',
                                controller: time_controller,
                                enable_status: false,
                                validate: (String value)
                                {
                                  if (value.isEmpty)
                                    return "! Time is Required";
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 40.0, bottom: 25.0),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.access_time,
                                    color: Ksecond_color,
                                    size: 60.0,
                                  ),
                                  onPressed: () {
                                    _selecttime(context);
                                  }),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Ksecond_color,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 9.0),
                            child: DropdownButton<String>(
                              style: TextStyle(
                                color: Kmain_color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              value: selection_repeat,
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('For Once Time'),
                                  value: 'For Once Time',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('For Every Number Of Hour'),
                                  value: 'For Every Number Of Hour',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('For Every Number Of Day'),
                                  value: 'For Every Number Of Day',
                                ),
//                      DropdownMenuItem<String>(child: Text('For Every Number Of Week'),value: 'For Every Number Of Week',),
                              ],
                              onChanged: (String val) {
                                setState(() {
                                  selection_repeat = val;
                                  if (selection_repeat == "For Once Time")
                                    visible_repeat_txt = false;
                                  else
                                    visible_repeat_txt = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      Flexible(
                        child: Visibility(
                          visible: visible_repeat_txt,
                          child: text_field(
                            hint_text:selection_repeat == "For Every Number Of Day"
                                ? Krepeat_week_hint_txt
                                : Krepeat_day_hint_txt,
                            controller: number_of_repeat_controller,
                            enable_status: true,
                            textinput_type: TextInputType.number,
                            validate: (String value)
                            {
                              if (value.isEmpty && selection_repeat !="For Once Time")
                                return "! Number of Repeat is Required";
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Visibility(
                          visible: visible_repeat_txt,
                          child: text_field(
                            hint_text: selection_repeat == "For Every Number Of Day"
                                ? Kduration_week_hint_txt
                                : Kduration_day_hint_txt,
                            controller: duration_controller,
                            enable_status: true,
                            textinput_type: TextInputType.number,
                            validate: (String value)
                            {
                              if (value.isEmpty && selection_repeat !="For Once Time")
                                return "! Duration is Required";
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            rounded_button(
                              color: Colors.red,
                              TextName: "Close",
                              OnPressed: () {
                                widget.onpress();
                                Navigator.pop(context);
                              },
                            ),
                            rounded_button(
                              color: Colors.green,
                              TextName: "Add",
                              OnPressed: () {
                                if (!_formkey.currentState.validate())
                                  {
                                    return;
                                  }

                                pill_reminder pr = pill_reminder(
                                    number_of_image: number_of_image.toString(),
                                    medicine_name: medicine_name_controller.text,
                                    number_of_taken: number_of_taken_controller.text,
                                    number_of_dose: number_of_dose_controller.text,
                                    time_of_medicine: time_controller.text,
                                    status_of_repeat: selection_repeat,
                                    number_of_repeat: number_of_repeat_controller.text,
                                    duration: duration_controller.text);
                                if (pr.status_of_repeat == 'For Once Time')
                                  save_data_in_calender_day(0, 0, pr);
                                else if (pr.status_of_repeat ==
                                    'For Every Number Of Day') {
                                  int count = 0;
                                  int duration = int.parse(pr.duration) * 7;
                                  int repeat = int.parse(pr.number_of_repeat);
                                  for (int i = 0; duration >= repeat; i++) {
                                    count++;
                                    duration -= repeat;
                                  }
                                  save_data_in_calender_day(count, repeat, pr);
                                } else if (pr.status_of_repeat ==
                                    "For Every Number Of Hour") {
                                  save_data_in_calender_hour(int.parse(pr.duration),
                                      int.parse(pr.number_of_repeat), pr);
                                }
                                if (widget.edit_validation == 1)
                                  {
                                    widget.delete();
                                  }
                                widget.onpress();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ),
          ),
      ),
    );
  }
}
