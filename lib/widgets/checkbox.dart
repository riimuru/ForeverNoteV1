import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  bool? checked;
  CheckBox(this.checked);

  @override
  State<CheckBox> createState() => _CheckBox();
}

class _CheckBox extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        checkColor: Colors.blue,
        value: widget.checked,
        onChanged: (bool? value) {
          setState(() {
            widget.checked = value;
          });
        });
  }
}
