import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

const Kmain_color=Color(0xFF026d88);

const Ksecond_color=Colors.white;

const Kbackgroundcolor_timepicker=Color(0xFF1D1E33);

const Kcalender_headersstyle=HeaderStyle(
  centerHeaderTitle: true,
  formatButtonDecoration: BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.all(Radius.circular(20.0))),
  formatButtonTextStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Ksecond_color,
  ),
  formatButtonShowsNext: false,
);

const Kcalender_selectedday_decoration=BoxDecoration(color: Kmain_color,borderRadius: BorderRadius.all(Radius.circular(10.0)));

const Kcalender_selectedday_textstyle=TextStyle(color: Ksecond_color , fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const Kcalender_today_decoration=BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.all(Radius.circular(10.0)));

const Kcalender_today_textstyle=TextStyle(color: Ksecond_color, fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const KTextfielddiceoration=InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: 'Enter Valueُ',
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0)),borderSide: BorderSide.none),
  errorStyle: TextStyle(fontWeight: FontWeight.bold,height: 0.4,color: Colors.red),
);

const Kduration_day_hint_txt = 'Duration Of Days';
const Kduration_week_hint_txt = 'Duration Of Weeks';
const Krepeat_day_hint_txt = 'Number of Repeat (Per Hour)';
const Krepeat_week_hint_txt = 'Number of Repeat (Per Day)';