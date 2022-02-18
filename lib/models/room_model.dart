import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';

class RoomModel{
  final String roomId;
  final int puzzleSize;
  final int noOfRounds;
  final bool gameStarted;
  final String roomOwnerId;
  final String roomOwnerName;
  final String roomOwnerImage;
  final String otherPlayerId;
  final String otherPlayerName;
  final String otherPlayerImage;
  final DateTime roomCreatedTimeStamp;

  RoomModel({
    required this.roomId,
    required this.puzzleSize,
    required this.noOfRounds,
    required this.gameStarted,
    required this.roomOwnerId,
    required this.roomOwnerName,
    required this.roomOwnerImage,
    required this.otherPlayerId,
    required this.otherPlayerName,
    required this.otherPlayerImage,
    required this.roomCreatedTimeStamp,
  });

  factory RoomModel.fromDocument(DocumentSnapshot doc){
    return RoomModel(
      roomId: doc['roomId'],
      puzzleSize: doc['puzzleSize'],
      noOfRounds: doc['noOfRounds'],
      gameStarted: doc['gameStarted'],
      roomOwnerId: doc['roomOwnerId'],
      roomOwnerName: doc['roomOwnerName'],
      roomOwnerImage: doc['roomOwnerImage'],
      otherPlayerId: doc['otherPlayerId'],
      otherPlayerName: doc['otherPlayerName'],
      otherPlayerImage: doc['otherPlayerImage'],
      roomCreatedTimeStamp: DateTime.fromMillisecondsSinceEpoch(doc['roomCreatedTimeStamp'].seconds * 1000),
    );
  }

  static RoomModel? fromCookies(){
    String roomId=CookieManager.getCookie('roomId');
    String puzzleSize=CookieManager.getCookie('puzzleSize');
    String noOfRounds=CookieManager.getCookie('noOfRounds');
    String gameStarted=CookieManager.getCookie('gameStarted');
    String roomOwnerId=CookieManager.getCookie('roomOwnerId');
    String roomOwnerName=CookieManager.getCookie('roomOwnerName');
    String roomOwnerImage=CookieManager.getCookie('roomOwnerImage');
    String otherPlayerId=CookieManager.getCookie('otherPlayerId');
    String otherPLayerName=CookieManager.getCookie('otherPlayerName');
    String otherPLayerImage=CookieManager.getCookie('otherPlayerImage');
    String roomCreatedTimeStamp=CookieManager.getCookie('roomCreatedTimeStamp');
    RoomModel? roomModel;
    if(puzzleSize==''||gameStarted==''||roomOwnerId==''||roomOwnerName==''||otherPlayerId==''||otherPLayerName==''||roomCreatedTimeStamp==''){
      roomModel=null;
    } else {
      roomModel=RoomModel(
        roomId: roomId,
        puzzleSize: int.parse(puzzleSize),
        noOfRounds: int.parse(noOfRounds),
        gameStarted: gameStarted=='true',
        otherPlayerName: otherPLayerName,
        otherPlayerId: otherPlayerId,
        otherPlayerImage: otherPLayerImage,
        roomOwnerName: roomOwnerName,
        roomOwnerId: roomOwnerId,
        roomOwnerImage: roomOwnerImage,
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