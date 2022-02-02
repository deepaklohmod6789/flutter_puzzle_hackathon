import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class RoomServices{

  static Future<String> createRoom(String currentUserName,int puzzleSize)async{
    final String roomId=CollectionReferences.room.doc().id;
    await CollectionReferences.room.doc(roomId).set({
      'roomId': roomId,
      'puzzleSize': puzzleSize,
      'users': [currentUserName],
      'gameStarted': false,
      'roomCreatedTimeStamp': FieldValue.serverTimestamp(),
    });
    return roomId;
  }

  static Future<RoomModel?> joinRoom(String roomId, String currentUserName)async{
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).get();
    if(doc.exists){
      await CollectionReferences.room.doc(roomId).update({
        'users': FieldValue.arrayUnion([currentUserName]),
      }).catchError((error){
        if(error.code=='permission-denied'){
          Dialogs.showToast('Room is full');
        } else {
          Dialogs.showToast('Failed to join room: '+error.toString());
        }
        return null;
      });
      return RoomModel.fromDocument(doc);
    } else {
      Dialogs.showToast('Room does not exist');
      return null;
    }
  }

  static Future<void> startGame(String roomId)async{
    await CollectionReferences.room.doc(roomId).update({
      'gameStarted': true,
    });
  }

  static Future<RoomModel> getRoom(String roomId)async{
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).get();
    return RoomModel.fromDocument(doc);
  }

  static void saveBoardPosition(String roomId, String currentUserName,List<int> board,int moves){
    CollectionReferences.room.doc(roomId).collection('players').doc(currentUserName).set({
      'board': board,
      'moves': moves,
    },SetOptions(merge: true)).catchError((error)=>print(error));
  }

  static Future<Map<String,dynamic>> getBoardPosition(String roomId, String currentUserName)async{
    Map<String,dynamic> data={
      'board':[],
      'moves':0,
    };
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).collection('players').doc(currentUserName).get();
    if(doc.exists){
      data['board']=List.from(doc['board']);
      data['moves']=doc['moves'];
    }
    return data;
  }
}