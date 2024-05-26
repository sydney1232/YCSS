import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';

import 'capture_the_flag_screen.dart';

class ScoreLogsScreen extends StatefulWidget {
  const ScoreLogsScreen({Key? key}) : super(key: key);

  @override
  State<ScoreLogsScreen> createState() => _ScoreLogsScreenState();
}

class _ScoreLogsScreenState extends State<ScoreLogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: purple,
        appBar: AppBar(
          iconTheme: IconThemeData(color: lightPink),
          backgroundColor: blue,
          centerTitle: true,
          title: Text(
            "Score Logs",
            style: TextStyle(color: lightPink, fontWeight: FontWeight.bold),
          ),
          toolbarHeight: 100,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getScoreLogsByTimestamp(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List scoreList = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: scoreList.length,
                          itemBuilder: (context, index) {
                            //get individual doc
                            DocumentSnapshot document = scoreList[index];
                            String docID = document.id;

                            //get score log for each doc
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            String scoreDesc = data['logDesc'];

                            return Container(
                              color: lightPink,
                              child:
                                  Table(border: TableBorder.all(), children: [
                                TableRow(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                          scoreDesc,
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            );
                            // return Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(width: 2.0),
                            //   ),
                            //   child: ListTile(
                            //     title: Text(scoreDesc),
                            //   ),
                            // );
                          });
                    } else {
                      return Center(child: const Text("No Score Logs"));
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
