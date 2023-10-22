import 'package:flutter/material.dart';

class MainTxtInput extends StatefulWidget {
  final String label;
  final bool obsecure;
  final TextEditingController controller;
  const MainTxtInput({super.key, required this.label, required this.obsecure, required this.controller});

  @override
  State<MainTxtInput> createState() => _MainTxtInputState();
}

class _MainTxtInputState extends State<MainTxtInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obsecure,
      decoration: InputDecoration(
        labelText: widget.label,
        hintStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
