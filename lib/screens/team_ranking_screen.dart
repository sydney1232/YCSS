import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/screens/teams_screen.dart';

class TeamRanking extends StatefulWidget {
  const TeamRanking({super.key});

  @override
  State<TeamRanking> createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTeamsStreamByScore(),
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
                  String teamText = data['teamName'];
                  int teamScore = data['score'];

                  Text(teamText);
                  return ListTile(
                    title: Text(teamText),
                    subtitle: Text(teamScore.toString()),
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
