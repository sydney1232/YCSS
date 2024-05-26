import 'package:flutter/material.dart';

class TeamTileSelectionVs extends StatefulWidget {
  String teamName;
  String imageURL;
  VoidCallback onPress;
  TeamTileSelectionVs(
      {super.key,
      required this.teamName,
      required this.imageURL,
      required this.onPress});

  @override
  State<TeamTileSelectionVs> createState() => _TeamTileSelectionVsState();
}

class _TeamTileSelectionVsState extends State<TeamTileSelectionVs> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        margin: EdgeInsets.all(10),
        height: 300,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.network(widget.imageURL),
            ),
            const SizedBox(height: 8),
            Text(
              widget.teamName,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontFamily: 'DIN'),
            )
          ],
        ),
      ),
    );
  }
}
