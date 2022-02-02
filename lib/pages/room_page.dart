import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/models/game_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';

class RoomPage extends StatefulWidget {
  final RoomArguments? roomArguments;

  const RoomPage({
    Key? key,
    this.roomArguments,
  }) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool navigated=false;
  double _puzzleSize=4.0;
  RoomModel? roomModel;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_){
      if(widget.roomArguments==null){
        FluroRouting.pushAndClearStackToPage(routeName: '/home', context: context);
      }
    });
    if(widget.roomArguments!=null){
      roomModel=widget.roomArguments!.roomModel;
      CollectionReferences.room.doc(widget.roomArguments!.roomId).snapshots().listen((doc) {
        if(doc.exists){
          setState(() {
            roomModel=RoomModel.fromDocument(doc);
          });
          if(!navigated&&roomModel!.gameStarted){
            navigated=true;
            navigateToGame();
          }
        }
      });
    }
    super.initState();
  }

  void createRoom()async{
    widget.roomArguments!.roomId=await RoomServices.createRoom(widget.roomArguments!.currentUserName,_puzzleSize.toInt());
    setState(() {

    });
  }

  void navigateToGame(){
    FluroRouting.navigateToPage(
      context: context,
      routeName: '/game',
      arguments: GameArguments(currentUserName: widget.roomArguments!.currentUserName, roomModel: roomModel!),
    );
  }

  void startGame()async{
    if(roomModel!=null&&roomModel!.users.length==2){
      await RoomServices.startGame(widget.roomArguments!.roomId);
      navigateToGame();
    } else {
      Dialogs.showToast('2 players required to start the game');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text("Select puzzle size:- "),
              const SizedBox(width: 10,),
              StatefulBuilder(
                builder: (context,updateState){
                  return Slider(
                    value: _puzzleSize,
                    max: 5,
                    min: 3,
                    onChanged: (double value) {
                      updateState(() {
                        _puzzleSize = value;
                      });
                    },
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text("Room Id:- "),
              if(widget.roomArguments!.roomId!=' ')
                Text(widget.roomArguments!.roomId),
              if(widget.roomArguments!.roomId!=' ')
                IconButton(
                  onPressed: ()=>Clipboard.setData(ClipboardData(text: widget.roomArguments!.roomId)),
                  icon: const Icon(Icons.copy),
                ),
            ],
          ),
          widget.roomArguments!.roomId==' '?ElevatedButton(
            onPressed: ()=>createRoom(),
            child: const Text("Create Room"),
          ):roomModel!=null&&roomModel!.users.first==widget.roomArguments!.currentUserName?ElevatedButton(
            onPressed: ()=>startGame(),
            child: const Text("Start game"),
          ):const SizedBox(),
          const SizedBox(height: 30,),
          const Text("Joined Players"),
          const SizedBox(height: 20,),
          if(roomModel!=null&&roomModel!.users.length==2)
            Text(roomModel!.users.firstWhere((element) => element!=widget.roomArguments!.currentUserName)),
        ],
      ),
    );
  }
}
