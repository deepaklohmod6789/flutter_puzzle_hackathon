import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin{
  double tileSize=100;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  Offset initial=const Offset(500,250);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this, duration: const Duration(seconds: 1),
    );
    Offset r=randomOffSet();
    _animation = Tween(begin: initial, end: r).animate(_animationController);
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
      else if (status == AnimationStatus.dismissed) {
        Offset r=randomOffSet();
        _animation = Tween(begin: initial, end: r).animate(_animationController);
        _animationController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Offset randomOffSet(){
    final Random _random = Random();
    double dx= initial.dx + _random.nextInt(2*tileSize.toInt());
    double dy= initial.dy + _random.nextInt(2*tileSize.toInt());
    bool randomDxTrue= _random.nextBool();
    bool randomDyTrue= _random.nextBool();
    if(!randomDxTrue){
      dx=dx= initial.dx - _random.nextInt(2*tileSize.toInt());
    }
    if(!randomDyTrue){
      dy= initial.dy - _random.nextInt(2*tileSize.toInt());
    }
    return Offset(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context,child){
              return Transform.translate(
                offset: _animation.value,
                child: Container(
                  color: Themes.blueColor,
                  height: tileSize,
                  width: tileSize,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
