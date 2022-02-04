import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/widgets/empty_board_grid.dart';

class OtherPlayerBoard extends StatelessWidget {
  final String otherPlayerId;
  final RoomModel roomModel;
  final double tilePadding;
  final int maxRows;
  final ValueNotifier<int> movesPlayed;

  const OtherPlayerBoard({
    Key? key,
    required this.roomModel,
    required this.otherPlayerId,
    required this.maxRows,
    required this.tilePadding,
    required this.movesPlayed,
  }) : super(key: key);

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
