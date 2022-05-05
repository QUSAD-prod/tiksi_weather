import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherIcon extends StatelessWidget {
  final String icon;
  final double? size;

  const WeatherIcon({Key? key, required this.icon, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String iconPath = "res/weather_icons/" + icon + ".svg";
    return Center(
      child: SvgPicture.asset(
        iconPath,
        width: size ?? double.infinity,
        height: size ?? double.infinity,
      ),
    );
  }
}
