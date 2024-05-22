import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';

class Header1 extends StatefulWidget {
  String text;
  Header1({super.key, required this.text});

  @override
  State<Header1> createState() => _Header1State();
}

class _Header1State extends State<Header1> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: "TheRift",
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: lightPink,
      ),
    );
  }
}
