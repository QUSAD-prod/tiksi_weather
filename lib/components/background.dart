import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  final double height;
  Background({required this.height});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: height * 0.66,
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
                Expanded(
                    child: Container(
                  color: Color(0xFF3645AF),
                )),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: height * 0.43,
                ),
                Container(
                  height: height * 0.23,
                  child: SvgPicture.asset(
                    "res/background/background_waves_top.svg",
                    height: height * 0.23,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: height * 0.475,
                ),
                Container(
                  height: height * 0.19,
                  child: SvgPicture.asset(
                    "res/background/background_waves_center.svg",
                    height: height * 0.19,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: height * 0.48,
                ),
                Container(
                  height: height * 0.3,
                  child: SvgPicture.asset(
                    "res/background/background_waves_bottom.svg",
                    height: height * 0.3,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
