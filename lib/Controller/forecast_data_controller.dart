import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/Model/forecast_data.dart';

class ForecastDataController extends GetxController {
  ForecastData? forecastData;
  RxBool isDataLoading = false.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  forecastDataList(latititude, longitude) async {
    try {
      isDataLoading.value = true;
      isDataLoading(true);
      final response = await http.get(Uri.parse(
          'http://api.weatherapi.com/v1/forecast.json?key=ee2c892bdb354a898a544227232509&q=$latititude,$longitude&days=7&aqi=yes&alerts=yes'));
      var result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ///data successfully

        forecastData = ForecastData.fromJson(result);
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
