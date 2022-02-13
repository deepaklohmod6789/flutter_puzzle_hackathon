import 'package:flutter_puzzle_hackathon/classes/hint_algo_node.dart';

class Solve{
  int maxRows;
  List<List<int>> start;
  List<List<int>> goal;
  List<Node> open=[];
  List<Node> closed=[];
  Solve(this.maxRows,this.start,this.goal);

  int _heuristicValue(List<List<int>> start, List<List<int>> goal){
    int val=0;
    for(int i=0;i<maxRows;i++){
      for(int j=0;j<maxRows;j++){
        if(start[i][j] != goal[i][j] && start[i][j] != 0){
          val++;
        }
      }
    }
    return val;
  }

  int _fScore(Node start, List<List<int>> goal){
    return _heuristicValue(start.data, goal)+start.level;
  }

}

List<String> getMoves(Solve solve){
  List<String> moves=[];
  Node node=Node(List.from(solve.start),0,0,null);
  solve.open.add(node);

  while (true){
    Node current=solve.open[0];
    if(current.lastMove!=null){
      moves.add(current.lastMove!);
    }
    if(solve._heuristicValue(current.data,solve.goal)==0){
      break;//puzzle is solved
    }
    for (Node i in current.generateChild()){
      i.fval=solve._fScore(i, solve.goal);
      solve.open.add(i);
    }
    solve.closed.add(current);
    solve.open.removeAt(0);
    solve.open.sort((a,b)=>a.fval.compareTo(b.fval));
  }
  return moves;
}