import 'package:flutter/material.dart';
import 'package:pill_reminder/constants.dart';

class text_field extends StatelessWidget {
  final String hint_text;
  final TextEditingController controller;
  final bool enable_status;
  var textinput_type;
  final Function validate;
  text_field({this.hint_text,this.controller,this.enable_status,this.textinput_type,this.validate});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        validator:validate ,
        keyboardType: textinput_type,
        enabled: enable_status,
        controller: controller,
        style: TextStyle(color: Kmain_color,fontWeight: FontWeight.bold,fontSize: 20.0),
        decoration: KTextfielddiceoration.copyWith(
            hintText:hint_text,
        ),
      ),
    );
  }
}
