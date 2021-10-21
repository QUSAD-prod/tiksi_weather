import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiksi_weather/api.dart';
import 'package:tiksi_weather/weather_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => WeatherPage(firebase: Api()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          getBackground(
            height,
            width,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: width * 0.3,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new ExactAssetImage('assets/splash.png'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18.0),
                  child: Text(
                    "TiksiWeather",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Прогноз погоды в Тикси",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.02,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(bottom: height * 0.028),
                child: Text(
                  "by Oslopov",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBackground(double height, double width) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color(0xFFA1D2FF),
                Color(0xFF78B6FF),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              "res/splash_screen/splash_center.svg",
              width: width,
            ),
            Expanded(child: Container()),
          ],
        ),
        Column(
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              "res/splash_screen/splash_ground.svg",
              width: width,
            ),
          ],
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: width * 0.11,
                right: width * 0.09,
                top: height * 0.05,
              ),
              child: SvgPicture.asset(
                "res/splash_screen/splash_top.svg",
                width: width * 0.8,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }
}
