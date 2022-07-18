import 'package:drinkwater/constant.dart';
import 'package:drinkwater/providers/sleep_time_provider.dart';
import 'package:drinkwater/providers/wake_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class MyTimePicker extends StatefulWidget {
  final bool isSleepTime;
  const MyTimePicker({Key? key, required this.isSleepTime}) : super(key: key);

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
        TimeOfDay? newTime =
            await showTimePicker(context: context, initialTime: time);
        if (newTime != null) {
          if (widget.isSleepTime == true) {
            setState(() {
              time = newTime;
              context.read<Sleep>().add(time);
            });
          } else {
            setState(() {
              time = newTime;
              context.read<WakeUp>().add(time);
            });
          }
        }
      },
      child: Text(
          '${formatter.format(time.hour).toString()}:${formatter.format(time.minute).toString()}'),
    );
  }
}
