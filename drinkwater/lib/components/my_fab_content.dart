import 'package:flutter/material.dart';

import 'my_expandable_fab.dart';

class MyFabContent extends StatelessWidget {
  String myIconImageAsset;
  String myFABContentText;
  VoidCallback myFunction;

  MyFabContent({
    Key? key,
    required this.myIconImageAsset,
    required this.myFABContentText,
    required this.myFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionButton(
          icon: Image.asset(
            myIconImageAsset,
            height: 23,
          ),
          onPressed: myFunction,
        ),
        Text(
          myFABContentText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'Marker-Felt',
          ),
        )
      ],
    );
  }
}
