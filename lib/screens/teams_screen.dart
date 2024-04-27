import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/firebase_services/firebase_crud.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

final FirestoreService firestoreService = FirestoreService();
final TextEditingController textController = TextEditingController();

class _TeamScreenState extends State<TeamScreen> {
  void openDialogAddScore(
      BuildContext context, String? docID, int currentScore) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                keyboardType: TextInputType.number,
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      int newScore =
                          currentScore + int.parse(textController.text);
                      firestoreService.updateScore(docID!, newScore);

                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"))
              ],
            ));
  }

  void openDialogDeductScore(
      BuildContext context, String? docID, int currentScore) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                keyboardType: TextInputType.number,
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      int newScore =
                          currentScore - int.parse(textController.text);
                      firestoreService.updateScore(docID!, newScore);

                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTeamsStreamByID(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List teamList = snapshot.data!.docs;
            return ListView.builder(
                itemCount: teamList.length,
                itemBuilder: (context, index) {
                  //get individual doc
                  DocumentSnapshot document = teamList[index];
                  String docID = document.id;

                  //get team for each doc
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  //Get data for each item
                  String teamText = data['teamName'];
                  int currentScore = data['score'];

                  return ListTile(
                    title: Text(teamText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize
                          .min, // To make the Row as small as possible
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            openDialogAddScore(context, docID, currentScore);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            openDialogDeductScore(context, docID, currentScore);
                          },
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Center(child: const Text("No Teams"));
          }
        },
      ),
    );
  }
}
