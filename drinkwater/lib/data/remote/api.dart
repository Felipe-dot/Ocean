import 'package:dio/dio.dart';

class Api {
  Future<String> signUp(email, password) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/sign-up",
        data: {"email": email, "password": password});

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return 'Erro ao cadastrar usuário';
    }
  }

  Future<dynamic> login(email, password) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['Content-Type'] = ' application/json';

    response = await dio.post(
        "https://parseapi.back4app.com/parse/functions/login",
        data: {"email": email, "password": password});

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return response.statusMessage;
    }
  }

  Future<dynamic> logout(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/logout",
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> createUserData(
      String? userToken,
      int waterIntakeGoal,
      DateTime wakeUpTime,
      DateTime sleepTime,
      int userWeight,
      List<DateTime> notificationTimeList) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    List<String> notificationTimeListToString = [];

    notificationTimeList
        .forEach((v) => notificationTimeListToString.add(v.toIso8601String()));

    try {
      response = await dio.post(
          "https://parseapi.back4app.com/parse/functions/create-userData",
          data: {
            "waterIntakeGoal": waterIntakeGoal,
            "wakeUpTime": wakeUpTime.toIso8601String(),
            "sleepTime": sleepTime.toIso8601String(),
            "userWeight": userWeight,
            "notificationTimeList": notificationTimeListToString
          });
    } catch (e) {
      print("meu erro e $e");
      return e;
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> getUserData(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/get-userData",
    );

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return response.statusCode;
    }
  }

  Future<dynamic> getCurrentUser(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/get-current-user",
    );

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return response.statusCode;
    }
  }

  Future<dynamic> validateToken(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/validate-token",
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response.statusCode;
    }
  }

  Future<dynamic> changeUserWeight(String? userToken, int newWeight) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-userWeight",
      data: {"userWeight": newWeight},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> changeWakeUpTime(
      String? userToken, String newWakeUpTime) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-wakeUpTime",
      data: {"wakeUpTime": newWakeUpTime},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> changeSleepTime(
      String? userToken, String newSleepTime) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-sleepTime",
      data: {"sleepTime": newSleepTime},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> changeWaterIntakeGoal(
      String? userToken, int newWaterIntakeGoal) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-waterIntakeGoal",
      data: {"waterIntakeGoal": newWaterIntakeGoal},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> changeNotificationTimeList(
      String? userToken, List<DateTime> newNotificationTimeList) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    List<String> notificationTimeListToString = [];

    newNotificationTimeList
        .forEach((v) => notificationTimeListToString.add(v.toIso8601String()));

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-notificationTimeList",
      data: {"notificationTimeList": notificationTimeListToString},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> createWaterHistory(
    String? userToken,
    DateTime statusDay,
    bool goalOfTheDayWasBeat,
    int amountOfWaterDrank,
    int drinkFrequency,
  ) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    try {
      response = await dio.post(
          "https://parseapi.back4app.com/parse/functions/create-waterHistory",
          data: {
            "statusDay": statusDay.toIso8601String(),
            "amountOfWaterDrank": amountOfWaterDrank,
            "goalOfTheDayWasBeat": goalOfTheDayWasBeat,
            "drinkFrequency": drinkFrequency,
          });
    } catch (e) {
      print("meu erro e $e");
      return e;
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> getWaterHistory(String? userToken) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/get-waterHistory",
    );

    if (response.statusCode == 200) {
      return response.data['result'];
    } else {
      return response.statusCode;
    }
  }

  Future<dynamic> changeGoalOfTheDayWasBeat(
      String? userToken, String? id, bool goalOfTheDayWasBeat) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-goalOfTheDayWasBeat",
      data: {"id": id, "goalOfTheDayWasBeat": goalOfTheDayWasBeat},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> changeAmountOfWaterDrank(
      String? userToken, String? id, int amountOfWaterDrank) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-amountOfWaterDrank",
      data: {"id": id, "amountOfWaterDrank": amountOfWaterDrank},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }

  Future<dynamic> changeDrinkFrequency(
      String? userToken, String? id, int drinkFrequency) async {
    Response response;
    Dio dio = Dio();

    dio.options.headers['X-Parse-Application-Id'] =
        'iO2pQe0E4ZPEvmz3KSqWKPApMw7kAm5t1JZdwZGe';
    dio.options.headers['X-Parse-REST-API-Key'] =
        'IIJa91tLKGr1tMpbUzJCpoB7Nxtwfoh4SUbDhRGa';
    dio.options.headers['X-Parse-Session-Token'] = userToken;

    response = await dio.post(
      "https://parseapi.back4app.com/parse/functions/change-drinkFrequency",
      data: {"id": id, "drinkFrequency": drinkFrequency},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return response;
    }
  }
}
