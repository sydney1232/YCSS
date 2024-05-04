import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/widgets/team_capture_flag_tile.dart';

import '../firebase_services/firebase_crud.dart';

class CaptureFlagPage extends StatefulWidget {
  const CaptureFlagPage({Key? key}) : super(key: key);

  @override
  State<CaptureFlagPage> createState() => _CaptureFlagPageState();
}

final FirestoreService firestoreService = FirestoreService();

class _CaptureFlagPageState extends State<CaptureFlagPage> {
  void showConfirmationDialog(String docID, String teamName, int currentScore) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Flag Captured?",
      desc: "${teamName} will be deducted 50 points. ",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        int newScore = currentScore - 50;
        firestoreService.updateScore(docID, newScore);
        showSuccessDialog(teamName);
      },
      btnOkText: "Confirm",
    ).show();
  }

  void showSuccessDialog(String teamName) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Score Updated",
      desc: "$teamName score is deducted.",
      btnOkOnPress: () {},
      btnOkText: "Confirm",
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              CAPTURE_THE_FLAG,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                        if (index != teamList.length - 1) {
                          //Checking if it is in the last index, it will give sizedBox to adjust between home button and FlagCaptureTile
                          return InkWell(
                              onTap: () {},
                              child: FlagCaptureTile(
                                teamName: teamText,
                                onLongPress: () {
                                  showConfirmationDialog(
                                      docID, teamText, currentScore);
                                },
                              ));
                        } else {
                          return Column(
                            children: [
                              InkWell(
                                  onTap: () {},
                                  child: FlagCaptureTile(
                                    teamName: teamText,
                                    onLongPress: () {
                                      showConfirmationDialog(
                                          docID, teamText, currentScore);
                                    },
                                  )),
                              SizedBox(height: 150),
                            ],
                          );
                        }
                      });
                } else {
                  return Center(child: const Text("No Teams"));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50),
        height: 70,
        width: 70,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            size: 40,
            Icons.home,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
