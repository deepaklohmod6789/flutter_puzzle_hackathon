import 'package:flutter/material.dart';

class Tile{
  final Size size;
  int value;
  Offset offset;

  Tile({
    required this.size,
    this.value=0,
    required this.offset,
  });

}