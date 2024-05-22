import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ycss/firebase_services/firebase_crud.dart';

class TeamRanking extends StatefulWidget {
  const TeamRanking({Key? key}) : super(key: key);

  @override
  State<TeamRanking> createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> {
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    //Support Portrait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/leaderboard.png"),
                  ),
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Text(
                            "Leaderboards",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Ends in 7 days",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getTeamsStreamByScore(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List teamList = snapshot.data!.docs;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      //get individual doc
                      DocumentSnapshot document = teamList[index];
                      String docID = document.id;

                      //get team for each doc
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String teamText = data['teamName'];
                      int teamScore = data['score'];

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  teamText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'DIN'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    width: 80,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(
                                          20), // adjust the radius as needed
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow.shade800,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          teamScore.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight
                                                  .bold), // text color
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                      // return ListTile(
                      //   title: Text(teamText),
                      //   subtitle: Text(teamScore.toString()),
                      // );
                    },
                    childCount: teamList.length,
                  ),
                );
              } else {
                return const SliverFillRemaining(
                  child: Center(child: Text("No Teams")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
