import 'dart:math';
import 'package:flutter_puzzle_hackathon/classes/tile.dart';

class Board{

  static bool isSolved(List<Tile> tiles, int maxRows){
    List<Tile> sortedTiles=orderList(tiles);
    for (int index=0;index<pow(maxRows,2)-1;index++){
      if(sortedTiles[index].value!=index+1){
        return false;
      }
    }
    return true;
  }

  ///to reorder list based on offset or position of tile
  static List<Tile> orderList(List<Tile> tiles){
    List<Tile> tempXOrdered=[];
    tempXOrdered.addAll(tiles);
    tempXOrdered.sort((a, b) => a.offset.dx.compareTo(b.offset.dx));
    tempXOrdered.sort((a, b) => a.offset.dy.compareTo(b.offset.dy));
    return tempXOrdered;
  }

  static bool haveOddInverts(List<int> currentState){
    return _getCountOfInverts(currentState) % 2 != 0;
  }

  static int _getCountOfInverts(List<int> currentState) {
    int countOfInverts = 0;
    for (int i = 0; i < currentState.length-1; i++) {
      for (int j = i + 1; j < currentState.length; j++) {
        if (currentState[i] > currentState[j]) {
          countOfInverts++;
        }
      }
      if(currentState[i] == 0 && i % 2 == 1) {
        countOfInverts++;
      }
    }
    return countOfInverts;
  }

}