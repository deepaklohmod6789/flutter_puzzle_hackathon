import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/sub_tiles.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';

class TileWidget extends StatefulWidget {
  final Size size;
  const TileWidget({Key? key,required this.size}) : super(key: key);

  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> with TickerProviderStateMixin{
  final double subTileLength=8;
  final double subTilePadding=3;
  List<SubTiles> subTiles=[];


  @override
  void initState() {
    getSubTiles();
    super.initState();
  }

  void getSubTiles(){
    int maxRows=(widget.size.width~/(subTileLength+subTilePadding));
    for (int index=0;index<pow(maxRows,2);index++){
      if(index%2==0){
        Size sizeBox = Size((widget.size.width-(maxRows+1)*subTilePadding) / maxRows, (widget.size.width-(maxRows+1)*subTilePadding) / maxRows);
        Offset offsetTemp = Offset(
          index % maxRows * sizeBox.width+(index%maxRows+1)*subTilePadding,
          index ~/ maxRows * sizeBox.height+(index~/maxRows+1)*subTilePadding,
        );
        subTiles.add(SubTiles(
          size: sizeBox,
          initialOffset: offsetTemp,
          tickerProvider: this,
        ));
      }

    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(subTiles.length, (index) => AnimatedBuilder(
        animation: subTiles[index].animationController,
        child: CircleAvatar(
          backgroundColor: Themes.blueColor,
          radius: subTileLength/2,
        ),
        builder: (context,child){
          return Transform.translate(
            offset: subTiles[index].animation.value,
            child: child!,
          );
        },
      ),),
    );
  }
}
