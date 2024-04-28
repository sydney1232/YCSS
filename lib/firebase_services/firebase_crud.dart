import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_utils.dart';

class FirestoreService {
  final CollectionReference teams =
      FirebaseFirestore.instance.collection('teams');

  final CollectionReference scorelogs =
      FirebaseFirestore.instance.collection('scorelogs');

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
}
