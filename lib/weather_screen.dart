import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_item.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Bahadurgarh";
      final result = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'));
      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw "An unexcepted error ocurred";
      }
      print(data);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Weather App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;

            final currentWeatherData = data['list'][0];

            final currentData = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentHumedity = currentWeatherData['main']['humidity'];

            return SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "$currentData K",
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Icon(
                                currentSky.toString() == 'Clouds' || currentSky.toString() == 'Rain' ? Icons.cloud : Icons.sunny,
                                color: currentSky.toString() == 'Clouds' || currentSky.toString() == 'Rain' ? Colors.white : Colors.yellow,
                                size: 64.0,
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                "$currentSky",
                                style: TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    height: 120.0,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index+1];
                        final hourSky = hourlyForecast['weather'][0]['main'];
                        final hourTemp = hourlyForecast['main']['temp'];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForeCastItem(temp: hourTemp.toString(), sky: hourSky.toString(), time: DateFormat.j().format(time).toString(),);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 10.0,
                      children: [
                        AdditionalItem(icon: Icons.water_drop, label: 'Humidity', value: currentHumedity.toString(),),
                        AdditionalItem(icon: Icons.air, label: 'Wind Speed', value: currentWindSpeed.toString(),),
                        AdditionalItem(icon: Icons.beach_access, label: 'Pressure', value: currentPressure.toString(),),
                      ]
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
