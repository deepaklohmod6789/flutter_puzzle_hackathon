import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';

class RoomPage extends StatefulWidget {
  final String currentUserName;
  String roomId;
  RoomModel? roomModel;

  RoomPage({
    Key? key,
    required this.currentUserName,
    this.roomId=' ',
    this.roomModel,
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
    roomModel=widget.roomModel;
    CollectionReferences.room.doc(widget.roomId).snapshots().listen((doc) {
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
    super.initState();
  }

  void createRoom()async{
    widget.roomId=await RoomServices.createRoom(widget.currentUserName,_puzzleSize.toInt());
    setState(() {

    });
  }

  void navigateToGame(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyGame(currentUserName: widget.currentUserName, roomModel: roomModel!)));
  }

  void startGame()async{
    if(roomModel!=null&&roomModel!.users.length==2){
      await RoomServices.startGame(widget.roomId);
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
                    max: 6,
                    min: 2,
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
              if(widget.roomId!=' ')
                Text(widget.roomId),
              if(widget.roomId!=' ')
                IconButton(
                  onPressed: ()=>Clipboard.setData(ClipboardData(text: widget.roomId)),
                  icon: const Icon(Icons.copy),
                ),
            ],
          ),
          widget.roomId==' '?ElevatedButton(
            onPressed: ()=>createRoom(),
            child: const Text("Create Room"),
          ):roomModel!=null&&roomModel!.users.first==widget.currentUserName?ElevatedButton(
            onPressed: ()=>startGame(),
            child: const Text("Start game"),
          ):const SizedBox(),
          const SizedBox(height: 30,),
          const Text("Joined Players"),
          const SizedBox(height: 20,),
          if(roomModel!=null&&roomModel!.users.length==2)
            Text(roomModel!.users.firstWhere((element) => element!=widget.currentUserName)),
        ],
      ),
    );
  }
}
