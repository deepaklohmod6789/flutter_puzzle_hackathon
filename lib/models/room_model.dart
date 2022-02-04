import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';

class RoomModel{
  final String roomId;
  final int puzzleSize;
  final bool gameStarted;
  final List<String> userNames;
  final List<String> userIds;
  final DateTime roomCreatedTimeStamp;

  RoomModel({
    required this.roomId,
    required this.puzzleSize,
    required this.gameStarted,
    required this.userNames,
    required this.userIds,
    required this.roomCreatedTimeStamp,
  });

  factory RoomModel.fromDocument(DocumentSnapshot doc){
    return RoomModel(
      roomId: doc['roomId'],
      puzzleSize: doc['puzzleSize'],
      gameStarted: doc['gameStarted'],
      userNames: List.from(doc['userNames']),
      userIds: List.from(doc['userIds']),
      roomCreatedTimeStamp: DateTime.fromMillisecondsSinceEpoch(doc['roomCreatedTimeStamp'].seconds * 1000),
    );
  }

  static RoomModel? fromCookies(){
    String roomId=CookieManager.getCookie('roomId');
    String puzzleSize=CookieManager.getCookie('puzzleSize');
    String gameStarted=CookieManager.getCookie('gameStarted');
    String userNames=CookieManager.getCookie('userNames');
    String userIds=CookieManager.getCookie('userIds');
    String roomCreatedTimeStamp=CookieManager.getCookie('roomCreatedTimeStamp');
    RoomModel? roomModel;
    if(puzzleSize==''||gameStarted==''||userNames==''||roomCreatedTimeStamp==''||userIds==''){
      roomModel=null;
    } else {
      roomModel=RoomModel(
        roomId: roomId,
        puzzleSize: int.parse(puzzleSize),
        gameStarted: gameStarted=='true',
        userNames: (jsonDecode(userNames)as List<dynamic>).cast<String>(),
        userIds: (jsonDecode(userIds)as List<dynamic>).cast<String>(),
        roomCreatedTimeStamp: DateTime.parse(roomCreatedTimeStamp),
      );
    }
    return roomModel;
  }

  static void saveToCookies(RoomModel roomModel){
    CookieManager.addToCookie('roomId', roomModel.roomId);
    CookieManager.addToCookie('puzzleSize', roomModel.puzzleSize.toString());
    CookieManager.addToCookie('gameStarted', roomModel.gameStarted.toString());
    CookieManager.addToCookie('userNames', jsonEncode(roomModel.userNames));
    CookieManager.addToCookie('userIds', jsonEncode(roomModel.userIds));
    CookieManager.addToCookie('roomCreatedTimeStamp', roomModel.roomCreatedTimeStamp.toString());
  }

}