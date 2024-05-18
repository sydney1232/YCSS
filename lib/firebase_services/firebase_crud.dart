import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_utils.dart';

class FirestoreService {
  final CollectionReference teams =
      FirebaseFirestore.instance.collection('teams');

  final CollectionReference scorelogs =
      FirebaseFirestore.instance.collection('scorelogs');

  final CollectionReference messaging =
      FirebaseFirestore.instance.collection('messaging');

  Stream<QuerySnapshot> getTeamsStreamByID() {
    //final teamStream = teams.orderBy('score', descending: true).snapshots();
    final teamStream =
        teams.orderBy(FieldPath.documentId, descending: false).snapshots();
    return teamStream;
  }

  Stream<QuerySnapshot> getTeamsStreamByScore() {
    final teamStream = teams.orderBy('score', descending: true).snapshots();
    return teamStream;
  }

  Future<void> updateScore(String docID, int newScore) {
    return teams.doc(docID).update({
      'score': newScore,
    });
  }

  Future<void> addScoreLogging(String desc) {
    return scorelogs.add({
      'logDesc': desc,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getScoreLogsByTimestamp() {
    //final teamStream = teams.orderBy('score', descending: true).snapshots();
    final logScoreStrem =
        scorelogs.orderBy('timestamp', descending: true).snapshots();
    return logScoreStrem;
  }

  void addScoreToFirestore(int scoreAdded, int newScore, String docID,
      String scoreAuthor, String teamName, int currentScore) {
    //Upload Score
    updateScore(docID!, newScore);

    //Upload Logging
    String phTime = getLocalDateAndTime();
    addScoreLogging(
        "$scoreAuthor added ${scoreAdded}pts to $teamName, from ${currentScore}pts to ${newScore}pts on $phTime");
  }

  void addScoreDeductionToFirestore(
      int scoreDeducted,
      int newScore,
      String docID,
      String scoreAuthor,
      String teamName,
      int currentScore,
      String reason) {
    //Upload Score
    updateScore(docID, newScore);

    //Upload Logging
    String phTime = getLocalDateAndTime();
    addScoreLogging(
        "$scoreAuthor deducted ${scoreDeducted}pts to $teamName, from ${currentScore}pts to ${newScore}pts on $phTime, \n\n Reason: $reason");
  }

  void addScoreFlagCapturedDeductionToFirestore(
      String teamName, int scoreDeduct, String scoreAuthor) {
    String phTime = getLocalDateAndTime();
    addScoreLogging(
        "$teamName's flag has been captured. ${scoreDeduct}pts deducted by $scoreAuthor on $phTime");
  }

  Future<void> addMessaging(String sender, String body) {
    return messaging.add({
      'sender': sender,
      'body': body,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMessagesByTimestamp() {
    final getSMSByTimeStamp =
        messaging.orderBy('timestamp', descending: false).snapshots();
    return getSMSByTimeStamp;
  }
}
