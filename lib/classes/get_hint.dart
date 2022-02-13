import 'dart:math' as Math;
class Solve{
  int maxRows=3;
  int maxTiles=9;
  List<int> puzzle=[6, 7, 3, 5, 8, 4, 0, 1, 2];
  List<int> solved=[1, 2, 3, 4, 5, 6, 7, 8, 0];

  bool isSolved(List<int> puzzle, List<int> solved){
    for(int i=0;i<9;i++){
      if(puzzle[i]!=solved[i]){
        return false;
      }
    }
    return true;
  }

  int heuristic(List<int> puzzle){
    int man_hat=0;
    puzzle.asMap().forEach((i, val){
      if(val!=0){
        man_hat+=((val-1)%3 - i%3).abs() + ((val-1)~/3 - i~/3).abs();
      }
    });
    return man_hat;
  }

  int min_heuristics(List<int> lists){
    int min=999999;
    int index=0;
    for(int i=0;i<lists.length;i++){
      if(lists[i]<min){
        min=lists[i];
        index=i;
      }
    }
    return index;
  }

  void machinePlay(){
    List<int> openlist=[];
    List<List<int>> openLIST=[];
    List<List<int>> closedlist=[];
    List<int> heuristicValue=[];
    openlist.addAll(puzzle);
    List<int> x=openlist;
    int a=x.last;
    while(true){
      if(isSolved(puzzle,solved)){
        break;
      }
      if(a%3!=0){  // move left
        List<int> statespace1=List.from(x);
        List<String> moves=[];
        int temp=statespace1[a];
        statespace1[a]=statespace1[a-1];
        statespace1[a-1]=temp;
        statespace1[maxTiles]=a-1;
        moves.add("LEFT");

        if(isSolved(statespace1, solved)){
          print('\n Solved! \n');
          print(moves);
          break;
        } else {
          if(!closedlist.contains(statespace1) && !openLIST.contains(statespace1)){
            openlist.addAll(statespace1);
            openLIST.add(statespace1);
            heuristicValue.add(heuristic(puzzle));
          }
        }
      }

      if(a%3!=2){  // move right
        List<int> statespace1=List.from(x);
        List<String> moves=[];
        int temp=statespace1[a];
        statespace1[a]=statespace1[a+1];
        statespace1[a+1]=temp;
        statespace1[maxTiles]=a+1;
        moves.add("RIGHT");

        if(isSolved(statespace1, solved)){
          print('\n Solved! \n');
          print(moves);
          break;
        } else {
          if(!closedlist.contains(statespace1) && !openLIST.contains(statespace1)){
            openlist.addAll(statespace1);
            openLIST.add(statespace1);
            heuristicValue.add(heuristic(puzzle));
          }
        }
      }

      if(a!=0 && a!=1 && a!=2){  // move up
        List<int> statespace1=List.from(x);
        List<String> moves=[];
        int temp=statespace1[a];
        statespace1[a]=statespace1[a-maxRows];
        statespace1[a-maxRows]=temp;
        statespace1[maxTiles]=a-maxRows;
        moves.add("UP");

        if(isSolved(statespace1, solved)){
          print('\n Solved! \n');
          print(moves);
          break;
        } else {
          if(!closedlist.contains(statespace1) && !openLIST.contains(statespace1)){
            openlist.addAll(statespace1);
            openLIST.add(statespace1);
            heuristicValue.add(heuristic(puzzle));
          }
        }
      }

      if(a!=6 && a!=7 && a!=8){  // move down
        List<int> statespace1=List.from(x);
        List<String> moves=[];
        int temp=statespace1[a];
        statespace1[a]=statespace1[a+maxRows];
        statespace1[a+maxRows]=temp;
        statespace1[maxTiles]=a+maxRows;
        moves.add("DOWN");

        if(isSolved(statespace1, solved)){
          print('\n Solved! \n');
          print(moves);
          break;
        } else {
          if(!closedlist.contains(statespace1) && !openLIST.contains(statespace1)){
            openlist.addAll(statespace1);
            openLIST.add(statespace1);
            heuristicValue.add(heuristic(puzzle));
          }
        }
      }

      closedlist.add(x);
      int y=min_heuristics(heuristicValue);
      heuristicValue.removeAt(y);
      openlist.removeAt(y);
      x=openlist;
      a=x[9];

    }
  }

  void solve(){
    puzzle.add(puzzle.indexOf(0));
    print(puzzle);
    machinePlay();
  }
}