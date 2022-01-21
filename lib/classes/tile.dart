import 'package:flutter/material.dart';

class Tile{
  final Size size;
  int value;
  double left;
  double top;
  bool isEmpty;

  Tile({
    required this.size,
    this.value=0,
    required this.left,
    required this.top,
    this.isEmpty=false,
  });

}