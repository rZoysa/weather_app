import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_screen/widgets/hourly_forcast_item.dart';
import 'package:weather_app/screens/weather_screen/widgets/information.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
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
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '300°F',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          Text(
                            'Rain',
                            style: TextStyle(
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
              'Weather Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            //Weather forecast cards
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForcastItem(icon: Icons.cloud, temperature: '320.12', time: '03:00',),
                  HourlyForcastItem(icon: Icons.cloud, temperature: '320.12', time: '03:00',),
                  HourlyForcastItem(icon: Icons.cloud, temperature: '320.12', time: '03:00',),
                  HourlyForcastItem(icon: Icons.cloud, temperature: '320.12', time: '03:00',),
                  HourlyForcastItem(icon: Icons.cloud, temperature: '320.12', time: '03:00',),                  
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

            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Information(
                    icon: Icons.water_drop,
                    title: 'Humidity',
                    value: '94',
                  ),
                  Information(
                    icon: Icons.air,
                    title: 'Wind Speed',
                    value: '7.67',
                  ),
                  Information(
                      icon: Icons.electric_meter,
                      title: 'Pressure',
                      value: '1006'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




