import 'package:flutter/material.dart';
import 'package:police_patrol_app/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? borderRadius;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.color = PRIMARY_COLOR,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.borderRadius = DEFAULT_BORDER_RADIUS,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(
          vertical: DEFAULT_PADDING / 1.5,
          horizontal: DEFAULT_PADDING * 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
