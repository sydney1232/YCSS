import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  String name;
  Color backgroundcolor;
  IconData icon;
  Color? iconColor;
  final VoidCallback onPress;
  ItemTile(
      {super.key,
      required this.name,
      required this.backgroundcolor,
      required this.icon,
      this.iconColor,
      required this.onPress});

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
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
                color: widget.backgroundcolor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor ?? Colors.white,
                size: 45,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
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
