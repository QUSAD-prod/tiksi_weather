import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPass;
  final TextInputType? keyboardType;
  final bool errorEnabled;
  final String? errorText;
  final int? maxLenght;
  final bool autocorrect;
  final Function? onEditingComplete;
  final Function(String)? onChanged;
  final Function? onTap;

  const Input({
    Key? key,
    required this.hint,
    required this.controller,
    required this.isPass,
    this.keyboardType = TextInputType.text,
    this.errorEnabled = false,
    this.errorText,
    this.maxLenght,
    this.autocorrect = true,
    this.onEditingComplete,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete:
          onEditingComplete == null ? () => {} : onEditingComplete!(),
      maxLength: maxLenght,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPass,
      autocorrect: autocorrect,
      cursorColor: const Color(0xFF3F9AE0),
      cursorRadius: const Radius.circular(2),
      onTap: onTap == null ? () => {} : onTap!(),
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        counterStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black.withOpacity(0.3),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFE64646),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        errorText: errorEnabled ? errorText : null,
        contentPadding: const EdgeInsets.all(12.0),
        filled: true,
        fillColor:
            errorEnabled ? const Color(0xFFFAEBEB) : const Color(0xFFF2F3F5),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.black.withOpacity(0.6),
        ),
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorEnabled
                ? const Color(0xFFE64646)
                : const Color(0xFF3F9AE0),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorEnabled
                ? const Color(0xFFE64646)
                : Colors.black.withOpacity(0.12),
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1.0,
            color: errorEnabled
                ? const Color(0xFFE64646)
                : Colors.black.withOpacity(0.12),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorEnabled
                ? const Color(0xFFE64646)
                : const Color(0xFF3F9AE0),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}
