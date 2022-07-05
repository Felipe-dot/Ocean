import 'package:drinkwater/constant.dart';
import 'package:flutter/material.dart';

class MyDataPointStreak extends StatelessWidget {
  const MyDataPointStreak({
    Key key,
    this.isTheWeekDayBeat,
    this.weekday,
  }) : super(key: key);

  final bool isTheWeekDayBeat;
  final String weekday;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: Image.asset(
            "assets/images/gota.png",
            color: isTheWeekDayBeat ? kMainColor : kGray,
            height: 15,
          ),
          backgroundColor:
              isTheWeekDayBeat ? kLightBlue3 : kGray.withOpacity(0.5),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          weekday,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
