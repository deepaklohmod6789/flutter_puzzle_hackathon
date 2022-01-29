import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool loading=true;
  String roomId=' ';
  double _puzzleSize=5.0;
  late String currentUserName;
  RoomModel? roomModel;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_){
      Object? argument=ModalRoute.of(context)!.settings.arguments;
      if(argument!=null){
        currentUserName= argument as String;
      }
      setState(() {
        loading=false;
      });
    });
    super.initState();
  }

  void createRoom()async{
    roomId=await RoomServices.createRoom(currentUserName,_puzzleSize.toInt());
    setState(() {

    });
  }

  void startGame(){
    if(roomModel!=null&&roomModel!.users.length==2){
      FluroRouting.navigateToMultiPlayerGame(context: context,roomModel: roomModel!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading?const Center(child: CircularProgressIndicator(),):Column(
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
          roomId==' '?ElevatedButton(
            onPressed: ()=>createRoom(),
            child: const Text("Create Room"),
          ):roomModel!=null&&roomModel!.users.first==currentUserName?ElevatedButton(
            onPressed: ()=>startGame(),
            child: const Text("Start game"),
          ):const SizedBox(),
          const SizedBox(height: 30,),
          const Text("Joined Players"),
          const SizedBox(height: 20,),
          StreamBuilder(
            stream: CollectionReferences.room.doc(roomId).snapshots(),
            builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
              if(!snapshot.hasData||!snapshot.data!.exists){
                return const SizedBox();
              }
              roomModel=RoomModel.fromDocument(snapshot.data!);
              if(roomModel!.users.length==2){
                return Text(roomModel!.users.firstWhere((element) => element!=currentUserName));
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
