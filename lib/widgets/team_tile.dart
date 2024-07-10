import 'package:flutter/material.dart';

class TeamTile extends StatelessWidget {
  final String teamName;
  final VoidCallback? onAddPressed;
  final VoidCallback? onRemovePressed;
  final String imageURL;
  const TeamTile({
    Key? key,
    required this.teamName,
    required this.onAddPressed,
    required this.onRemovePressed,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage(imageURL), // Use imageURL here
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Text(
                    teamName,
                    style: TextStyle(fontSize: 15.0, fontFamily: "DIN"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onAddPressed,
                      icon: Icon(
                        Icons.add,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: onRemovePressed,
                      icon: Icon(
                        Icons.remove,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
