import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';
import 'package:flutter_puzzle_hackathon/widgets/empty_board_grid.dart';
import 'package:flutter_puzzle_hackathon/widgets/win_dialog.dart';

class OtherPlayerBoard extends StatelessWidget {
  final String otherPlayerId;
  final String otherPlayerName;
  final RoomModel roomModel;
  final double tilePadding;
  final int maxRows;
  final ValueNotifier<int> movesPlayed;

  const OtherPlayerBoard({
    Key? key,
    required this.roomModel,
    required this.otherPlayerId,
    required this.otherPlayerName,
    required this.maxRows,
    required this.tilePadding,
    required this.movesPlayed,
  }) : super(key: key);

  bool isSolved(List<int> tiles){
    for (int index=0;index<pow(maxRows,2)-1;index++){
      if(tiles[index]!=index+1){
        return false;
      }
    }
    return true;
  }

  void dialog(BuildContext context,String username,int score,int moves,String content){
    int minutes = seconds ~/ 60;
    int second = seconds % 60;
    String time=minutes.toString()+':'+second.toString();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Themes.lightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: WinDialog(
          seconds: time,
          score: score,
          moves: moves,
          image: 'https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
          username: username,
          content: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CollectionReferences.room.doc(roomModel.roomId).collection('players').doc(otherPlayerId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(!snapshot.hasData||!snapshot.data!.exists){
          return EmptyBoardGrid(tilePadding: tilePadding, maxRows: maxRows);
        }
        List<int> board=List.from(snapshot.data!['board']);
        WidgetsBinding.instance!.addPostFrameCallback((_){
          movesPlayed.value=snapshot.data!['moves'];
          if(isSolved(board)){
            int score=500 * movesPlayed.value ~/ sqrt(seconds);
            dialog(
              context,
              otherPlayerName,
              score,
              movesPlayed.value,
              "Your teammate won, but good luck in tomorrow's race! I'll keep you in my thoughts! I'll keep my fingers crossed for you! Let's go, let's go, let's go!",
            );
          }
        });
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(tilePadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: maxRows,
            mainAxisSpacing: tilePadding,
            crossAxisSpacing: tilePadding,
          ),
          itemCount: pow(maxRows,2).toInt(),
          itemBuilder: (context,index){
            return board[index]==0?Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                color: Colors.black12,
                lightSource: LightSource.topRight,
              ),
            ):Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topRight,
              ),
              child: Center(
                child: Text(
                  board[index].toString(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
