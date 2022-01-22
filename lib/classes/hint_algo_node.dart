class Node{
  List<List<int>> data;
  int level;
  int fval;
  String? lastMove;
  Node(this.data,this.level,this.fval,this.lastMove);

  List<Node> generateChild(){
    List<int> coordinates=_find(data, 0);
    int x=coordinates[0];
    int y=coordinates[1];
    List<List<int>> moves=[[x,y-1],[x,y+1],[x-1,y],[x+1,y]];
    List<Node> children=[];
    for(List<int> i in moves){
      List<List<int>>? child=_shuffle(List.from(data),x,y,i[0],i[1]);
      if(child!=null){
        Node childNode=Node(List.from(child),level+1,0,_move(moves.indexOf(i)));
        children.add(childNode);
      }
    }
    return children;
  }

  String _move(int val){
    if(val==0){
      return "Left";
    } else if(val==1){
      return "Right";
    } else if(val==2){
      return "Up";
    } else {
      return "Down";
    }
  }

  List<List<int>>? _shuffle(List<List<int>> puz,int x1,int y1,int x2,int y2){
    if(x2 >= 0 && x2 < data.length && y2 >= 0 && y2 < data.length){
      List<List<int>> tempPuz=_copy(puz);
      int temp=tempPuz[x2][y2];
      tempPuz[x2][y2] = tempPuz[x1][y1];
      tempPuz[x1][y1] = temp;
      return tempPuz;
    } else{
      return null;
    }
  }

  List<List<int>> _copy(List<List<int>> root){
    List<List<int>> temp=[];
    for(List<int> i in root){
      List<int> t=[];
      for(int j in i){
        t.add(j);
      }
      temp.add(t);
    }
    return temp;
  }

  _find(List<List<int>> puzzle, int x){
    for(int i=0;i<data.length;i++){
      for(int j=0;j<data.length;j++){
        if(puzzle[i][j]==x){
          return [i,j];
        }
      }
    }
  }

}