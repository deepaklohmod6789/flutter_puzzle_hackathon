import 'package:flutter/material.dart';

class Tile{
  final Size size;
  int value;
  double left;
  double top;

  Tile({
    required this.size,
    this.value=0,
    required this.left,
    required this.top,
  });

}