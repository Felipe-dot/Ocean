import 'package:drinkwater/constant.dart';
import 'package:flutter/material.dart';

class MyWeekendStreak extends StatelessWidget {
  const MyWeekendStreak({
    Key key,
    this.isTheWeekDayBeat,
    this.weekday,
    this.isData,
  }) : super(key: key);

  final bool isTheWeekDayBeat;
  final bool isData;
  final String weekday;

  @override
  Widget build(BuildContext context) {
    return isData
        ? Column(
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
          )
        : Column(
            children: [
              CircleAvatar(
                backgroundColor: kMainColor.withOpacity(0.1),
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
