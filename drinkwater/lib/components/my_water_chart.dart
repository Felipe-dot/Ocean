import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyWaterChart extends StatefulWidget {
  const MyWaterChart({Key key}) : super(key: key);

  @override
  State<MyWaterChart> createState() => _MyWaterChartState();
}

class _MyWaterChartState extends State<MyWaterChart> {
  List<Color> gradientColors = [
    const Color(0xFF4C7AC8),
    const Color(0xFF8DA6DE),
  ];

  bool showAvg = false;

  var currentDay = DateTime.now();

  List<DateTime> lastSevenDays(DateTime currentDay) {
    List<DateTime> lastSevenDays = [];

    for (var x = 6; x >= 0; x--) {
      lastSevenDays.add(DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day - x,
      ));
    }

    lastSevenDays.add(DateTime.now());

    return lastSevenDays;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xFFB2C7E6)),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 20.0, left: 25.0, top: 24, bottom: 6),
                child: LineChart(
                  showAvg ? avgData() : mainData(),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 34,
            child: IconButton(
              icon: const Icon(Icons.replay_outlined),
              color: Colors.white.withOpacity(0.7),
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Map<int, String> daysOfTheWeek = {
      1: "SEG",
      2: "TER",
      3: "QUA",
      4: "QUI",
      5: "SEX",
      6: "SÁB",
      7: "DOM",
    };

    List<DateTime> sevenDaysList = lastSevenDays(currentDay);

    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(daysOfTheWeek[sevenDaysList[0].weekday], style: style);
        break;
      case 1:
        text = Text(daysOfTheWeek[sevenDaysList[1].weekday], style: style);
        break;
      case 2:
        text = Text(daysOfTheWeek[sevenDaysList[2].weekday], style: style);
        break;
      case 3:
        text = Text(daysOfTheWeek[sevenDaysList[3].weekday], style: style);
        break;
      case 4:
        text = Text(daysOfTheWeek[sevenDaysList[4].weekday], style: style);
        break;
      case 5:
        text = Text(daysOfTheWeek[sevenDaysList[5].weekday], style: style);
        break;
      case 6:
        text = Text(daysOfTheWeek[sevenDaysList[6].weekday], style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 1:
        text = '20%';
        break;
      case 2:
        text = '40%';
        break;
      case 3:
        text = '60%';
        break;
      case 4:
        text = '80%';
        break;
      case 5:
        text = '100%';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 2)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(1, 2.5),
            FlSpot(2, 4.5),
            FlSpot(3, 3.3),
            FlSpot(4, 5.2),
            FlSpot(5, 1.2),
            FlSpot(6, 3.5),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: yearBottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.70),
            FlSpot(1, 1.70),
            FlSpot(2, 5.70),
            FlSpot(3, 4.30),
            FlSpot(4, 2.44),
            FlSpot(5, 3.54),
            FlSpot(6, 4.44),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2),
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)
                    .withOpacity(0.1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}

Widget yearBottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff68737d),
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('ABR', style: style);
      break;
    case 1:
      text = const Text('MAI', style: style);
      break;
    case 2:
      text = const Text('JUN', style: style);
      break;
    case 3:
      text = const Text('JUL', style: style);
      break;
    case 4:
      text = const Text('AGO', style: style);
      break;
    case 5:
      text = const Text('SET', style: style);
      break;
    case 6:
      text = const Text('OUT', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8.0,
    child: text,
  );
}
