import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherapp/Controller/forecast_data_controller.dart';

import 'package:weatherapp/Utils/device_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ForecastDataController forecastDataController =
      Get.put(ForecastDataController());
  @override
  void initState() {
    // TODO: implement initState

    forecastDataController.isDataLoading.value
        ? const Center(child: CircularProgressIndicator())
        : _getCurrentLocation();

    super.initState();
  }

  Position? _position;
  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });

    forecastDataController.forecastDataList(
        position.latitude, position.longitude);
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
// When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => forecastDataController.isDataLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildWeatherInfoCard(),
                  _build7DayForecast()
                ],
              ),
            ),
    ));
  }

  _buildAppBar() {
    return AppBar(
        title: Text(
      forecastDataController.forecastData!.location!.country.toString(),
      style: TextStyle(fontWeight: FontWeight.bold),
    ));
  }

  _buildWeatherInfoCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff89f7fe),
                  Color.fromARGB(255, 166, 61, 170),
                ])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Weather',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Text(
                forecastDataController.forecastData!.location!.localtime
                    .toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network('https:' +
                          forecastDataController
                              .forecastData!.current!.condition!.icon
                              .toString()),
                      Text(
                        forecastDataController.forecastData!.current!.tempC
                                .toString() +
                            '\u2103',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: DeviceUtils.getScaledSize(context, 0.08),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    forecastDataController
                        .forecastData!.current!.condition!.text
                        .toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Air quality',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        forecastDataController
                            .forecastData!.current!.airQuality!.co
                            .toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wind',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        forecastDataController.forecastData!.current!.windKph
                            .toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Humidity',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        forecastDataController.forecastData!.current!.humidity
                            .toString(),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feels Like',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        forecastDataController.forecastData!.current!.feelslikeC
                                .toString() +
                            '\u2103',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _build7DayForecast() {
    return Container(
      height: Get.height * 0.6,
      width: Get.width * 15.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
            child: Text(
              "7 Day's  Forecast",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: DeviceUtils.getScaledSize(context, 0.05)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              child: ListView.builder(
                  itemCount: forecastDataController
                      .forecastData!.forecast!.forecastday!.length,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    final item = forecastDataController
                        .forecastData!.forecast!.forecastday;
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: Get.height * 0.006),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff89f7fe),
                                  Color.fromARGB(255, 166, 61, 170),
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(
                                'https:' +
                                    item![index]
                                        .day!
                                        .condition!
                                        .icon
                                        .toString(),
                                height: Get.height * 0.08,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item[index].date.toString(),
                                    style: TextStyle(
                                        fontSize: DeviceUtils.getScaledSize(
                                            context, 0.04),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    item[index].day!.condition!.text.toString(),
                                    style: TextStyle(
                                        fontSize: DeviceUtils.getScaledSize(
                                            context, 0.04),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                item[index].hour![index].tempC.toString() +
                                    '\u2103',
                                style: TextStyle(
                                    fontSize: DeviceUtils.getScaledSize(
                                        context, 0.06),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }
}
