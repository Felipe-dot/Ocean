import 'package:flutter/material.dart';

class MyCtaWithIconRight extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final IconData icon;
  final Color background;
  final TextStyle textStyle;
  final Function() function;

  const MyCtaWithIconRight({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.function,
    required this.icon,
    required this.background,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0.0),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(width, height),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(background),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: function,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: textStyle,
              ),
            ),
          ),
          Icon(
            icon,
            size: height / 2,
            color: textStyle.color,
          ),
        ],
      ),
    );
  }
}
