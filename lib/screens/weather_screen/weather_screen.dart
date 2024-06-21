import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/screens/weather_screen/widgets/hourly_forcast_item.dart';
import 'package:weather_app/screens/weather_screen/widgets/information.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String apiKey = dotenv.env['APPID'] ?? 'API_KEY_NOT_FOUND';
      String cityName = 'London';
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$apiKey'),
      );
      final data = jsonDecode(result.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                getCurrentWeather();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Main Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp K',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentSky == 'Clouds'
                                      ? Icons.cloud
                                      : currentSky == 'Rain'
                                          ? Icons.water
                                          : Icons.sunny,
                                  size: 64,
                                ),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            
                  const SizedBox(height: 14),
            
                  //Weather forecast cards
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          HourlyForcastItem(
                            icon: getIcon(
                                data['list'][i]['weather'][0]['main'].toString()),
                            temperature:
                                data['list'][i]['main']['temp'].toString(),
                            time: extractTime(data['list'][i]['dt_txt']),
                          ),
                      ],
                    ),
                  ),
            
                  const SizedBox(height: 20),
            
                  //Additional Information
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Information(
                          icon: Icons.water_drop,
                          title: 'Humidity',
                          value: currentHumidity.toString(),
                        ),
                        Information(
                          icon: Icons.air,
                          title: 'Wind Speed',
                          value: currentWindSpeed.toString(),
                        ),
                        Information(
                            icon: Icons.electric_meter,
                            title: 'Pressure',
                            value: currentPressure.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

IconData getIcon(String weatherStatus) {
  if (weatherStatus == 'Clouds') {
    return Icons.cloud;
  }

  if (weatherStatus == 'Rain') {
    return Icons.water;
  } else {
    return Icons.sunny;
  }
}

String extractTime(String dateTimeString) {
  // Parse the string into a DateTime object
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format the DateTime object to extract the time
  String timeString = DateFormat.Hm().format(dateTime);

  return timeString;
}
