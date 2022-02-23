import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class RoomServices{

  static Future<String> createRoom(String currentUserName,int puzzleSize)async{
    final String roomId=CollectionReferences.room.doc().id;
    await CollectionReferences.room.doc(roomId).set({
      'roomId': roomId,
      'puzzleSize': puzzleSize,
      'noOfRounds': 1,
      'roomOwnerName': currentUserName,
      'roomOwnerId': currentUser.userId,
      'roomOwnerImage':'',
      'otherPlayerName': '',
      'otherPlayerId':'',
      'otherPlayerImage': '',
      'gameStarted': false,
      'roomCreatedTimeStamp': FieldValue.serverTimestamp(),
    });
    return roomId;
  }

  static Future<RoomModel?> joinRoom(String roomId, String currentUserName)async{
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).get();
    if(doc.exists){
      bool isRoomOwner=doc['roomOwnerId']==currentUser.userId;
      String userNameField=isRoomOwner?"roomOwnerName":"otherPlayerName";
      String userIdField=isRoomOwner?"roomOwnerId":"otherPlayerId";
      String userImageField=isRoomOwner?"roomOwnerImage":"otherPlayerImage";
      await CollectionReferences.room.doc(roomId).update({
        userNameField: currentUserName,
        userIdField: currentUser.userId,
        userImageField: '',
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

  static Future<void> removeOtherUser(String roomId)async{
    await CollectionReferences.room.doc(roomId).update({
      'otherPlayerName': '',
      'otherPlayerId':'',
      'otherPlayerImage': '',
    });
  }

  static Future<void> startGame(String roomId,int puzzleSize,int noOfRounds)async{
    await CollectionReferences.room.doc(roomId).update({
      'gameStarted': true,
      'puzzleSize': puzzleSize,
      'noOfRounds': noOfRounds,
    });
  }

  static Future<RoomModel> getRoom(String roomId)async{
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).get();
    return RoomModel.fromDocument(doc);
  }

  static void saveBoardPosition(String roomId,List<int> board,int moves){
    CollectionReferences.room.doc(roomId).collection('players').doc(currentUser.userId).set({
      'board': board,
      'moves': moves,
    }).catchError((error)=>print(error));
  }

  static Future<Map<String,dynamic>> getBoardPosition(String roomId,)async{
    Map<String,dynamic> data={
      'board':[],
      'moves':0,
    };
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).collection('players').doc(currentUser.userId).get();
    if(doc.exists){
      data['board']=List.from(doc['board']);
      data['moves']=doc['moves'];
    }
    return data;
  }

  static Future<void> sendMessage(String roomId, String userId, String message)async{
    await CollectionReferences.room.doc(roomId).collection('messages').add({
      'message': message,
      'userId': userId,
    });
  }

}