import 'package:drinkwater/components/my_bottom_nav_bar.dart';
import 'package:drinkwater/models/status.dart';
import 'package:drinkwater/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constant.dart';

class MyChartScreen extends StatefulWidget {
  const MyChartScreen({Key key}) : super(key: key);

  @override
  State<MyChartScreen> createState() => _MyChartScreenState();
}

class _MyChartScreenState extends State<MyChartScreen> {
  Box<WaterStatus> waterStatusBox;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    waterStatusBox = Hive.box('statusBox');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    int _currentIndex = args;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  'Dia ${waterStatusBox.get('waterStatusData').waterStatusData.map((value) => value.statusDay.day)} ',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Qtd Bebida ${waterStatusBox.get('waterStatusData').waterStatusData.map((value) => value.amountOfWaterDrank)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Meta Batida? ${waterStatusBox.get('waterStatusData').waterStatusData.map((value) => value.goalOfTheDayWasBeat)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        iconSize: 30,
        selectedIndex: _currentIndex,
        backgroundColor: kMainColor,
        showElevation: false,
        itemCornerRadius: 20,
        curve: Curves.easeIn,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          switch (_currentIndex) {
            case 0:
              {
                Navigator.pushNamed(context, '/myHomePage');
                break;
              }
            case 1:
              {
                Navigator.pushNamed(context, '/myAvailableSoonScreen',
                    arguments: _currentIndex);
                break;
              }
            case 2:
              {
                break;
              }
            default:
              {
                Navigator.pushNamed(context, '/myAvailableSoonScreen',
                    arguments: _currentIndex);
              }
          }
        },
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
