import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycss/models/time_info_submission.dart';

import '../constants/color_palette.dart';
import '../constants/globals.dart';
import '../constants/string_constants.dart';
import '../firebase_services/firebase_crud.dart';
import '../firebase_services/firebase_utils.dart';

class TimeAttackTeamRanking extends StatefulWidget {
  const TimeAttackTeamRanking({Key? key}) : super(key: key);

  @override
  State<TimeAttackTeamRanking> createState() => _TimeAttackTeamRankingState();
}

class _TimeAttackTeamRankingState extends State<TimeAttackTeamRanking> {
  //Firebase instance
  FirestoreService firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  // Circular loading progress indicator when updating scores
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Sort the list by the seconds property
    globalTeamInfoList.sort((a, b) => a.timeInMillis.compareTo(b.timeInMillis));

    var teamIndex = 0;

    // Function to check if the lengths match
    Future<bool> areLengthsEqual() async {
      int firestoreCount = await firestoreService.getTeamCollectionCount();
      return globalTeamInfoList.length == firestoreCount;
    }

    int getScore(int index) {
      final scoreMap = {
        1: 100,
        2: 90,
        3: 80,
        4: 70,
        5: 60,
        6: 50,
        7: 40,
        8: 30,
        9: 20,
        10: 10,
      };
      return scoreMap[index] ?? 0;
    }

    void clearList() {
      setState(() {
        teamIndex = 0;
        globalTeamInfoList.clear();
        globalTeamInfoSubmissionList.clear();
      });
    }

    void _addTimeScoreLogging() {
      //Logging Updated Score
      String logTriggeredTimeAttack = "A Time Attack has been Triggered";
      String logEachScore = "";
      String logAuthor = currentUser!.displayName ?? 'User';
      String phTime = getLocalDateAndTime();
      String logDesc = "Triggered By: $logAuthor\n Date and Time: $phTime";

      //Format teamName - time = Xpts, from previousScore to newCurrentScore
      List<String> teamName = globalTeamInfoSubmissionList
          .map((info) =>
              '${info.teamName} - ${info.time} = ${info.receivingPoints}pts, from ${info.previousScore} to ${info.previousScore! + info.receivingPoints!}')
          .toList();
      logEachScore = teamName.join('\n');

      firestoreService.addScoreLogging(
          "$logTriggeredTimeAttack\n\n $logEachScore\n \n$logDesc");
    }

    _updateScores() async {
      setState(() {
        _isLoading = true;
      });

      for (var info in globalTeamInfoSubmissionList) {
        var currentScore =
            await firestoreService.getCurrentScoreByDocumentID(info.docID);
        print(
            "Team: ${info.teamName} DocID: ${info.docID} Receiving Points: ${info.receivingPoints} \n ${info.teamName}'s Current Score: $currentScore $teamIndex");

        //Update current score and add it in the list
        int index = globalTeamInfoSubmissionList
            .indexWhere((item) => item.docID == info.docID);
        if (index != -1) {
          // Update the property of the item
          globalTeamInfoSubmissionList[index].previousScore = currentScore;
        }

        //Update Score in Firebase
        firestoreService.updateScore(
            info.docID, currentScore! + info.receivingPoints!);

        //For every completed score submission, we remove them in the list
        setState(() {
          globalTeamInfoList.removeWhere((item) => item.docID == info.docID);
        });
      }

      //Update Score Logging
      _addTimeScoreLogging();

      //Done loading, set to false
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        Text(
                          TEAM_TIME_ATTACK_RESULTS,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: lightPink,
                              fontFamily: 'TheRift'),
                        ),
                        SizedBox(height: 40),
                        Text(
                          TEAM_TIME_ATTACK_RESULTS_ORDER,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: lightPink,
                              fontFamily: 'DIN'),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Team Name')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Ranking')),
                  ],
                  rows: List<DataRow>.generate(
                    globalTeamInfoList.length,
                    (index) {
                      var teamInfo = globalTeamInfoList[index];

                      //Display the Team Ranking
                      return DataRow(cells: [
                        DataCell(Text(teamInfo.teamName)),
                        DataCell(Text(teamInfo.time)),
                        DataCell(
                          Text('${index + 1} - ${getScore(index + 1)} pts'),
                        ),
                      ]);
                    },
                  ),
                ),
              ),

              //Check Team Count in Firebase if it is equal to the current List
              if (!_isLoading)
                FutureBuilder<bool>(
                  future: areLengthsEqual(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While the future is still processing, return a loading indicator
                      return CircularProgressIndicator();
                    } else {
                      // Once the future completes, check its result
                      if (snapshot.hasData && snapshot.data == true) {
                        // If the lengths are equal, show the submit button
                        return Visibility(
                          visible: true,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(40),
                            width: 100,
                            child: TextButton(
                              onPressed: () {
                                setState(() async {
                                  for (int i = 0;
                                      i < globalTeamInfoList.length;
                                      i++) {
                                    var info = globalTeamInfoList[i];

                                    // Check if globalTeamInfoSubmissionList already contains the same docID
                                    bool alreadyExists =
                                        globalTeamInfoSubmissionList.any(
                                            (submission) =>
                                                submission.docID == info.docID);

                                    //Add if doc ID Does not exist
                                    if (!alreadyExists) {
                                      globalTeamInfoSubmissionList.add(
                                          TeamTimeInfoSubmission(
                                              docID: info.docID,
                                              teamName: info.teamName,
                                              time: info.time,
                                              timeInMillis: info.timeInMillis,
                                              receivingPoints:
                                                  getScore(teamIndex + 1)));
                                    }
                                    teamIndex++; //Since we cannot use int i as team count indicator because it affects the count if condition is false, we use this variable to shield the team count value
                                  }
                                  await _updateScores();
                                  clearList();
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(lightPink),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                              child: Text(
                                SUBMIT,
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // If the lengths are not equal, hide the submit button
                        return Visibility(
                          visible: false,
                          child:
                              Container(), // You can return an empty container or null here
                        );
                      }
                    }
                  },
                ),
            ],
          ),
        ),

        //When Score is being Updated UI
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(lightPink)),
                  SizedBox(height: 16),
                  Text(
                    textAlign: TextAlign.center,
                    "Updating Scores... Please refrain \n from exiting app or tapping other buttons.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
      ]),
    );
  }
}
