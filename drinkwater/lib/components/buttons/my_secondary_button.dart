import 'package:flutter/material.dart';

class MySecondaryButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final TextStyle textStyle;
  final Function() function;

  const MySecondaryButton({
    Key key,
    this.width,
    this.height,
    this.text,
    this.function,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          fixedSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            width: 2,
            color: textStyle.color,
          )),
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: textStyle,
      ),
    );
  }
}
