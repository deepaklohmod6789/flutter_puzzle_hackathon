import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_puzzle_hackathon/puzzle_board.dart';

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> with SingleTickerProviderStateMixin{
  final GlobalKey<PuzzleBoardState> _puzzleKey = GlobalKey();
  Matrix4 perspective = _pmat(1.0);
  static const double degrees=60.0;
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotateAnimation;

  static Matrix4 _pmat(double pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, pv * 0.001,
      0.0, 0.0, 0.0, 1.0,
    );
  }

  @override
  void initState() {
    animationController=AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    rotateAnimation=Tween(begin: degrees,end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    scaleAnimation=Tween(begin: 0.5,end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
    Future.delayed(const Duration(seconds: 1),(){
      animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: animationController,
              child: SizedBox(
                width: MediaQuery.of(context).size.height*0.9,
                height: MediaQuery.of(context).size.height*0.9,
                child: LayoutBuilder(
                  builder: (context,constraints){
                    return PuzzleBoard(
                      key: _puzzleKey,
                      size: constraints.biggest,
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
          ElevatedButton(onPressed: ()=>_puzzleKey.currentState!.shuffle(), child: const Icon(Icons.shuffle)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_puzzleKey.currentState!.getHint(),
        child: const Icon(Icons.help_outline_rounded),
      ),
    );
  }
}
