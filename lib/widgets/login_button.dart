import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/string_constants.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback onPress;
  const LoginButton({super.key, required this.onPress});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      child: TextButton(
        child: Text(
          LOGIN,
          style: TextStyle(color: Colors.white, fontSize: 18),
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
