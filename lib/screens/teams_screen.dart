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
final TextEditingController reasonTextController = TextEditingController();

class _TeamScreenState extends State<TeamScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  GlobalKey<FormState> _formKeyAddScore = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyDeductScore = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyReason = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    textController.text = '';
    reasonTextController.text = '';
    super.initState();
  }

  void openDialogAddScore(
      BuildContext context, String? docID, String teamName, int currentScore) {
    //Initiate the text controller when dialog is opened
    textController.text = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add score to $teamName",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKeyAddScore,
                        child: Column(children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Add score here"),
                            keyboardType: TextInputType.number,
                            controller: textController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a score';
                              }
                              int? parsedScore = int.tryParse(value);
                              if (parsedScore == null || parsedScore <= 0) {
                                return 'Please enter a valid positive number';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKeyAddScore.currentState!.validate()) {
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
                    }
                  },
                  child: const Text("Add"),
                )
              ],
            ));
  }

  void openDialogDeductScore(
      BuildContext context, String? docID, String teamName, int currentScore) {
    //Initiate the text controllers when dialog is opened
    textController.text = '';
    reasonTextController.text = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deduct score to $teamName",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKeyDeductScore,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Subtract score here",
                  ),
                  keyboardType: TextInputType.number,
                  controller: textController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter point(s) to subtract";
                    }
                    int? parsedScore = int.tryParse(value);
                    if ((parsedScore == null || parsedScore <= 0)) {
                      return "Please enter a positive score";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Reason",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Form(
                key: _formKeyReason,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Add statement here",
                  ),
                  keyboardType: TextInputType.text,
                  controller: reasonTextController,
                  minLines: 7,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Statement Required";
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKeyDeductScore.currentState!.validate() &&
                  _formKeyReason.currentState!.validate()) {
                int newScore = currentScore - int.parse(textController.text);
                int scoreDeducted = int.parse(textController.text);
                String scoreAuthor = currentUser.displayName.toString();
                String reason = reasonTextController.text;
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
              }
            },
            child: Text("Deduct"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blue,
      body: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              SELECT_TEAM_UPDATE_SCORE,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: lightPink,
                  fontFamily: 'TheRift'),
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
          backgroundColor: lightPink,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            size: 40,
            Icons.home,
            color: blue,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
