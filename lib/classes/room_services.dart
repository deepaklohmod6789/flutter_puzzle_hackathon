import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class RoomServices{

  static Future<String> createRoom(String currentUserName,int puzzleSize)async{
    final String roomId=CollectionReferences.room.doc().id;
    await CollectionReferences.room.doc(roomId).set({
      'roomId': roomId,
      'puzzleSize': puzzleSize,
      'users': [currentUserName],
      'roomCreatedTimeStamp': FieldValue.serverTimestamp(),
    });
    return roomId;
  }

  static Future<void> joinRoom(String roomId, String currentUserName)async{
    bool joined=true;
    await CollectionReferences.room.doc(roomId).update({
      'users': FieldValue.arrayUnion([currentUserName]),
    }).catchError((error){
      joined=false;
      if(error.code=='permission-denied'){
        print(error);
      } else {
        print('Failed to join room: '+error.toString());
      }
    });
  }

  static Future<RoomModel> getRoom(String roomId)async{
    DocumentSnapshot doc=await CollectionReferences.room.doc(roomId).get();
    return RoomModel.fromDocument(doc);
  }
}