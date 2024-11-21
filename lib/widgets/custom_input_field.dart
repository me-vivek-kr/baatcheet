import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regExp; //regular expression
  final String hintText;
  final bool obscureText;

  const CustomTextFormField(
      {super.key,
      required this.onSaved,
      required this.regExp,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (value) {
        return RegExp(regExp).hasMatch(value!) ? null : 'Enter a Valid Value';
      },
      decoration: InputDecoration(
          fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white38)),
    );
  }
}
