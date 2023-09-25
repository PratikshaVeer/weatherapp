import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Model/current_weather_data.dart';

class WeatherDataController extends GetxController {
  WeatherData? weatherData;
  RxBool isDataLoading = false.obs;

  getList(var latititude, var longitude) async {
    try {
      isDataLoading.value = true;
      isDataLoading(true);
      final response = await http.get(Uri.parse(
          'http://api.weatherapi.com/v1/current.json?key=ee2c892bdb354a898a544227232509&q=$latititude,$longitude&aqi=yes'));
      var result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ///data successfully
        weatherData = WeatherData.fromJson(result);
      } else {
        ///error
      }
    } catch (e) {
      // log('Error while getting data is $e');
      print('Error while getting data is $e');
    } finally {
      isDataLoading(false);
    }
  }
}
