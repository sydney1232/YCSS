import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/firebase_services/firebase_crud.dart';
import 'package:ycss/widgets/team_tile.dart';

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
                    String scoreAuthor = currentUser.displayName.toString();
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
                          currentScore - int.parse(textController.text);
                      int scoreDeducted = int.parse(textController.text);
                      String scoreAuthor = currentUser.displayName.toString();
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
      body: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              SELECT_TEAM_UPDATE_SCORE,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            )),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getTeamsStreamByID(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List teamList = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: (teamList.length / 3).ceil(),
                    itemBuilder: (context, index) {
                      final lastRow = index == (teamList.length / 3).ceil() - 1;
                      //get individual doc
                      DocumentSnapshot document = teamList[index];
                      String docID = document.id;

                      //get team for each doc
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      //Get data for each item
                      String teamText = data['teamName'];
                      int currentScore = data['score'];
                      return Row(
                        mainAxisAlignment: lastRow
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          for (int i = index * 3; i < (index + 1) * 3; i++)
                            if (i < teamList.length)
                              if (i < teamList.length)
                                i == 9
                                    ? // Check if it's the 10th tile
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3, // Adjust size
                                        child: Column(
                                          children: [
                                            TeamTile(
                                              teamName: teamList[i]['teamName'],
                                              onAddPressed: () =>
                                                  openDialogAddScore(
                                                      context,
                                                      teamList[i].id,
                                                      teamList[i]['teamName'],
                                                      teamList[i]['score']),
                                              onRemovePressed: () =>
                                                  openDialogDeductScore(
                                                context,
                                                teamList[i].id,
                                                teamList[i]['teamName'],
                                                teamList[i]['score'],
                                              ),
                                            ),
                                            const SizedBox(height: 150),
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: TeamTile(
                                          teamName: teamList[i]['teamName'],
                                          onAddPressed: () =>
                                              openDialogAddScore(
                                                  context,
                                                  teamList[i].id,
                                                  teamList[i]['teamName'],
                                                  teamList[i]['score']),
                                          onRemovePressed: () =>
                                              openDialogDeductScore(
                                            context,
                                            teamList[i].id,
                                            teamList[i]['teamName'],
                                            teamList[i]['score'],
                                          ),
                                        ),
                                      ),
                        ],
                      );
                    });
              } else {
                return Center(child: const Text("No Teams"));
              }
            },
          ),
        ),
      ]),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50),
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            size: 40,
            Icons.home,
            color: lightPink,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
