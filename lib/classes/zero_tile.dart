import 'package:flutter_puzzle_hackathon/models/tile.dart';

class ZeroTile{
  final int maxRows;
  final Tile currentTile;
  final List<Tile> tiles;
  late final int currentIndex;
  late final int zeroIndex;

  ZeroTile(this.currentTile,this.maxRows,this.tiles){
    Tile zeroTile=tiles.firstWhere((element) => element.value==0);
    zeroIndex=tiles.indexOf(zeroTile);
    currentIndex=tiles.indexOf(currentTile);
  }

  bool isOnLeft(){
    int startingRowIndex=currentIndex%maxRows; //used to check zero is on left in terms of index but in previous line
    return (zeroIndex+1==currentIndex&&startingRowIndex!=0);
  }

  bool isOnRight(){
    int endRowIndex=(currentIndex+1)%maxRows; //used to check zero is on right in terms of index but in next line
    return (zeroIndex-1==currentIndex&&endRowIndex!=0);
  }

  bool isOnUp(){
    return zeroIndex+maxRows==currentIndex;
  }

  bool isOnBelow(){
    return zeroIndex-maxRows==currentIndex;
  }

}