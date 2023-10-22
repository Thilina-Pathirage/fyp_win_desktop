import 'package:flutter/material.dart';
import 'package:win_app_fyp/themes/colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.heroTag,
    required this.icon,
    required this.iconSize
  }) : super(key: key);

  final VoidCallback onPressed;
  final String heroTag;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      heroTag: heroTag,
      onPressed: onPressed,
      child: Icon(icon, size: iconSize, color: AppColors.textColorDark,)
    );
  }
}
