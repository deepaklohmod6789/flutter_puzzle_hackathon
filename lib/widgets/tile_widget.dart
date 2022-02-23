import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/models/tile.dart';

class TileWidget extends StatelessWidget {
  final int index;
  final Tile tile;
  final Offset centerOffset;
  final Function changePosition;
  final AnimationController animationController;
  late final Animation<Offset> animation;
  late final Animation<double> rotate;

  TileWidget({
    Key? key,
    required this.index,
    required this.tile,
    required this.changePosition,
    required this.animationController,
    required this.centerOffset,
  }) : super(key: key){
    assignShuffleAnimation();
  }

  void assignShuffleAnimation(){
    //for phone have reverse curve and remove rotate and for web remove reverse cruve and add rotate
    animation=Tween(begin: tile.offset,end: centerOffset).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
        //reverseCurve: const ElasticInCurve(0.95),
      ),);
    rotate=Tween(begin: 0.0,end: 2*pi).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
        //reverseCurve: const ElasticInCurve(0.95),
      ),);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: tile.value==0?const SizedBox():AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
        child: GestureDetector(
          onTap: ()=>changePosition(index,tile),
          child: SizedBox(
            height: tile.size.height,
            width: tile.size.width,
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
                depth: 8,
                shadowLightColor: const Color(0x29000000),
                lightSource: LightSource.topRight,
                color: Themes.tileColor,
              ),
              child: Center(
                child: Text(
                  tile.value.toString(),
                ),
              ),
            ),
          ),
        ),
      ),
      builder: (context,child){
        return Transform.translate(
          offset: animation.value,
          child: Transform.rotate(
            angle: rotate.value,
            child: child,
          ),
        );
      },
    );
  }
}