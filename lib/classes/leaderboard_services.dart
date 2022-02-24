import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/models/leaderboard_model.dart';

class LeaderboardServices{

  static Future<void> saveResult(String userId,String username,String image, int score, int seconds)async{
    try{
      await CollectionReferences.leaderboard.add({
        'timeStamp': DateTime.now(),
        'userId': userId,
        'username': username,
        'image': image,
        'score': score,
        'timeInSeconds': seconds,
      });
    } catch (error){
      Dialogs.showToast(error.toString());
    }
  }

  static Future<List<LeaderBoardModel>> getLeaderBoard()async{
    List<LeaderBoardModel> list=[];
    QuerySnapshot snapshot=await CollectionReferences.leaderboard
        .orderBy('score',descending: true)
        .orderBy('timeInSeconds',descending: false)
        .orderBy('timeStamp',descending: true)
        .limit(10).get();
    if(snapshot.docs.isNotEmpty){
      for(int index=0;index<snapshot.docs.length;index++){
        list.add(LeaderBoardModel.fromDocument(snapshot.docs[index], index));
      }
    }
    return list;
  }

}