import 'package:flutter/material.dart';

import '../../constant.dart';

class MyCta extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final Color background;
  final TextStyle textStyle;
  final Function() function;
  const MyCta({
    Key key,
    this.width,
    this.height,
    this.text,
    this.function,
    this.background,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(width, height),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(kWhite),
        backgroundColor: MaterialStateProperty.all<Color>(background),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: function,
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: textStyle,
        ),
      ),
    );
  }
}
