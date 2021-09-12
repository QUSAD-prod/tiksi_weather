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
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.only(bottom: height * 0.26),
                child: SvgPicture.asset(
                  "res/background/back.svg",
                  width: width,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
