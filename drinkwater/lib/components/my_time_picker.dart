import 'package:drinkwater/constant.dart';
import 'package:drinkwater/providers/wake_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class MyTimePicker extends StatefulWidget {
  const MyTimePicker({Key key}) : super(key: key);

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  NumberFormat formatter = NumberFormat('00');

  TimeOfDay time = const TimeOfDay(hour: 00, minute: 00);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: kHeadline2.copyWith(color: kMainColor),
      ),
      onPressed: () async {
        TimeOfDay newTime =
            await showTimePicker(context: context, initialTime: time);
        if (newTime != null) {
          setState(() {
            time = newTime;
            context.read<WakeUp>().add(time);
          });
        }
      },
      child: Text(
          '${formatter.format(time.hour).toString()}:${formatter.format(time.minute).toString()}'),
    );
  }
}
