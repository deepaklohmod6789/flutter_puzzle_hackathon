import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';

class EmptyBoardGrid extends StatelessWidget {
  final double tilePadding;
  final int maxRows;
  const EmptyBoardGrid({Key? key,required this.tilePadding,required this.maxRows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(tilePadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: maxRows,
        mainAxisSpacing: tilePadding,
        crossAxisSpacing: tilePadding,
      ),
      itemCount: pow(maxRows, 2).toInt(),
      itemBuilder: (context,index){
        return Neumorphic(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
            depth: -4,
            color: Themes.emptyTileColor,
            lightSource: LightSource.topRight,
          ),
        );
      },
    );
  }
}
