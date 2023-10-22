import 'package:flutter/material.dart';
import 'package:win_app_fyp/themes/colors.dart';

class MainBtn extends StatefulWidget {
  final String title;
  final Color btnColor;
  final VoidCallback onPressed;
  final Color txtColor;
  const MainBtn({super.key, required this.title, required this.btnColor, required this.onPressed, required this.txtColor});

  @override
  State<MainBtn> createState() => _MainBtnState();
}

class _MainBtnState extends State<MainBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          
            backgroundColor: widget.btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0),
        child: Text(
          widget.title,
          style: TextStyle(color: widget.txtColor, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
      ),
    );
  }
}
