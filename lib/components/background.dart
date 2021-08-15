import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatelessWidget {
  final double width;

  Background({required this.width});

  @override
  Widget build(BuildContext context) {
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
}
