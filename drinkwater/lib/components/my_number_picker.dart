import 'package:drinkwater/providers/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
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
          // ignore: sdk_version_set_literal
          onChanged: (value) => setState(() => {
                _currentValue = value,
                context.read<Weight>().add(_currentValue)
              }),
        ),
        Text('KG', style: kHeadline5.copyWith(color: kMainColor)),
      ],
    );
  }
}
