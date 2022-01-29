import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel{
  late final String roomId;
  late final int puzzleSize;
  late final List<String> users;
  late final Timestamp roomCreatedTimeStamp;

  RoomModel({
    required this.roomId,
    required this.puzzleSize,
    required this.users,
    required this.roomCreatedTimeStamp,
  });

  factory RoomModel.fromDocument(DocumentSnapshot doc){
    return RoomModel(
      roomId: doc['roomId'],
      puzzleSize: doc['puzzleSize'],
      users: List.from(doc['users']),
      roomCreatedTimeStamp: doc['roomCreatedTimeStamp'],
    );
  }
}