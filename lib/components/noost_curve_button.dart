import 'package:flutter/material.dart';

class NoostCurveButton extends StatelessWidget {
  const NoostCurveButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    required this.label,
    this.textColor,
  });

  final void Function()? onPressed;
  final Color? backgroundColor;
  final String label;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
