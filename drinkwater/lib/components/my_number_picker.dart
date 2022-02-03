import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../constant.dart';

class MyNumberPicker extends StatefulWidget {
  const MyNumberPicker({Key key}) : super(key: key);

  @override
  _MyNumberPickerState createState() => _MyNumberPickerState();
}

class _MyNumberPickerState extends State<MyNumberPicker> {
  int _currentValue = 50;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 200,
          textStyle: kHeadline4.copyWith(color: kLightBlue2),
          selectedTextStyle: kHeadline2.copyWith(
            color: kMainColor,
          ),
          onChanged: (value) => setState(() => _currentValue = value),
        ),
        Text('KG', style: kHeadline5.copyWith(color: kMainColor)),
      ],
    );
  }
}
