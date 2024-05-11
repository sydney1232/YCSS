import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';
import 'package:ycss/constants/string_constants.dart';

class UserNameTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  UserNameTextField(
      {super.key, required this.controller, required this.hintText});

  @override
  State<UserNameTextField> createState() => _UserNameTextFieldState();
}

class _UserNameTextFieldState extends State<UserNameTextField> {
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
            style: TextStyle(color: lightPink),
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            cursorColor: lightPink,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  widget.hintText == EMAIL ? Icons.mail : Icons.person,
                  color: Color(0xFF0D47A1),
                ), //Using this color code since it is expecting a PrimarySwatch value
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
