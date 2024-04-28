import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser!;

  void openDialogAddScore(
      BuildContext context, String? docID, String teamName, int currentScore) {
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
                    String scoreAuthor = currentUser.email.toString();
                    int scoreAdded = int.parse(textController.text);
                    firestoreService.addScoreToFirestore(
                      scoreAdded,
                      newScore,
                      docID!,
                      scoreAuthor,
                      teamName,
                      currentScore,
                    );
                    textController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                )
              ],
            ));
  }

  void openDialogDeductScore(
      BuildContext context, String? docID, int currentScore, String teamName) {
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
                      int scoreDeducted = int.parse(textController.text);
                      String scoreAuthor = currentUser.email.toString();
                      String reason = "No reason for now";
                      firestoreService.addScoreDeductionToFirestore(
                          scoreDeducted,
                          newScore,
                          docID!,
                          scoreAuthor,
                          teamName,
                          currentScore,
                          reason);
                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Deduct"))
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
                            openDialogAddScore(
                                context, docID, teamText, currentScore);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            openDialogDeductScore(
                                context, docID, currentScore, teamText);
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
