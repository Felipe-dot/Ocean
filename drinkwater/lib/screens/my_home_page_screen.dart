import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/components/my_expandable_fab.dart';
import 'package:drinkwater/components/my_fab_content.dart';
import 'package:drinkwater/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constant.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key key}) : super(key: key);

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  Box<User> box;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('userBox');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  int _howMuchIsMissing() {
    int drinkStatus = box.get('drinkingWaterStatus').drinkingWaterStatus;
    int drinkGoal = box.get('drinkingWaterGoal').drinkingWaterGoal;
    return drinkGoal - drinkStatus;
  }

  double _percentageCalc() {
    int drinkStatus = box.get('drinkingWaterStatus').drinkingWaterStatus;
    int drinkGoal = box.get('drinkingWaterGoal').drinkingWaterGoal;

    double percentage = (drinkStatus * 100) / drinkGoal;
    // Aplicando regra de três
    return percentage;
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          decoration: const BoxDecoration(
            color: kWhite,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 5.0,
                    percent: _percentageCalc(),
                    center: Text(
                      "${_percentageCalc().toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: kMainColor,
                        fontSize: 25,
                      ),
                    ),
                    progressColor: kDark1,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 140),
                        child: const Text(
                          "ml",
                          style: TextStyle(
                            color: kMainColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        "${box.get('drinkingWaterStatus').drinkingWaterStatus}",
                        style: const TextStyle(
                          color: kMainColor,
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "faltando: ${_howMuchIsMissing()}",
                        style: const TextStyle(
                          color: kLightBlue2,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: kWhite,
                  image: DecorationImage(
                    alignment: Alignment.bottomCenter,
                    scale: 0.5,
                    image: AssetImage(
                      'assets/images/wave.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MyExpandableFab(
        distance: 100.0,
        children: [
          MyFabContent(
            myIconImageAsset: 'assets/images/copo.png',
            myFABContentText: '200ml',
            myFunction: () {
              int drinkStatus = box.get('drinkingWaterStatus').drinkingWaterStatus;
              box.put('drinkingWaterStatus', User(drinkingWaterStatus: drinkStatus + 200));
            },
          ),
          MyFabContent(
            myIconImageAsset: 'assets/images/garrafa.png',
            myFABContentText: '350ml',
            myFunction: () {
              int drinkStatus = box.get('drinkingWaterStatus').drinkingWaterStatus;
              box.put('drinkingWaterStatus', User(drinkingWaterStatus: drinkStatus + 350));
            },
          ),
          MyFabContent(
            myIconImageAsset: 'assets/images/jarra.png',
            myFABContentText: '700ml',
            myFunction: () {
              int drinkStatus = box.get('drinkingWaterStatus').drinkingWaterStatus;
              box.put('drinkingWaterStatus', User(drinkingWaterStatus: drinkStatus + 700));
            },
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(
        iconSize: 30,
        selectedIndex: _currentIndex,
        backgroundColor: kMainColor,
        showElevation: false,
        itemCornerRadius: 20,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(
              Icons.home,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.notifications,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.event_available,
              color: kWhite,
            ),
            activeColor: kLightBlue1,
            inactiveColor: kMainColor,
          ),
        ],
      ),
    );
  }
}
