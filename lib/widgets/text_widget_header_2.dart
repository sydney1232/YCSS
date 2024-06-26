import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';

class Header2 extends StatefulWidget {
  String text;
  Header2({super.key, required this.text});

  @override
  State<Header2> createState() => _Header2State();
}

class _Header2State extends State<Header2> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'DIN',
          fontSize: 18,
          color: lightPink,
        ),
      ),
    );
  }
}
