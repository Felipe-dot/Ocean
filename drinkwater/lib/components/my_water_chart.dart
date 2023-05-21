import 'package:drinkwater/constant.dart';
import 'package:drinkwater/models/status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyWaterChart extends StatefulWidget {
  const MyWaterChart({Key? key}) : super(key: key);

  @override
  State<MyWaterChart> createState() => _MyWaterChartState();
}

class _MyWaterChartState extends State<MyWaterChart> {
  late Box<WaterStatus> waterStatusBox;
  var currentDay = DateTime.now();

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

  List<Color> gradientColors = [
    const Color(0xFF4C7AC8),
    const Color(0xFF8DA6DE),
  ];

  bool showLastSevenMonths = false;

  List<DateTime> lastSevenMonths(DateTime currentDay) {
    List<DateTime> sevenMonthsList = [];

    for (var x = 6; x >= 0; x--) {
      sevenMonthsList.add(DateTime(
        currentDay.year,
        currentDay.month - x,
        currentDay.day,
      ));
    }

    sevenMonthsList.add(DateTime.now());

    return sevenMonthsList;
  }

  List<DateTime> lastSevenDays(DateTime currentDay) {
    List<DateTime> sevenDaysList = [];

    for (var x = 6; x >= 0; x--) {
      sevenDaysList.add(DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day - x,
      ));
    }

    sevenDaysList.add(DateTime.now());

    return sevenDaysList;
  }

  List<FlSpot> dataMonthFlSpots() {
    //0% -> 10%->20% -> 30%-> 40% -> 50%->60%-> 70% ->80%->90%->100%
    // 0 -> 0.5 -> 1 -> 1.5 -> 2 -> 2.5 -> 3 -> 3.5 -> 4 -> 4.5 -> 5

    List<FlSpot> chartData = [];
    List<DateTime> sevenMonthsList = lastSevenMonths(currentDay);
    var waterStatusData = waterStatusBox.values;

    for (int x = 0; x <= 6; x++) {
      List<WaterStatus> waterData = [];
      for (var element in waterStatusData) {
        if (sevenMonthsList[x].year == element.statusDay.year &&
            sevenMonthsList[x].month == element.statusDay.month) {
          waterData.add(element);
        }
      }
      chartData.add(
        FlSpot(
            x.toDouble(),
            _percentageMonthCalc(waterData).isNaN
                ? 0
                : _percentageMonthCalc(waterData)),
      );
    }

    return chartData;
  }

  double _percentageMonthCalc(List<WaterStatus> waterStatusData) {
    double monthPercentage = 0.0;
    List<double> percentageDayList = [];
    for (var waterData in waterStatusData) {
      percentageDayList.add(_percentageWeekCalc(waterData));
    }

    for (var day in percentageDayList) {
      monthPercentage += day;
    }

    monthPercentage /= percentageDayList.length;

    return monthPercentage > 5 ? 5 : monthPercentage;
  }

  double _percentageWeekCalc(WaterStatus waterStatusData) {
    int amountOfWaterDrank = waterStatusData.amountOfWaterDrank;
    int drinkWaterGoal = waterStatusData.drinkingWaterGoal;

    double percentage = (amountOfWaterDrank * 100) / drinkWaterGoal;

    // Aplicando regra de três
    percentage = (5 * percentage) / 100;

    return percentage > 5 ? 5 : percentage;
  }

  List<FlSpot> dataWeekFlSpots() {
    List<FlSpot> chartData = [];
    List<DateTime> sevenDaysList = lastSevenDays(currentDay);
    var waterStatusData = waterStatusBox.values;
    // WaterStatus waterData;

    for (int x = 0; x <= 6; x++) {
      try {
        var waterData = waterStatusData.firstWhere(
          (element) =>
              sevenDaysList[x].day == element.statusDay.day &&
              sevenDaysList[x].month == element.statusDay.month,
        );

        chartData.add(
          FlSpot(
              x.toDouble(),
              _percentageWeekCalc(waterData).isNaN
                  ? 0
                  : _percentageWeekCalc(waterData)),
        );
      } catch (err) {
        chartData.add(FlSpot(x.toDouble(), 0));
        print(err);
      }
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.8,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xFFB2C7E6)),
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 20.0, left: 25.0, top: 24),
                child: LineChart(
                  showLastSevenMonths ? monthChartData() : sevenDaysChartData(),
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
                  showLastSevenMonths = !showLastSevenMonths;
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
      color: kMainColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(daysOfTheWeek[sevenDaysList[0].weekday]!, style: style);
        break;
      case 1:
        text = Text(daysOfTheWeek[sevenDaysList[1].weekday]!, style: style);
        break;
      case 2:
        text = Text(daysOfTheWeek[sevenDaysList[2].weekday]!, style: style);
        break;
      case 3:
        text = Text(daysOfTheWeek[sevenDaysList[3].weekday]!, style: style);
        break;
      case 4:
        text = Text(daysOfTheWeek[sevenDaysList[4].weekday]!, style: style);
        break;
      case 5:
        text = Text(daysOfTheWeek[sevenDaysList[5].weekday]!, style: style);
        break;
      case 6:
        text = Text(daysOfTheWeek[sevenDaysList[6].weekday]!, style: style);
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
      color: kMainColor,
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

  LineChartData sevenDaysChartData() {
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
          spots: dataWeekFlSpots(),
          isCurved: true,
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

  Widget yearBottomTitleWidgets(double value, TitleMeta meta) {
    Map<int, String> monthsOfTheYear = {
      1: "JAN",
      2: "FEV",
      3: "MAR",
      4: "ABR",
      5: "MAI",
      6: "JUN",
      7: "JUL",
      8: "AGO",
      9: "SET",
      10: "OUT",
      11: "NOV",
      12: "DEZ"
    };

    List<DateTime> sevenMonthsList = lastSevenMonths(currentDay);

    const style = TextStyle(
      color: kMainColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(monthsOfTheYear[sevenMonthsList[0].month]!, style: style);
        break;
      case 1:
        text = Text(monthsOfTheYear[sevenMonthsList[1].month]!, style: style);
        break;
      case 2:
        text = Text(monthsOfTheYear[sevenMonthsList[2].month]!, style: style);
        break;
      case 3:
        text = Text(monthsOfTheYear[sevenMonthsList[3].month]!, style: style);
        break;
      case 4:
        text = Text(monthsOfTheYear[sevenMonthsList[4].month]!, style: style);
        break;
      case 5:
        text = Text(monthsOfTheYear[sevenMonthsList[5].month]!, style: style);
        break;
      case 6:
        text = Text(monthsOfTheYear[sevenMonthsList[6].month]!, style: style);
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

  LineChartData monthChartData() {
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
          spots: dataMonthFlSpots(),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
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
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
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
