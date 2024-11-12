import 'package:flutter/material.dart';

class HourlyForeCastItem extends StatelessWidget {
  const HourlyForeCastItem(
      {super.key, required this.time, required this.sky, required this.temp});

  final String time;
  final String sky;
  final String temp;

  //time
  //icon of weather
  //temperature
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        width: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              sky == 'Clouds' ||
                      sky == 'Rain'
                  ? Icons.cloud
                  : Icons.sunny,
              color: sky == 'Clouds' ||
                      sky == 'Rain'
                  ? Colors.white
                  : Colors.yellow,
              size: 22.0,
            ),
            Text(
              "$temp K",
            ),
          ],
        ),
      ),
    );
  }
}
