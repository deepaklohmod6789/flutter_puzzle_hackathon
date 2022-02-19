import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/game_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/models/waiting_room_user.dart';
import 'package:flutter_puzzle_hackathon/pages/game_settings.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';
import 'package:flutter_puzzle_hackathon/widgets/start_playing_painter.dart';
import 'package:flutter_puzzle_hackathon/widgets/waiting_room_card.dart';

class WaitingRoom extends StatefulWidget {
  final Function onClose;
  final String roomId;

  const WaitingRoom({Key? key, required this.roomId,required this.onClose}) : super(key: key);

  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  bool loading=true;
  bool navigated=false;
  int _puzzleSize=3;
  int _noOfRounds=1;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  RoomModel? roomModel;
  WaitingRoomUser? roomOwnerBoard;
  WaitingRoomUser? otherPlayerBoard;


  @override
  void initState() {
    CollectionReferences.room.doc(widget.roomId).snapshots().listen((doc) {
      if(doc.exists){
        roomModel=RoomModel.fromDocument(doc);
        _noOfRounds=roomModel!.noOfRounds;
        _puzzleSize=roomModel!.puzzleSize;
        roomOwnerBoard=WaitingRoomUser(
          userId: roomModel!.roomOwnerId,
          userName: roomModel!.roomOwnerName,
          userImage: 'https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
        );
        otherPlayerBoard=WaitingRoomUser(
          userId: roomModel!.otherPlayerId,
          userName: roomModel!.otherPlayerName,
          userImage: roomModel!.otherPlayerImage,
        );
        setState(() {
          loading=false;
        });
        if(roomModel!.otherPlayerId!=currentUser.userId&&roomModel!.roomOwnerId!=currentUser.userId){
          CookieManager.deleteMultiplayerGameCookies();
          FluroRouting.navigateToPage(routeName: '/home', context: context);
          Dialogs.showToast('You were removed from the room');
        }
        if(!navigated&&roomModel!.gameStarted){
          navigated=true;
          navigateToGame();
        }
      }
    });
    super.initState();
  }

  void removeOtherPlayer(){
    RoomServices.removeOtherUser(widget.roomId);
  }

  void navigateToGame(){
    FluroRouting.navigateToPage(
      context: context,
      routeName: '/game',
      arguments: GameArguments(currentUserName: currentUser.currentUserName, roomModel: roomModel!),
    );
  }

  void startGame()async{
    if(roomModel!=null&&roomModel!.otherPlayerId!=''){
      await RoomServices.startGame(
        widget.roomId,
        _puzzleSize,
        _noOfRounds,
      );
      navigateToGame();
    } else {
      Dialogs.showToast('2 players required to start the game');
    }
  }

  List<Widget> child(BoxConstraints constraints){
    return [
      SizedBox(
        height: Responsive.isDesktop(context)?constraints.biggest.height*0.6:constraints.biggest.height*0.4,
        child: WaitingRoomCard(waitingRoomUser: roomOwnerBoard!,),
      ),
      Text(
        'VS',
        style: TextStyle(
          fontSize: Responsive.size(context, mobile: 30, tablet: 35, desktop: 35),
          color: Themes.primaryColor,
        ),
        textAlign: TextAlign.left,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          otherPlayerBoard!.userId==""?Text(
            'Waiting to join',
            style: TextStyle(
              fontSize: Responsive.size(context, mobile: 18, tablet: 24, desktop: 16),
              color: const Color(0x5cffffff),
            ),
            textAlign: TextAlign.left,
          ):const SizedBox(),
          const SizedBox(height: 5,),
          SizedBox(
            height: Responsive.isDesktop(context)?constraints.biggest.height*0.6:constraints.biggest.height*0.4,
            child: WaitingRoomCard(waitingRoomUser: otherPlayerBoard!,),
          ),
          const SizedBox(height: 5,),
          otherPlayerBoard!.userId!=''&&roomOwnerBoard!.userId==currentUser.userId?TextButton(
            onPressed: ()=>removeOtherPlayer(),
            child: Text(
              'Remove',
              style: TextStyle(
                fontSize: Responsive.size(context, mobile: 16, tablet: 20, desktop: 14),
                color: const Color(0xffff0000),
              ),
              textAlign: TextAlign.left,
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
          ):const SizedBox(),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _key,
      drawerEnableOpenDragGesture: false,
      drawer: SizedBox(
        width: Responsive.isMobile(context)?MediaQuery.of(context).size.width*0.75:MediaQuery.of(context).size.width*0.55,
        child: Drawer(
          child: GameSettings(
            puzzleSize: _puzzleSize,
            noOfRounds: _noOfRounds,
            onUpdate: (Map<String,int> value){
              setState(() {
                _noOfRounds=value['noOfRounds']!;
                _puzzleSize=value['puzzleSize']!;
              });
            },
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xe8000000),
        child: loading?const Center(child: CircularProgressIndicator(),):Row(
          children: [
            Responsive.isDesktop(context)?SizedBox(
              width: 300,
              height: double.infinity,
              child: GameSettings(
                puzzleSize: _puzzleSize,
                noOfRounds: _noOfRounds,
                onUpdate: (Map<String,int> value){
                  setState(() {
                    _noOfRounds=value['noOfRounds']!;
                    _puzzleSize=value['puzzleSize']!;
                  });
                },
              ),
            ):const SizedBox(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: Responsive.isTablet(context)?10:0,),
                        Responsive.isDesktop(context)? const SizedBox():IconButton(
                          onPressed: ()=>_key.currentState!.openDrawer(),
                          icon: Icon(Icons.settings_outlined,color: Colors.white,size: Responsive.isTablet(context)?35:28,),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: ()=>widget.onClose(),
                          icon: Icon(Icons.close,color: Themes.primaryColor,size: Responsive.isTablet(context)?32:25,),
                        ),
                        SizedBox(width: Responsive.isTablet(context)?10:0,),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: LayoutBuilder(
                      builder: (context,constraints) {
                        return Responsive.isDesktop(context)?SizedBox(
                          width: constraints.biggest.width*0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: child(constraints),
                          ),
                        ):Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: child(constraints),
                        );
                      }
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: roomModel!.roomOwnerId==currentUser.userId?Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: TextButton(
                          onPressed: ()=>startGame(),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          child: CustomPaint(
                            painter: StartPlayingPainter(context, 'Start Playing'),
                            size: Size(Responsive.size(context, mobile: 140, tablet: 200, desktop: 200), 30),
                          ),
                        ),
                      ),
                    ):const SizedBox(),
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
