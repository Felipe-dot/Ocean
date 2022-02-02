import 'package:flutter/material.dart';

class MyTimePicker extends StatefulWidget {
  const MyTimePicker({ Key key }) : super(key: key);

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  TimeOfDay time = const TimeOfDay(hour: 00, minute: 00);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 30),
      ),
      onPressed: () async {
        TimeOfDay newTime = await showTimePicker(context: context, initialTime: time);
        if(newTime != null) {
          setState(() {
            time = newTime;
          });
        }
      },
      child: Text('${time.hour.toString()}:${time.minute.toString()}'),
    );
  }
}