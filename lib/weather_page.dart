import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiksi_weather/components/date_widget.dart';

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
            getBackground(width),
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

Widget getBackground(double width) {
  return Stack(
    children: [
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 62,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color(0xFF195BD1),
                    Color(0xFF6778FA),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 38,
            child: Container(
              color: Color(0xFF3645AF),
            ),
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 39,
            child: Container(),
          ),
          Expanded(
            flex: 19,
            child: Container(
              child: SvgPicture.asset(
                "res/background_waves_top.svg",
                width: width * 1.27,
              ),
            ),
          ),
          Expanded(
            flex: 32,
            child: Container(),
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 42,
            child: Container(),
          ),
          Expanded(
            flex: 17,
            child: Container(
              child: SvgPicture.asset(
                "res/background_waves_center.svg",
                width: width * 1.33,
              ),
            ),
          ),
          Expanded(
            flex: 31,
            child: Container(),
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 41,
            child: Container(),
          ),
          Expanded(
            flex: 13,
            child: Container(
              child: SvgPicture.asset(
                "res/background_waves_bottom.svg",
                width: width,
              ),
            ),
          ),
          Expanded(
            flex: 26,
            child: Container(),
          ),
        ],
      ),
    ],
  );
}
