import 'package:flutter/material.dart';
import 'package:tiksi_weather/components/date_widget.dart';
import 'components/background.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Background(width: width),
            getContent(width, height),
          ],
        ),
      ),
    );
  }
}

getContent(double width, double height) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      DateWidget(
        text: "22:21 - 25.07.2021",
        height: height,
        width: width,
      ),
      Center(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.04),
          child: Text(
            "Тикси",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.005),
          child: Text(
            "Гроза и сильный ливень",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ],
  );
}
