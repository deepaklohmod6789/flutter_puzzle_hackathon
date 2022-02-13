import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/game_version.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/room_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';
import 'package:flutter_puzzle_hackathon/widgets/end_drawer.dart';
import 'package:flutter_puzzle_hackathon/widgets/leaderboard.dart';
import 'package:flutter_puzzle_hackathon/widgets/nav_bar.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';
import 'package:flutter_puzzle_hackathon/widgets/sidebar.dart';
import 'package:marquee/marquee.dart';

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
    nameEditingController.text=currentUser.currentUserName;
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    roomIdEditingController.dispose();
    super.dispose();
  }

  Widget old(){
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
            onPressed: (){
              CookieManager.deleteMultiplayerGameCookies();
              FluroRouting.navigateToPage(routeName: '/game', context: context);
            },
            child: const Text("Single Player"),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){
              if(nameEditingController.text.trim().isNotEmpty){
                currentUser.currentUserName=nameEditingController.text.trim();
                FluroRouting.navigateToPage(
                  routeName: '/room',
                  context: context,
                  arguments: RoomArguments(currentUserName: nameEditingController.text.trim()),
                );
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
                currentUser.currentUserName=nameEditingController.text.trim();
                RoomModel? roomModel=await RoomServices.joinRoom(roomIdEditingController.text.trim(), nameEditingController.text.trim());
                FluroRouting.navigateToPage(
                  routeName: '/room',
                  context: context,
                  arguments: RoomArguments(
                    currentUserName: nameEditingController.text.trim(),
                    roomId: roomIdEditingController.text.trim(),
                    roomModel: roomModel,
                  ),
                );
              }
            },
            child: const Text("Join Room"),
          ),
        ],
      ),
    );
  }

  Column content(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NavBar(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left:Responsive.isDesktop(context)?20.0:30.0,right: Responsive.isDesktop(context)?0:50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Supreme Star",
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context)?45:60,
                    color: Themes.primaryColor,
                    fontWeight: Responsive.isDesktop(context)?null:FontWeight.bold,
                  ),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no ',
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context)?20:28,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
                TextButton.icon(
                  onPressed: (){},
                  label: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
                  icon: Text(
                    "play now",
                    style: TextStyle(color: Colors.white,fontSize: Responsive.isDesktop(context)?16:24),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Themes.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.isDesktop(context)?30:35,
                      vertical: Responsive.isDesktop(context)?20:25,
                    ),
                  ),
                ),
                Responsive.isDesktop(context)?Text(
                  "Version "+GameVersion.getCurrentVersion(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xb5ffffff),
                  ),
                  textAlign: TextAlign.left,
                ):const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      onEndDrawerChanged: (bool isOpened){

      },
      endDrawer: const EndDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SideBar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Responsive.isDesktop(context)?20:30,
                    color: Colors.black,
                    child: Marquee(
                      blankSpace: 5,
                      text: 'There once was a boy who told this story about a boy: "',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.isDesktop(context)?13:20,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'PUZZLE BUSTER',
                          style: TextStyle(
                            fontSize: 150,
                            fontFamily: 'BigSpace',
                            letterSpacing: 5,
                            decorationStyle: TextDecorationStyle.wavy,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeCap = StrokeCap.round
                              ..strokeJoin = StrokeJoin.round
                              ..strokeWidth = 2.5
                              ..color = Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.isDesktop(context)?0:10,),
                  Expanded(
                    child: Responsive.isDesktop(context)?Row(
                      children: [
                        Expanded(
                          flex: Responsive.isDesktop(context)?1:3,
                          child: content(),
                        ),
                        Expanded(
                          flex: Responsive.isDesktop(context)?1:2,
                          child: const LeaderBoard(),
                        ),
                      ],
                    ):Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: content(),
                        ),
                        const Expanded(
                          flex: 3,
                          child: LeaderBoard(),
                        ),
                        Responsive.isDesktop(context)?const SizedBox():Padding(
                          padding: const EdgeInsets.fromLTRB(30,20,0,30),
                          child: Text(
                            "Version "+GameVersion.getCurrentVersion(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xb5ffffff),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
