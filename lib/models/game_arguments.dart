import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class GameArguments{
  final RoomModel roomModel;
  final String currentUserName;
  GameArguments({required this.roomModel,required this.currentUserName});
}