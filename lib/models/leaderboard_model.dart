import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoardModel{
  final String userId;
  final String username;
  final String image;
  final double score;
  final double timeInSeconds;
  final int rank;

  LeaderBoardModel({
    required this.userId,
    required this.username,
    required this.image,
    required this.score,
    required this.timeInSeconds,
    required this.rank,
  });

  factory LeaderBoardModel.fromDocument(DocumentSnapshot doc,int index){
    return LeaderBoardModel(
      userId: doc['userId'],
      username: doc['username'],
      image: doc['image'],
      score: doc['score'],
      timeInSeconds: doc['timeInSeconds'],
      rank: index+1,
    );
  }

}