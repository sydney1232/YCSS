import 'package:flutter/material.dart';

import '../constants/color_palette.dart';

class PasswordTextField extends StatefulWidget {
  TextEditingController controller;
  String? hintText;
  PasswordTextField({super.key, required this.controller, this.hintText});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 330,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Set the background color
            borderRadius: BorderRadius.circular(20.0), // Add rounded corners
          ),
          child: TextFormField(
            style: TextStyle(color: lightPink, fontFamily: 'DIN'),
            controller: widget.controller,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            cursorColor: lightPink,
            decoration: InputDecoration(
              hintText: widget.hintText ?? "Password",
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.lock,
                  color: blue,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
