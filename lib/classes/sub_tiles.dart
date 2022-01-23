import 'dart:math';

import 'package:flutter/material.dart';

class SubTiles{
  final Size size;
  final Offset initialOffset;
  final TickerProvider tickerProvider;
  late AnimationController animationController;
  late Animation<Offset> animation;
  late Offset offset;
  late final Random _random;

  SubTiles({required this.size, required this.initialOffset,required this.tickerProvider}){
    _random = Random();
    offset=_randomOffSet();
    int duration=500+_random.nextInt(2000);
    animationController = AnimationController(
      vsync: tickerProvider, duration: Duration(milliseconds: duration),
    );
    animationController.forward();
    animation = Tween(begin: initialOffset, end: offset).animate(animationController);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
      else if (status == AnimationStatus.dismissed) {
        Offset r=_randomOffSet();
        animation = Tween(begin: offset, end: r).animate(animationController);
        offset=r;
        animationController.forward();
      }
    });
  }

  Offset _randomOffSet(){
    double dx= initialOffset.dx + _random.nextInt(2*size.width.toInt());
    double dy= initialOffset.dy + _random.nextInt(2*size.width.toInt());
    bool randomDxTrue= _random.nextBool();
    bool randomDyTrue= _random.nextBool();
    if(!randomDxTrue){
      dx=dx= initialOffset.dx - _random.nextInt(2*size.width.toInt());
    }
    if(!randomDyTrue){
      dy= initialOffset.dy - _random.nextInt(2*size.width.toInt());
    }
    Offset offset=Offset(dx, dy);
    /*if(offset.dx>size.width||offset.dy>size.height){
      offset=Offset(size.width/2, size.height/2);
    }*/
    return offset;
  }

}