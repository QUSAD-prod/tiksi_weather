import 'package:flutter/material.dart';

enum ButtonMode { primary, secondary, outlined, commerce }

class VkButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final ButtonMode mode;
  final IconData? iconData;

  const VkButton({
    Key? key,
    required this.text,
    required this.onClick,
    this.iconData,
    this.mode = ButtonMode.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: getBorder(),
        color: getBackground(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onClick(),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Center(
              child: getChild(),
            ),
          ),
        ),
      ),
    );
  }

  Color getBackground() {
    switch (mode) {
      case ButtonMode.primary:
        return const Color(0xFF4986CC);
      case ButtonMode.secondary:
        return const Color.fromRGBO(0, 28, 61, 0.05);
      case ButtonMode.outlined:
        return Colors.transparent;
      case ButtonMode.commerce:
        return const Color(0xFF4BB34B);
    }
  }

  Border getBorder() {
    switch (mode) {
      case ButtonMode.primary:
        return Border.all(color: Colors.transparent);
      case ButtonMode.secondary:
        return Border.all(color: Colors.transparent);
      case ButtonMode.outlined:
        return Border.all(color: const Color(0xFF3F8AE0), width: 1.0);
      case ButtonMode.commerce:
        return Border.all(color: Colors.transparent);
    }
  }

  Color getForegroundColor() {
    switch (mode) {
      case ButtonMode.primary:
        return const Color(0xFFFFFFFF);
      case ButtonMode.secondary:
        return const Color(0xFF3F8AE0);
      case ButtonMode.outlined:
        return const Color(0xFF3F8AE0);
      case ButtonMode.commerce:
        return const Color(0xFFFFFFFF);
    }
  }

  Widget getChild() {
    if (iconData != null) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: Icon(
              iconData,
              color: getForegroundColor(),
              size: 17.0,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: getForegroundColor(),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: TextStyle(
          color: getForegroundColor(),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}
