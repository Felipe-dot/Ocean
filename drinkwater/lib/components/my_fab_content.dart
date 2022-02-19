import 'package:flutter/material.dart';

import 'my_expandable_fab.dart';

class MyFabContent extends StatelessWidget {
  String myIconImageAsset;
  String myFABContentText;

  MyFabContent({Key key, this.myIconImageAsset, this.myFABContentText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionButton(
          icon: Image.asset(
            myIconImageAsset,
            height: 23,
          ),
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
