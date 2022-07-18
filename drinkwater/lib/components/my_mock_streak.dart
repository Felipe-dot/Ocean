import 'package:flutter/material.dart';

import '../constant.dart';

class MyMockStreak extends StatelessWidget {
  const MyMockStreak({Key? key, required this.weekday}) : super(key: key);

  final String weekday;

  @override
  Widget build(BuildContext context) {
    return Column(
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
