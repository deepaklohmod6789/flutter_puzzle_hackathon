import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class GameArguments{
  final RoomModel roomModel;
  final String currentUserName;
  GameArguments({required this.roomModel,required this.currentUserName});

  static GameArguments? fromCookies(){
    String currentUserName=CookieManager.getCookie('currentUserName');
    RoomModel? roomModel=RoomModel.fromCookies();
    if(roomModel==null||currentUserName==''){
      return null;
    }
    return GameArguments(
      currentUserName: currentUserName,
      roomModel: roomModel,
    );
  }

  static void saveToCookies(GameArguments gameArguments){
    CookieManager.addToCookie('currentUserName', gameArguments.currentUserName);
    RoomModel.saveToCookies(gameArguments.roomModel);
  }

}