import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference teams =
      FirebaseFirestore.instance.collection('teams');

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
}
