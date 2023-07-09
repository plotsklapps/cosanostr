import 'package:flutter/material.dart';

class NoostSnackBar extends SnackBar {
  NoostSnackBar({Key? key, required this.label, this.isWarning = false})
      : super(
          key: key,
          content: _GenericErrorSnackBarMessage(
            label: label,
            isWarning: isWarning,
          ),
          backgroundColor: isWarning! ? Colors.red : Colors.white,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          behavior: SnackBarBehavior.fixed,
        );

  final String label;
  final bool? isWarning;
}

class _GenericErrorSnackBarMessage extends StatelessWidget {
  const _GenericErrorSnackBarMessage({
    Key? key,
    required this.label,
    this.isWarning,
  }) : super(key: key);

  final String label;
  final bool? isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Text(
        label,
        style: TextStyle(
          color: isWarning! ? Colors.white : Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
