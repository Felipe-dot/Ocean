import 'package:drinkwater/constant.dart';
import 'package:drinkwater/providers/sleep_time_provider.dart';
import 'package:drinkwater/providers/wake_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class MyTimePicker extends StatefulWidget {
  final bool isSleepTime;
  TimeOfDay time;
  MyTimePicker({Key? key, required this.isSleepTime, required this.time})
      : super(key: key);

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  NumberFormat formatter = NumberFormat('00');

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: kHeadline2.copyWith(color: kMainColor),
      ),
      onPressed: () async {
        TimeOfDay? newTime =
            await showTimePicker(context: context, initialTime: widget.time);
        if (newTime != null) {
          if (widget.isSleepTime == true) {
            setState(() {
              widget.time = newTime;
              context.read<Sleep>().add(widget.time);
            });
          } else {
            setState(() {
              widget.time = newTime;
              context.read<WakeUp>().add(widget.time);
            });
          }
        }
      },
      child: Text(
          '${formatter.format(widget.time.hour).toString()}:${formatter.format(widget.time.minute).toString()}'),
    );
  }
}
