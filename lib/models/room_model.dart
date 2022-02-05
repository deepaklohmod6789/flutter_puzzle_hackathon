import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';

class RoomModel{
  final String roomId;
  final int puzzleSize;
  final bool gameStarted;
  final String roomOwnerId;
  final String roomOwnerName;
  final String otherPlayerId;
  final String otherPlayerName;
  final DateTime roomCreatedTimeStamp;

  RoomModel({
    required this.roomId,
    required this.puzzleSize,
    required this.gameStarted,
    required this.roomOwnerId,
    required this.roomOwnerName,
    required this.otherPlayerId,
    required this.otherPlayerName,
    required this.roomCreatedTimeStamp,
  });

  factory RoomModel.fromDocument(DocumentSnapshot doc){
    return RoomModel(
      roomId: doc['roomId'],
      puzzleSize: doc['puzzleSize'],
      gameStarted: doc['gameStarted'],
      roomOwnerId: doc['roomOwnerId'],
      roomOwnerName: doc['roomOwnerName'],
      otherPlayerId: doc['otherPlayerId'],
      otherPlayerName: doc['otherPlayerName'],
      roomCreatedTimeStamp: DateTime.fromMillisecondsSinceEpoch(doc['roomCreatedTimeStamp'].seconds * 1000),
    );
  }

  static RoomModel? fromCookies(){
    String roomId=CookieManager.getCookie('roomId');
    String puzzleSize=CookieManager.getCookie('puzzleSize');
    String gameStarted=CookieManager.getCookie('gameStarted');
    String roomOwnerId=CookieManager.getCookie('roomOwnerId');
    String roomOwnerName=CookieManager.getCookie('roomOwnerName');
    String otherPlayerId=CookieManager.getCookie('otherPlayerId');
    String otherPLayerName=CookieManager.getCookie('otherPlayerName');
    String roomCreatedTimeStamp=CookieManager.getCookie('roomCreatedTimeStamp');
    RoomModel? roomModel;
    if(puzzleSize==''||gameStarted==''||roomOwnerId==''||roomOwnerName==''||otherPlayerId==''||otherPLayerName==''||roomCreatedTimeStamp==''){
      roomModel=null;
    } else {
      roomModel=RoomModel(
        roomId: roomId,
        puzzleSize: int.parse(puzzleSize),
        gameStarted: gameStarted=='true',
        otherPlayerName: otherPLayerName,
        otherPlayerId: otherPlayerId,
        roomOwnerName: roomOwnerName,
        roomOwnerId: roomOwnerId,
        roomCreatedTimeStamp: DateTime.parse(roomCreatedTimeStamp),
      );
    }
    return roomModel;
  }

  static void saveToCookies(RoomModel roomModel){
    CookieManager.addToCookie('roomId', roomModel.roomId);
    CookieManager.addToCookie('puzzleSize', roomModel.puzzleSize.toString());
    CookieManager.addToCookie('gameStarted', roomModel.gameStarted.toString());
    CookieManager.addToCookie('roomOwnerId', roomModel.roomOwnerId);
    CookieManager.addToCookie('roomOwnerName', roomModel.roomOwnerName);
    CookieManager.addToCookie('otherPlayerId', roomModel.otherPlayerId);
    CookieManager.addToCookie('otherPlayerName', roomModel.otherPlayerName);
    CookieManager.addToCookie('roomCreatedTimeStamp', roomModel.roomCreatedTimeStamp.toString());
  }

}