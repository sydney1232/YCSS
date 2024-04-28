import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder<QuerySnapshot>(
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

                  Text(scoreDesc);
                  return ListTile(
                    title: Text(scoreDesc),
                  );
                });
          } else {
            return Center(child: const Text("No Score Logs"));
          }
        },
      ),
    );
  }
}
