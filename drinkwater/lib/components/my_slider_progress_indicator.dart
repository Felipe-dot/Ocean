import 'package:drinkwater/components/my_progress_indicator_circle.dart';
import 'package:flutter/material.dart';

class MySliderProgressIndicator extends StatelessWidget {
  final int current;
  const MySliderProgressIndicator({Key? key, required this.current})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyProgressIndicatorCircle(
            order: 0,
            currentPage: current,
          ),
          MyProgressIndicatorCircle(
            order: 1,
            currentPage: current,
          ),
          MyProgressIndicatorCircle(
            order: 2,
            currentPage: current,
          ),
        ],
      ),
    );
  }
}
