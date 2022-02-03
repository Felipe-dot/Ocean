import 'package:drinkwater/constant.dart';
import 'package:flutter/material.dart';

class MyProgressIndicatorCircle extends StatelessWidget {
  final int currentPage;
  final int order;
  const MyProgressIndicatorCircle({Key key, this.order, this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: currentPage == order ? 70 : 10,
      decoration: BoxDecoration(
        color: currentPage == order ? kLightBlue1 : kLightBlue3,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
