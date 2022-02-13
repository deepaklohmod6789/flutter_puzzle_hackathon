import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/models/leaderboard_model.dart';
import 'package:flutter_puzzle_hackathon/widgets/leaderboard_card.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  bool loading=true;
  List<LeaderBoardModel> leaderBoardModels=[];
  static const List<double> angles=[0,-16/360,11/360,-7/360,21/360];

  @override
  void initState() {
    getLeaderBoard();
    super.initState();
  }

  void getLeaderBoard()async{
    LeaderBoardModel model=LeaderBoardModel(
      userId: 'acbnj1knvlsdnla',
      username: 'dr. unknown weird',
      image: 'https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
      score: 1688,
      timeInSeconds: 08.24,
      rank: 31,
    );
    leaderBoardModels=[model,model,model,model,model,model,model,model,model,model,];
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading? const Center(child: CircularProgressIndicator(),):LayoutBuilder(
      builder: (context,constraints){
        return Responsive(
          mobile: SizedBox(
            height: Responsive.isDesktop(context)?constraints.biggest.height*0.7:constraints.biggest.width*0.75,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(leaderBoardModels.length, (index){
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction)async{
                    if(leaderBoardModels.length>1){
                      setState(() {
                        leaderBoardModels.removeAt(index);
                      });
                      return true;
                    }
                    return false;
                  },
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(angles[index%angles.length]),
                    child: LeaderBoardCard(leaderBoardModel: leaderBoardModels[index],),
                  ),
                );
              }),
            ),
          ),
          tablet: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: leaderBoardModels.length,
            padding: const EdgeInsets.all(30),
            separatorBuilder: (context,index)=>const SizedBox(width: 30,),
            itemBuilder: (context,index)=>LeaderBoardCard(leaderBoardModel: leaderBoardModels[index]),
          ),
          desktop: SizedBox(
            height: Responsive.isDesktop(context)?constraints.biggest.height*0.7:constraints.biggest.width*0.75,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(leaderBoardModels.length, (index){
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (direction)async{
                    if(leaderBoardModels.length>1){
                      setState(() {
                        leaderBoardModels.removeAt(index);
                      });
                      return true;
                    }
                    return false;
                  },
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(angles[index%angles.length]),
                    child: LeaderBoardCard(leaderBoardModel: leaderBoardModels[index],),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
