import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final Function onCenterClick;
  final Function leftIconClick;
  final Function rightIconClick;
  final bool changeMode;

  DateWidget({
    required this.text,
    required this.height,
    required this.width,
    required this.onCenterClick,
    required this.leftIconClick,
    required this.rightIconClick,
    required this.changeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: width * 0.015,
              right: width * 0.004,
              top: height * 0.004,
              bottom: height * 0.004,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => leftIconClick(),
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    changeMode ? Icons.arrow_back : Icons.add_rounded,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4474CE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onCenterClick(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.012,
                    horizontal: width * 0.04,
                  ),
                  child: Text(
                    "Прогноз на " + text,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: width * 0.006,
              right: width * 0.015,
              top: height * 0.004,
              bottom: height * 0.004,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => rightIconClick(),
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    changeMode ? Icons.save_outlined : Icons.create_outlined,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
