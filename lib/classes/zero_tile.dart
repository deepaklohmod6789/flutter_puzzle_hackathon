import 'package:flutter_puzzle_hackathon/classes/tile.dart';

class ZeroTile{
  final int maxRows;
  final Tile currentTile;
  final List<Tile> tiles;
  late final int currentIndex;
  late final int zeroIndex;
  List<Tile> orderedTiles=[];

  ZeroTile(this.currentTile,this.maxRows,this.tiles){
    orderedTiles=orderList();
    Tile zeroTile=orderedTiles.firstWhere((element) => element.value==0);
    zeroIndex=orderedTiles.indexOf(zeroTile);
    currentIndex=orderedTiles.indexOf(currentTile);
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

  ///to reorder list based on offset
  List<Tile> orderList(){
    List<Tile> tempXOrdered=[];
    tempXOrdered.addAll(tiles);
    tempXOrdered.sort((a, b) => a.offset.dx.compareTo(b.offset.dx));
    tempXOrdered.sort((a, b) => a.offset.dy.compareTo(b.offset.dy));
    return tempXOrdered;
  }

}