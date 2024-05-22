import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';

Container buildDot(int index, int currentIndex, BuildContext context) {
  return Container(
    height: 10,
    width: currentIndex == index ? 25 : 10,
    margin: EdgeInsets.only(right: 5),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(20), color: purple),
  );
}
