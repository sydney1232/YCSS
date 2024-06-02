import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/globals.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/models/team_time_info.dart';

import '../constants/color_palette.dart';
import '../firebase_services/firebase_crud.dart';

class TeamTime extends StatefulWidget {
  const TeamTime({super.key});

  @override
  State<TeamTime> createState() => _TeamTimeState();
}

final FirestoreService firestoreService = FirestoreService();
final TextEditingController minutesTextController = TextEditingController();
final TextEditingController secondsTextController = TextEditingController();
final TextEditingController millisecondsTextController =
    TextEditingController();

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

void clearTexts() {
  minutesTextController.text = "";
  secondsTextController.text = "";
  millisecondsTextController.text = "";
}

void addTeamTimeToPreview(
    String docID, String teamName, String time, int timeInMillis) {
  globalTeamInfoList.add(
    TeamTimeInfo(
        docID: docID, teamName: teamName, time: time, timeInMillis: 999),
  );
}

bool isTeamTimeRegistered(String teamDocID) {
  for (var teamInfo in globalTeamInfoList) {
    if (teamInfo.docID.contains(teamDocID)) {
      return true;
    }
  }
  return false;
}

class _TeamTimeState extends State<TeamTime> {
  @override
  void initState() {
    // TODO: implement initState
    clearTexts();
  }

  void openTimeDialog(BuildContext context, String docID, String teamName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _formKey,
          child: SizedBox(
            height: 200, // Adjust height to accommodate text fields
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter Time for $teamName",
                  style: const TextStyle(fontFamily: "TheRift", fontSize: 14),
                ),
                const SizedBox(
                    height:
                        20), // Add some spacing between the text and text fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: minutesTextController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Missing";
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add some spacing between the text fields
                    Expanded(
                      child: TextFormField(
                        controller: secondsTextController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Seconds',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Missing";
                          }
                          int? seconds = int.tryParse(value);
                          if (seconds == null || seconds < 0 || seconds > 59) {
                            return '0-59';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add some spacing between the text fields
                    Expanded(
                      child: TextFormField(
                        controller: millisecondsTextController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Missing";
                          }
                          int? milliseconds = int.tryParse(value);
                          if (milliseconds == null ||
                              milliseconds < 0 ||
                              milliseconds > 999) {
                            return '0-999';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Milliseconds',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(CANCEL),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //Add Team Score to Preview
                          addTeamTimeToPreview(
                            docID,
                            teamName,
                            "${minutesTextController.text}:${secondsTextController.text}:${millisecondsTextController.text}",
                            999,
                          );

                          //Clear Text Fields
                          clearTexts();

                          //Pops the Dialog Screen
                          Navigator.of(context).pop();
                        }

                        // Call setState to Reload Page
                        setState(() {});
                      },
                      child: const Text(OK),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Text(
                    TEAM_TIME_ATTACK,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: lightPink,
                        fontFamily: 'TheRift'),
                  ),
                  SizedBox(height: 40),
                  Text(
                    TAP_TEAM_GET_TIME,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: lightPink,
                        fontFamily: 'DIN'),
                  ),
                ],
              )),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getTeamsStreamByID(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List teamList = snapshot.data!.docs;

                      return ListView.builder(
                          itemCount: teamList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot = teamList[index];
                            //get team for each doc
                            Map<String, dynamic> data =
                                documentSnapshot.data() as Map<String, dynamic>;

                            String teamName = data['teamName'];
                            String teamDocID = documentSnapshot.id;

                            return Padding(
                                padding: const EdgeInsets.only(
                                    left: 40, right: 40, bottom: 10),
                                child: Material(
                                  elevation: 2.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      openTimeDialog(
                                        context,
                                        teamDocID,
                                        teamName,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Visibility(
                                      visible: !isTeamTimeRegistered(teamDocID),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(teamName),
                                            const Icon(
                                                Icons.keyboard_arrow_right),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          });
                    } else {
                      return const Center(
                        child: Text("No Teams"),
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
