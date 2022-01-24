import 'dart:math';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/classes/tile.dart';

class TileWidget extends StatelessWidget {
  final int index;
  final Tile tile;
  final Function changePosition;
  final AnimationController animationController;
  late final Animation<double> animation;

  TileWidget({
    Key? key,
    required this.index,
    required this.tile,
    required this.changePosition,
    required this.animationController,
  }) : super(key: key){
    animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: 2*pi).chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi*2),
          weight: 50.0,
        ),
      ],
    ).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: tile.offset.dy,
      left: tile.offset.dx,
      duration: const Duration(milliseconds: 200),
      child: AnimatedBuilder(
        animation: animationController,
        child: tile.value==0?const SizedBox():GestureDetector(
          onTap: ()=>changePosition(index,tile),
          child: SizedBox(
            height: tile.size.height,
            width: tile.size.width,
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topRight,
              ),
              child: Center(
                child: Text(
                  tile.value.toString(),
                ),
              ),
            ),
          ),
        ),
        builder: (context,child){
          var transform = Matrix4.identity();
          transform.setEntry(3, 2, 0.001);
          transform.rotateY(animation.value);
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: child,
          );
        },
      ),
    );
  }
}