import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionReferences{
  static final CollectionReference room=FirebaseFirestore.instance.collection('room');
  static final CollectionReference leaderboard=FirebaseFirestore.instance.collection('leaderboard');
}