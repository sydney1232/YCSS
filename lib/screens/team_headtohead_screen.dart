import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/string_constants.dart';
import 'package:ycss/widgets/team_tile_select_vs.dart';
import 'package:ycss/widgets/team_tile_vs.dart';

import '../constants/color_palette.dart';
import 'capture_the_flag_screen.dart';

class HeadToHeadPage extends StatefulWidget {
  const HeadToHeadPage({Key? key}) : super(key: key);

  @override
  State<HeadToHeadPage> createState() => _HeadToHeadPageState();
}

class _HeadToHeadPageState extends State<HeadToHeadPage> {
  //First Team Pick
  String tempImage = "";
  String tempTeamName = "";
  String tempDocID = "";

  //Second Team Pick
  String tempImage2 = "";
  String tempTeamName2 = "";
  String tempDocID2 = "";

  @override
  Widget build(BuildContext context) {
    void clearTeams() {
      //First Team Pick
      tempImage = "";
      tempTeamName = "";
      tempDocID = "";

      //Second Team Pick
      tempImage2 = "";
      tempTeamName2 = "";
      tempDocID2 = "";
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 80),
              child: const Text(
                HEAD_TO_HEAD,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "TheRift"),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: TeamTileVs(
                          onDoubleTap: () {
                            print("VALUE OF: $tempImage");
                          },
                          imageURL: tempImage,
                          teamName: tempTeamName.toString() == ""
                              ? "Select Team"
                              : tempTeamName,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        child: const Text(
                          "VS.",
                          style: TextStyle(
                              fontFamily: "MaidenCrimes", fontSize: 32),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: TeamTileVs(
                          teamName: tempTeamName2.toString() == ""
                              ? "Select Team"
                              : tempTeamName2,
                          imageURL:
                              tempImage2.toString() == "" ? "" : tempImage2,
                          onDoubleTap: () {},
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          clearTeams();
                        });
                      },
                      icon: const Icon(Icons.delete)),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: const Text(
                      DOUBLE_TAP_TO_DECLARE,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "DIN"),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 250,
              margin: EdgeInsets.only(bottom: 100),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getTeamsStreamByID(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List teamList = snapshot.data!.docs;
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: teamList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = teamList[index];
                          String docID = document.id;

                          //get team for each doc
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          //Get data for each item
                          String teamText = data['teamName'];
                          int currentScore = data['score'];

                          String imageURL =
                              "https://firebasestorage.googleapis.com/v0/b/ycss-f7c20.appspot.com/o/run.png?alt=media&token=723b4dd6-367f-4fb6-9199-b0b1b7ac3957";

                          return TeamTileSelectionVs(
                            onPress: () {
                              setState(() {
                                if (tempImage.toString().isEmpty &&
                                    tempTeamName.toString().isEmpty &&
                                    tempDocID.isEmpty) {
                                  tempImage = imageURL;
                                  tempTeamName = teamText;
                                  tempDocID = docID;
                                } else {
                                  tempImage2 = imageURL;
                                  tempTeamName2 = teamText;
                                  tempDocID2 = docID;
                                }

                                //If user selects the same team
                                if (tempDocID2.toString().contains(tempDocID)) {
                                  tempImage2 = "";
                                  tempTeamName2 = "";
                                  tempDocID2 = "";
                                }
                              });
                            },
                            teamName: teamText,
                            imageURL: imageURL,
                          );
                        });
                  } else {
                    return Center(child: const Text("No Teams"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
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
