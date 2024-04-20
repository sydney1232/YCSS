import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatefulWidget {
  String text;
  final VoidCallback onPress;
  ThemeButton({super.key, required this.text, required this.onPress});

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 250,
      child: TextButton(
        child: Text(
          widget.text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: widget.onPress,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
