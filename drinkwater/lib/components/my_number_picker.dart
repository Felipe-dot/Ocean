import 'package:drinkwater/providers/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import '../constant.dart';

class MyNumberPicker extends StatefulWidget {
  int currentValue;
  MyNumberPicker({Key? key, required this.currentValue}) : super(key: key);

  @override
  _MyNumberPickerState createState() => _MyNumberPickerState();
}

class _MyNumberPickerState extends State<MyNumberPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NumberPicker(
          value: widget.currentValue,
          minValue: 0,
          maxValue: 200,
          textStyle: kHeadline4.copyWith(color: kLightBlue2),
          selectedTextStyle: kHeadline2.copyWith(
            color: kMainColor,
          ),
          // ignore: sdk_version_set_literal
          onChanged: (value) => setState(() => {
                widget.currentValue = value,
                context.read<Weight>().add(widget.currentValue)
              }),
        ),
        Text('KG', style: kHeadline5.copyWith(color: kMainColor)),
      ],
    );
  }
}
