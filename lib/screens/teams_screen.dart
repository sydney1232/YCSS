import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ycss/firebase_services/firebase_crud.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

final FirestoreService firestoreService = FirestoreService();

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
                  String teamText = data['teamName'];
                  Text(teamText);
                  return ListTile(
                    title: Text(teamText),
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
