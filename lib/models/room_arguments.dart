import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class RoomArguments{
  final String currentUserName;
  String roomId;
  RoomModel? roomModel;
  RoomArguments({required this.currentUserName, this.roomId=' ',this.roomModel});

  static RoomArguments? fromCookies(){
    String roomId=CookieManager.getCookie('roomId');
    String currentUserName=CookieManager.getCookie('currentUserName');
    if(currentUserName==''){
      return null;
    }
    return RoomArguments(
      currentUserName: currentUserName,
      roomId: roomId==''?' ':roomId,
      roomModel: RoomModel.fromCookies(),
    );
  }

  static void saveToCookies(RoomArguments roomArguments){
    CookieManager.addToCookie('currentUserName', roomArguments.currentUserName);
    CookieManager.addToCookie('roomId', roomArguments.roomId);
    if(roomArguments.roomModel!=null){
      RoomModel.saveToCookies(roomArguments.roomModel!);
    }
  }

}