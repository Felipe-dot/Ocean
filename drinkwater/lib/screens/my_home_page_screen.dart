import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../constant.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key key}) : super(key: key);

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhite,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'assets/images/menuIcon.png',
                height: 23,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: kWhite,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 5.0,
                    percent: 0.75,
                    center: Text("75%"),
                    progressColor: kDark1,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 140),
                        child: Text(
                          "ml",
                          style: TextStyle(
                            color: kMainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        "1250",
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "faltando: 750ml",
                        style: TextStyle(
                          color: kLightBlue2,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                iconSize: 80,
                icon: Icon(
                  Icons.add_circle,
                  color: kMainColor,
                ),
                color: kWhite,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        selectedIndex: _currentIndex,
        backgroundColor: kMainColor,
        showElevation: false,
        itemCornerRadius: 20,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(
              Icons.home,
              color:  kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.notifications,
              color:  kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.event_available,
              color:  kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
        ],
      ),
    );
  }
}