import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';

class RoomModel{
  late final String roomId;
  late final int puzzleSize;
  late final bool gameStarted;
  late final List<String> users;
  late final DateTime roomCreatedTimeStamp;

  RoomModel({
    required this.roomId,
    required this.puzzleSize,
    required this.gameStarted,
    required this.users,
    required this.roomCreatedTimeStamp,
  });

  factory RoomModel.fromDocument(DocumentSnapshot doc){
    return RoomModel(
      roomId: doc['roomId'],
      puzzleSize: doc['puzzleSize'],
      gameStarted: doc['gameStarted'],
      users: List.from(doc['users']),
      roomCreatedTimeStamp: DateTime.fromMillisecondsSinceEpoch(doc['roomCreatedTimeStamp'].seconds * 1000),
    );
  }

  static RoomModel? fromCookies(){
    String roomId=CookieManager.getCookie('roomId');
    String puzzleSize=CookieManager.getCookie('puzzleSize');
    String gameStarted=CookieManager.getCookie('gameStarted');
    String users=CookieManager.getCookie('users');
    String roomCreatedTimeStamp=CookieManager.getCookie('roomCreatedTimeStamp');
    RoomModel? roomModel;
    if(puzzleSize==''||gameStarted==''||users==''||roomCreatedTimeStamp==''){
      roomModel=null;
    } else {
      roomModel=RoomModel(
        roomId: roomId,
        puzzleSize: int.parse(puzzleSize),
        gameStarted: gameStarted=='true',
        users: (jsonDecode(users)as List<dynamic>).cast<String>(),
        roomCreatedTimeStamp: DateTime.parse(roomCreatedTimeStamp),
      );
    }
    return roomModel;
  }

  static void saveToCookies(RoomModel roomModel){
    CookieManager.addToCookie('roomId', roomModel.roomId);
    CookieManager.addToCookie('puzzleSize', roomModel.puzzleSize.toString());
    CookieManager.addToCookie('gameStarted', roomModel.gameStarted.toString());
    CookieManager.addToCookie('users', jsonEncode(roomModel.users));
    CookieManager.addToCookie('roomCreatedTimeStamp', roomModel.roomCreatedTimeStamp.toString());
  }

}