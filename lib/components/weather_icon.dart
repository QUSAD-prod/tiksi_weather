import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherIcon extends StatelessWidget {
  final String icon;
  final double size;

  WeatherIcon({required this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    String iconPath = "res/weather_icons/" + icon + ".svg";
    return Center(
      child: SvgPicture.asset(
        iconPath,
        width: size,
      ),
    );
  }
}
