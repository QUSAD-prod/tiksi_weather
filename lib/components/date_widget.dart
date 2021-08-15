import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final double height;
  final double width;
  final String text;

  DateWidget({required this.text, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.045),
          padding: EdgeInsets.symmetric(
            vertical: height * 0.008,
            horizontal: width * 0.04,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF4474CE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                "Прогноз опубликован",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
  }
}