import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pill_reminder/Animations/Opencontainer_Animation.dart';
import 'package:pill_reminder/Animations/Opencontainer_Edit_Animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pill_reminder/Components/Calender.dart';
import 'package:pill_reminder/constants.dart';
import 'package:pill_reminder/Components/Card_Widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pill_reminder/Components/Rounded_Button.dart';

class welcomescreen extends StatefulWidget {
  static String id = "welcome_screen";
  @override
  _welcomescreenState createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<dynamic>> _newevents;
  List<dynamic> _selected_events;
  List<dynamic> _selected_newevents;
  SharedPreferences prefs;
  List<dynamic> pillreminder;
  bool run_function;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selected_events = [];
    _newevents = {};
    _selected_newevents = [];
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationsettingandroid =
        AndroidInitializationSettings('app_icon');
    final initializationsettingios = IOSInitializationSettings();
    final initializationsetting = InitializationSettings(
        initializationsettingandroid, initializationsettingios);
    _flutterLocalNotificationsPlugin.initialize(
      initializationsetting,
      onSelectNotification: onselectnotification,
    );
    run_function = true;
  }

  Future onselectnotification(String payload) async {
    await showmodelbottomsheet(context, pillreminder, 2, payload,_controller.selectedDay);
  }

  Future<void> showweeklyatdayandtime(
      DateTime scheduledDate, int id, List<dynamic> pr) async {
    AndroidNotificationDetails androidplatformchannelspecifies =
        AndroidNotificationDetails('show weekly channel id',
            'show weekly channel namr', 'show weekly description',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');
    IOSNotificationDetails iosplatformchannelspecifies =
        IOSNotificationDetails();
    NotificationDetails platformchannelspecifies = NotificationDetails(
        androidplatformchannelspecifies, iosplatformchannelspecifies);
    String pay = pr[0] +
        "/" +
        pr[1] +
        "/" +
        pr[2] +
        "/" +
        pr[3] +
        "/" +
        pr[4] +
        "/" +
        pr[5] +
        "/" +
        pr[6] +
        "/" +
        pr[7];
    pillreminder = pr;
    await _flutterLocalNotificationsPlugin.schedule(id, pr[2],
        "It Is Time To Take Your Meds", scheduledDate, platformchannelspecifies,
        payload: pay);
  }

  Future canelnotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  initprefs() async {
    prefs = await SharedPreferences.getInstance();
    DateTime t = DateTime.now();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
      _events.forEach((key, value) {
        if (t.day == key.day && t.month == key.month && t.year == key.year) {
          _selected_events = _events[key];
        }
      });
      _newevents = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("newevents") ?? "{}")));
      _newevents.forEach((key, value) {
        String year = key.year.toString();
        String month = key.month.toString();
        String day = key.day.toString();
        _selected_newevents = _newevents[key];
        for (int i = 0; i < _selected_newevents.length; i++) {
          List<String> time = _selected_newevents[i][0].split(':');
          String hour = time[0];
          List<String> time_min = time[1].split(' ');
          String min = time_min[0];
          DateTime t = DateTime(int.parse(year), int.parse(month),
              int.parse(day), int.parse(hour), int.parse(min), 0, 0);
          String id = month + day + hour + min + _selected_newevents[i][1];
          showweeklyatdayandtime(t, int.parse(id), _selected_newevents[i]);
        }
        _newevents[key] = [];
      });
      prefs.setString("newevents", json.encode(encodeMap(_newevents)));
    });
  }

  Widget listview_for_meds() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _selected_events.length,
          itemBuilder: (BuildContext context, int pos) {
            return GestureDetector(
              onTap: () {
                showmodelbottomsheet(context, _selected_events[pos], 1, " ",null);
              },
              child: Card(
                  color: Ksecond_color,
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  elevation: 10.0,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Ksecond_color)),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _selected_events[pos][0],
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                            flex: 1,
                            child: Image.asset(
                                'Images/meds${_selected_events[pos][1]}.png')),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Text(
                                _selected_events[pos][2],
                                style: TextStyle(
                                    color: Kmain_color,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              int.parse(_selected_events[pos][1]) <= 5
                                  ? Column(
                                    children: <Widget>[
                                      Text(
                                          _selected_events[pos][3] +
                                              ' mg',
                                          style: TextStyle(
                                              color: Kmain_color, fontSize: 15.0),
                                        ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                       'Takes ' +
                                            _selected_events[pos][4],
                                        style: TextStyle(
                                            color: Kmain_color, fontSize: 15.0),
                                      ),
                                    ],
                                  )
                                  : Text(
                                      'Takes ' + _selected_events[pos][4],
                                      style: TextStyle(
                                          color: Kmain_color, fontSize: 15.0),
                                    ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            opencontaineredit(
                              prefs: prefs,
                              newevents: _newevents,
                              events: _events,
                              controller: _controller,
                              onpress: () {
                                setState(() {
                                  run_function = true;
                                });
                              },
                              delete: () {
                               Delete_med_in_listview(_selected_events[pos]);
                              },
                              pr: _selected_events[pos],
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                        "Delete ?",
                                        style: TextStyle(
                                            color: Kmain_color,
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Text(
                                        "Do You Want To Delete Your Med ?",
                                        style: TextStyle(
                                            color: Kmain_color, fontSize: 20.0),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Delete_med_in_listview(_selected_events[pos]);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Kmain_color,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Kmain_color,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                      elevation: 24.0,
                                      backgroundColor: Ksecond_color,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          borderSide:
                                              BorderSide(color: Ksecond_color)),
                                    ),
                                    barrierDismissible: false,
                                  );
                                })
                          ],
                        )
                      ],
                    ),
                  )),
            );
          }),
    );
  }

  void Delete_med_in_listview(List<dynamic> pr) {
    setState(() {
      //  List<dynamic> pr=_selected_events[pos];
      Map<DateTime, List<dynamic>> newevents = {};
      _events.forEach((key, value) {
        List<dynamic> total_event_for_selectedday = value;
        List<dynamic> total_newevent_for_selectedday=_newevents[key];
        bool found;
        int count = 0;
        for (int i = 0; i < total_event_for_selectedday.length; i++) {
          found=total_newevent_for_selectedday.contains(total_event_for_selectedday[i]);
          if (pr[1] == total_event_for_selectedday[i][1] &&
              pr[2] == total_event_for_selectedday[i][2] &&
              pr[3] == total_event_for_selectedday[i][3] &&
              pr[4] == total_event_for_selectedday[i][4]&&
              pr[5] == total_event_for_selectedday[i][5]&&
              pr[6] == total_event_for_selectedday[i][6]&&
              pr[7] == total_event_for_selectedday[i][7] && found==false) {
            String month = key.month.toString();
            String day = key.day.toString();
            List<String> time = total_event_for_selectedday[i][0].split(':');
            String hour = time[0];
            List<String> time_min = time[1].split(' ');
            String min = time_min[0];
            String id = month + day + hour + min + pr[1];
            canelnotification(int.parse(id));
            count++;
          } else {
            if (newevents[key] == null) {
              newevents[key] = [total_event_for_selectedday[i]];
            } else {
              newevents[key].add(total_event_for_selectedday[i]);
            }
          }
        }
        if (count == total_event_for_selectedday.length) {
          newevents[key] = [];
        }
      });
      run_function = true;
      prefs.setString("events", json.encode(encodeMap(newevents)));
    });
  }

  showmodelbottomsheet(
      BuildContext context, List<dynamic> pr, int visible, String payload,DateTime datetime) {
    if (payload != " ") {
      pr = payload.split("/");
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Ksecond_color,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50.0),
                    topLeft: Radius.circular(50.0))),
            child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  pr[2],
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Kmain_color,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                int.parse(pr[1]) <= 5
                    ? Text(
                        pr[3] + ' mg, Takes ' + pr[4],
                        style: TextStyle(color: Kmain_color, fontSize: 15.0),
                      )
                    : Text(
                        'Takes ' + pr[4],
                        style: TextStyle(color: Kmain_color, fontSize: 15.0),
                      ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('Images/meds${pr[1]}.png'),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 40.0,
                      color: Kmain_color,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      pr[0],
                      style: TextStyle(fontSize: 20.0, color: Kmain_color),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      size: 40.0,
                      color: Kmain_color,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      pr[5],
                      style: TextStyle(fontSize: 20.0, color: Kmain_color),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                pr[5] == 'For Every Number Of Hour'
                    ? Text(
                        'Repeat ' +
                            pr[6] +
                            ' Times, Duration ' +
                            pr[7] +
                            ' Days',
                        style: TextStyle(fontSize: 20.0, color: Kmain_color),
                      )
                    : Visibility(visible: false, child: Container()),
                pr[5] == 'For Every Number Of Day'
                    ? Text(
                        'Repeat ' +
                            pr[6] +
                            ' Times, Duration ' +
                            pr[7] +
                            ' Weeks',
                        style: TextStyle(fontSize: 20.0, color: Kmain_color),
                      )
                    : Visibility(visible: false, child: Container()),
                SizedBox(
                  height: 15.0,
                ),
                visible == 1
                    ? rounded_button(
                        color: Colors.red,
                        TextName: 'Close',
                        OnPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          rounded_button(
                            color: Colors.red,
                            TextName: 'Skipped',
                            OnPressed: () {
                              setState(() {
                                List<dynamic> selected_event=_events[datetime];
                                int pos = 0;
                                for (int i = 0;
                                    i < selected_event.length;
                                    i++) {
                                  if (selected_event[i][0] == pr[0] &&selected_event[i][1] == pr[1] &&selected_event[i][2] == pr[2] &&selected_event[i][3] == pr[3] &&selected_event[i][4] == pr[4] &&selected_event[i][5] == pr[5] &&selected_event[i][6] == pr[6] &&selected_event[i][7] == pr[7]) {
                                    pos = i;
                                    break;
                                  }
                                }
                                selected_event.removeAt(pos);
                                Map<DateTime, List<dynamic>> newevents = _events;
                                newevents[datetime] =
                                    selected_event;
                                prefs.setString("events",
                                    json.encode(encodeMap(newevents)));
                                Navigator.pop(context);
                              });
                            },
                          ),
                          rounded_button(
                            color: Colors.green,
                            TextName: 'Taken',
                            OnPressed: () {
                              setState(() {
                                List<dynamic> selected_event=_events[datetime];
                                int pos = 0;
                                for (int i = 0;
                                i < selected_event.length;
                                i++) {
                                  if (selected_event[i][0] == pr[0] &&selected_event[i][1] == pr[1] &&selected_event[i][2] == pr[2] &&selected_event[i][3] == pr[3] &&selected_event[i][4] == pr[4] &&selected_event[i][5] == pr[5] &&selected_event[i][6] == pr[6] &&selected_event[i][7] == pr[7]) {
                                    pos = i;
                                    break;
                                  }
                                }
                                selected_event.removeAt(pos);
                                Map<DateTime, List<dynamic>> newevents = _events;
                                newevents[datetime] =
                                    selected_event;
                                prefs.setString("events",
                                    json.encode(encodeMap(newevents)));
                                Navigator.pop(context);
                              });
                            },
                          )
                        ],
                      ),
              ],
            ),
          );
        });
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newmap = {};
    map.forEach((key, value) {
      newmap[DateTime.parse(key)] = map[key];
    });
    return newmap;
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newmap = {};
    map.forEach((key, value) {
      newmap[key.toString()] = map[key];
    });
    return newmap;
  }

  @override
  Widget build(BuildContext context) {
    if (run_function) {
      run_function = false;
      initprefs();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Kmain_color,
        appBar: AppBar(
          title: Text("Pill Reminder"),
          centerTitle: true,
          backgroundColor: Kmain_color,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ),
        floatingActionButton: opencontainer(
          controller: _controller,
          events: _events,
          prefs: prefs,
          newevents: _newevents,
          onpress: () {
            setState(() {
              run_function = true;
            });
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            calenderwidget(
              controller: _controller,
              events: _events,
              onday: (date, events) {
                setState(() {
                  _selected_events = events;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: card_widget(
                  color: Colors.grey[100],
                  elevation: 15.0,
                  shapeBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      borderSide: BorderSide(color: Ksecond_color)),
                  child_card: _selected_events.length == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Image.asset(
                            'Images/empty_events.png',
                          ),
                        )
                      : listview_for_meds()),
            ),
          ],
        ),
      ),
    );
  }
}
