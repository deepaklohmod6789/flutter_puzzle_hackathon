import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';
import 'package:flutter_puzzle_hackathon/pages/room_page.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController nameEditingController;
  late TextEditingController roomIdEditingController;

  @override
  void initState() {
    nameEditingController=TextEditingController();
    roomIdEditingController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    roomIdEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameEditingController,
            decoration: const InputDecoration(
              hintText: "Username",
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: roomIdEditingController,
            decoration: const InputDecoration(
              hintText: "Room Id",
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyGame())),
            child: const Text("Single Player"),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){
              if(nameEditingController.text.trim().isNotEmpty){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomPage(
                  currentUserName: nameEditingController.text.trim(),
                )));
              } else {
                Dialogs.showToast('Enter name to continue');
              }
            },
            child: const Text("Create Room"),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: ()async{
              if(nameEditingController.text.trim().isEmpty){
                Dialogs.showToast('Enter name to continue');
              } else if(roomIdEditingController.text.trim().isEmpty){
                Dialogs.showToast('Enter room id to continue');
              } else {
                RoomModel? roomModel=await RoomServices.joinRoom(roomIdEditingController.text.trim(), nameEditingController.text.trim());
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomPage(
                  currentUserName: nameEditingController.text.trim(),
                  roomId: roomIdEditingController.text.trim(),
                  roomModel: roomModel,
                )));
              }
            },
            child: const Text("Join Room"),
          ),
        ],
      ),
    );
  }
}
