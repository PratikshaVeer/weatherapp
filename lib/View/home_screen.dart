import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherapp/Controller/weathercurrent_weather_data_controller.dart';
import 'package:weatherapp/Utils/device_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? position;
  String? _currentAddress;

  WeatherDataController weatherDataController =
      Get.put(WeatherDataController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPosition();
  }

  getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    weatherDataController.getList(position?.latitude, position?.longitude);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    print('Weather Data');
    print(position?.latitude);
    print(position?.longitude);

    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          _buildWeatherInfoCard(),
          _build7DayForecast()
        ],
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      title:
          Text(weatherDataController.weatherData!.location!.country.toString()),
    );
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
                weatherDataController.weatherData!.location!.localtime
                    .toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.network(weatherDataController
                      //     .weatherData!.current!.condition!.icon
                      //     .toString()),
                      Text(
                        weatherDataController.weatherData!.current!.tempC
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
                    weatherDataController.weatherData!.current!.condition!.text
                        .toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
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
                        weatherDataController.weatherData!.current!.windDegree
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
                        weatherDataController.weatherData!.current!.windKph
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
                        weatherDataController.weatherData!.current!.humidity
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
                        weatherDataController.weatherData!.current!.feelslikeC
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
      height: Get.height * 0.25,
      width: Get.width * 15.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
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
                          'Today',
                          style: TextStyle(
                              fontSize:
                                  DeviceUtils.getScaledSize(context, 0.04),
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/sun.png',
                              height: Get.height * 0.06,
                            ),
                            Text(
                              '26' + '\u2103',
                              style: TextStyle(
                                  fontSize:
                                      DeviceUtils.getScaledSize(context, 0.06),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          'Partly Sunny',
                          style: TextStyle(
                              fontSize:
                                  DeviceUtils.getScaledSize(context, 0.04),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })),
      ),
    );
  }
}
