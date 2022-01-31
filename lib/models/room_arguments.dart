import 'package:flutter_puzzle_hackathon/models/room_model.dart';

class RoomArguments{
  final String currentUserName;
  String roomId;
  RoomModel? roomModel;
  RoomArguments({required this.currentUserName, this.roomId=' ',this.roomModel});
}