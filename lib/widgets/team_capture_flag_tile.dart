import 'package:flutter/material.dart';

class FlagCaptureTile extends StatefulWidget {
  final String teamName;
  final VoidCallback? onLongPress;
  const FlagCaptureTile(
      {super.key, required this.teamName, required this.onLongPress});

  @override
  State<FlagCaptureTile> createState() => _FlagCaptureTileState();
}

class _FlagCaptureTileState extends State<FlagCaptureTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: GestureDetector(
        onLongPress: widget.onLongPress,
        child: Card(
          elevation: 2,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.teamName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'DIN'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
