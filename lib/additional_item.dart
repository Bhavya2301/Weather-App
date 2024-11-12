import 'package:flutter/material.dart';

class AdditionalItem extends StatelessWidget {
  const AdditionalItem({super.key, required this.icon, required this.label, required this.value});

  //icon
  final IconData icon;
  //label
  final String label;
  //value
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32.0,
        ),
        const SizedBox(height: 8.0,),
        Text(
          label,
        ),
        const SizedBox(height: 8.0,),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}