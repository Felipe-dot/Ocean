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
    return Column(
      children: <Widget>[
        NumberPicker(
          value: _currentValue,
          minValue: 0,
          maxValue: 200,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
        Text(
          'KG: $_currentValue',
          style: const TextStyle(
            fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kMainColor,
          ),
          ),
      ],
    );
  }
}