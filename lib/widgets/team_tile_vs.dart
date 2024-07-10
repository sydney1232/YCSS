import 'package:flutter/material.dart';

class TeamTileVs extends StatefulWidget {
  final VoidCallback onDoubleTap;
  String teamName;
  String imageURL;
  TeamTileVs(
      {super.key,
      required this.teamName,
      required this.imageURL,
      required this.onDoubleTap});

  @override
  State<TeamTileVs> createState() => _TeamTileVsState();
}

class _TeamTileVsState extends State<TeamTileVs> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTap,
      child: Container(
        height: 200,
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
              child: CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage(widget.imageURL), // Use imageURL here
                backgroundColor: Colors.white,
              ),
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
