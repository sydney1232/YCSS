import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.black,
      ),
    );
  }
}
