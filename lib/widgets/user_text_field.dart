import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class UserNameTextField extends StatefulWidget {
  TextEditingController controller;
  UserNameTextField({super.key, required this.controller});

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
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.deepOrange,
            decoration: const InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Icon(Icons.person),
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
