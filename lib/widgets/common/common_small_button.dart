import 'package:flutter/material.dart';

class CommonSmallButton extends StatelessWidget {
  final String title;
  final Color btnColor;
  final Color btnTxtColor;
  final VoidCallback onPressed;

  const CommonSmallButton(
      {super.key,
      required this.title,
      required this.btnColor,
      required this.btnTxtColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: btnTxtColor),
      ),
    );
  }
}
