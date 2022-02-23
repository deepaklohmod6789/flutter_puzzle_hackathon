import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/game_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/puzzle_board.dart';
import 'package:flutter_puzzle_hackathon/widgets/other_player_board.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';
import 'package:flutter_puzzle_hackathon/widgets/username_widget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TestBoard extends StatefulWidget {
  final GameArguments? gameArguments;

  const TestBoard({
    Key? key,
    this.gameArguments,
  }) : super(key: key);

  @override
  _TestBoardState createState() => _TestBoardState();
}

class _TestBoardState extends State<TestBoard> with SingleTickerProviderStateMixin{
  final GlobalKey<PuzzleBoardState> _puzzleKey = GlobalKey();
  int round=1;
  static const double degrees=60.0;
  static const double tilePadding=10.0;
  static const List<String> _quickChats=['You are going too fast',"You can't defeat me",'Better luck next time','Ha ha, you can defeat me?'];
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotateAnimation;
  Board? otherPlayerBoard;
  late Board currentPlayerBoard;
  late TextEditingController messageEditingController;
  late final StopWatchTimer stopWatchTimer;

  @override
  void initState() {
    stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp,);
    startTimer();
    messageEditingController=TextEditingController();
    animationController=AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    rotateAnimation=Tween(begin: degrees,end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    scaleAnimation=Tween(begin: 0.5,end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    getBoards();
    Future.delayed(const Duration(seconds: 1),(){
      animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() async{
    messageEditingController.dispose();
    animationController.dispose();
    await stopWatchTimer.dispose();
    super.dispose();
  }

  void startTimer()async{
    stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void getBoards(){
    if(widget.gameArguments!=null){
      bool isRoomOwner=widget.gameArguments!.roomModel.roomOwnerId==currentUser.userId;
      otherPlayerBoard=Board(
        maxRows: widget.gameArguments!.roomModel.puzzleSize,
        tilePadding: tilePadding,
        isOtherPlayerBoard: true,
        roomModel: widget.gameArguments!.roomModel,
        userId: isRoomOwner?widget.gameArguments!.roomModel.otherPlayerId:widget.gameArguments!.roomModel.roomOwnerId,
        userName: isRoomOwner?widget.gameArguments!.roomModel.otherPlayerName:widget.gameArguments!.roomModel.roomOwnerName,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      );
      currentPlayerBoard=Board(
        maxRows: widget.gameArguments!.roomModel.puzzleSize,
        userId: isRoomOwner?widget.gameArguments!.roomModel.roomOwnerId:widget.gameArguments!.roomModel.otherPlayerId,
        userName: isRoomOwner?widget.gameArguments!.roomModel.roomOwnerName:widget.gameArguments!.roomModel.otherPlayerName,
        tilePadding: tilePadding,
        isOtherPlayerBoard: false,
        roomModel: widget.gameArguments!.roomModel,
        puzzleKey: _puzzleKey,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      );
    } else {
      currentPlayerBoard=Board(
        maxRows: 4,
        tilePadding: tilePadding,
        isOtherPlayerBoard: false,
        puzzleKey: _puzzleKey,
        animationController: animationController,
        scaleAnimation: scaleAnimation,
        rotateAnimation: rotateAnimation,
      );
    }
  }

  void sendMessage(String message){
    if(message.trim().isNotEmpty){
      messageEditingController.clear();
      RoomServices.sendMessage(widget.gameArguments!.roomModel.roomId, currentUser.userId, message);
    } else {
      Dialogs.showToast("Message can't be empty");
    }
  }

  Container roundBlock(){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 5,bottom: 5,),
      color: const Color(0xff191919),
      child: Column(
        children: [
          Text(
            'ROUNDS',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Responsive.size(context, mobile: 14, tablet: 22, desktop: 16),
              color: Colors.white,
              letterSpacing: 0.299,
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            '${round.toString()} / 3',
            style: TextStyle(
              fontSize: Responsive.size(context, mobile: 28, tablet: 40, desktop: 30),
              letterSpacing: 3,
              color: Themes.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Container timerBlock(){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 5,bottom: 5),
      color: const Color(0xff191919),
      child: Column(
        children: [
          Text(
            'TIME',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: Responsive.size(context, mobile: 14, tablet: 22, desktop: 16),
              color: Colors.white,
              letterSpacing: 0.299,
            ),
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
            stream: stopWatchTimer.rawTime,
            builder: (context,AsyncSnapshot<int> snapshot){
              if(!snapshot.hasData){
                return Text(
                  '00 : 00',
                  style: TextStyle(
                    fontSize: Responsive.size(context, mobile: 28, tablet: 40, desktop: 30),
                    letterSpacing: 3,
                    color: Themes.primaryColor,
                  ),
                );
              }
              return Text(
                StopWatchTimer.getDisplayTime(snapshot.data!,milliSecond: false,hours: false),
                style: TextStyle(
                  fontSize: Responsive.size(context, mobile: 28, tablet: 40, desktop: 30),
                  letterSpacing: 3,
                  color: Themes.primaryColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IntrinsicHeight textFields(){
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageEditingController,
              style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.isDesktop(context)?15:20,
              ),
              decoration: InputDecoration(
                hintText: 'Type Something...',
                hintStyle: TextStyle(
                  fontSize: Responsive.isDesktop(context)?15:20,
                  color: const Color(0x75ffffff),
                ),
                fillColor: const Color(0xff1e1e1e),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8,),
          Container(
            color: const Color(0xff161616),
            width: Responsive.isDesktop(context)?null:60,
            height: Responsive.isDesktop(context)?null:60,
            child: IconButton(
              onPressed: ()=>sendMessage(messageEditingController.text),
              icon: Icon(
                Icons.upload_outlined,
                color: Themes.primaryColor,
                size: Responsive.isDesktop(context)?null:40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row battleBlock(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Responsive.isMobile(context)?43:90,
          height: Responsive.isMobile(context)?43:90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white,width: 2),
            borderRadius: BorderRadius.circular(6.0),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: Responsive.isMobile(context)?5:20,),
        Text(
          'VS',
          style: TextStyle(
            fontSize: Responsive.size(context, mobile: 25, tablet: 30, desktop: 20),
            fontFamily: 'BigSpace',
            letterSpacing: 3,
            decorationStyle: TextDecorationStyle.wavy,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..strokeWidth = Responsive.isDesktop(context)?1:2
              ..color = Themes.primaryColor,
          ),
        ),
        SizedBox(width: Responsive.isMobile(context)?5:20,),
        Container(
          width: Responsive.isMobile(context)?43:90,
          height: Responsive.isMobile(context)?43:90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white,width: 2),
            borderRadius: BorderRadius.circular(6.0),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.bgColor,
      body: Responsive(
        mobile: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: roundBlock(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: battleBlock(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: timerBlock(),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height*0.35,
              child: otherPlayerBoard!,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height*0.35,
              child: currentPlayerBoard,
            ),
            textFields(),
          ],
        ),
        tablet: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: roundBlock(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: battleBlock(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: timerBlock(),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height*0.35,
              child: otherPlayerBoard!,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height*0.35,
              child: currentPlayerBoard,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.75,
              child: textFields(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              child: otherPlayerBoard!,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8,0,8,8),
                      decoration: const BoxDecoration(
                        color: Themes.lightColor,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(6),bottomRight: Radius.circular(6)),
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          battleBlock(),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: roundBlock(),
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                child: timerBlock(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8,0,8,8),
                      padding: const EdgeInsets.fromLTRB(8,0,8,8),
                      decoration: BoxDecoration(
                        color: Themes.lightColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(_quickChats.length, (index){
                                  return TextButton(
                                    onPressed: ()=>sendMessage(_quickChats[index]),
                                    child: Text(_quickChats[index],),
                                    style: TextButton.styleFrom().copyWith(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(const Color(0xff161616),),
                                      minimumSize: MaterialStateProperty.all(const Size(double.infinity,70)),
                                      foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return Themes.primaryColor;
                                        }
                                        if (states.contains(MaterialState.pressed)) {
                                          return Colors.blue;
                                        }
                                        return const Color(0x8affffff);
                                      }),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          textFields(),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: currentPlayerBoard,
            ),
          ],
        ),
      ),
      floatingActionButton: otherPlayerBoard==null?FloatingActionButton(
        onPressed: ()=>_puzzleKey.currentState!.shuffle(),
        child: const Icon(Icons.shuffle),
      ):null,
    );
  }
}

class Board extends StatelessWidget {
  final int maxRows;
  final double tilePadding;
  final bool isOtherPlayerBoard;
  final GlobalKey<PuzzleBoardState>? puzzleKey;
  final AnimationController animationController;
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;
  final Matrix4 perspective = _pmat(1.0);
  RoomModel? roomModel;
  String? userId;
  String? userName;
  ValueNotifier<int> movesPlayed=ValueNotifier(0);

  Board({
    Key? key,
    this.puzzleKey,
    required this.maxRows,
    required this.tilePadding,
    required this.isOtherPlayerBoard,
    required this.animationController,
    required this.scaleAnimation,
    required this.rotateAnimation,
    this.userName,
    this.userId,
    this.roomModel,
  }) : super(key: key);

  static Matrix4 _pmat(double pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, pv * 0.001,
      0.0, 0.0, 0.0, 1.0,
    );
  }

  Container movesBlock(BoxConstraints constraints,BuildContext context){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context)?10:17),
      decoration: BoxDecoration(
        color: Themes.lightColor,
        borderRadius: BorderRadius.circular(6),
      ),
      width: constraints.biggest.width*0.4,
      child: ValueListenableBuilder(
          valueListenable: movesPlayed,
          builder: (context,child,value) {
            return Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Themes.primaryColor,
                  fontSize: Responsive.size(context, mobile: 20, tablet: 24, desktop: 18),
                ),
                children: [
                  const TextSpan(
                    text: 'Moves - ',
                  ),
                  TextSpan(
                    text: movesPlayed.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.left,
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Responsive.isDesktop(context)?Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.6,
          color: Themes.lightColor,
        ):const SizedBox(),
        LayoutBuilder(builder: (context, constraints){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserNameWidget(otherPlayerId: userId!, userName: userName!,roomId: roomModel!.roomId,),
              const SizedBox(height: 25,),
              Center(
                child: AnimatedBuilder(
                  animation: animationController,
                  child: Container(
                    width: constraints.biggest.width*0.75,
                    decoration: BoxDecoration(
                      color: const Color(0xff333333),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: LayoutBuilder(
                      builder: (context,constraints){
                        return isOtherPlayerBoard?OtherPlayerBoard(
                          roomModel: roomModel!,
                          otherPlayerId: roomModel!.roomOwnerId==currentUser.userId?roomModel!.otherPlayerId:roomModel!.roomOwnerId,
                          maxRows: maxRows,
                          tilePadding: tilePadding,
                          movesPlayed: movesPlayed,
                        ):PuzzleBoard(
                          roomModel: roomModel,
                          currentUserName: userName,
                          tilePadding: tilePadding,
                          maxRows: maxRows,
                          key: puzzleKey,
                          size: constraints.biggest,
                          movesPlayed: movesPlayed,
                        );
                      },
                    ),
                  ),
                  builder: (context,child){
                    return Transform(
                      alignment: FractionalOffset.center,
                      transform: perspective.scaled(scaleAnimation.value,scaleAnimation.value,scaleAnimation.value,)
                        ..rotateX(math.pi - rotateAnimation.value * math.pi / 180)
                        ..rotateY(-math.pi)
                        ..rotateZ(-math.pi),
                      child: child,
                    );
                  },
                ),
              ),
              const SizedBox(height: 15,),
              movesBlock(constraints,context),
            ],
          );
        },),
      ],
    );
  }
}
