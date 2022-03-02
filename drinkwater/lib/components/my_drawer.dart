import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage(
                    'assets/images/drawerImage.jpg',
                  ),
                  fit: BoxFit.fill),
              color: Colors.blue,
            ),
            child: Text(
              'Drink Water',
              style: TextStyle(
                color: kWhite,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Encerrar o aplicativo',
              style: TextStyle(
                color: kRedAccent,
              ),
            ),
            onTap: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
        ],
      ),
    );
  }
}
