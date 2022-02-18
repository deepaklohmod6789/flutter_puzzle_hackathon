import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';

class GameSettings extends StatefulWidget {
  final ValueChanged<Map<String,int>> onUpdate;
  const GameSettings({Key? key,required this.onUpdate}) : super(key: key);

  @override
  _GameSettingsState createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  static const List<int> _rounds=[1,3,5,7];
  static const List<int> _sizes=[3,4,5];
  int noOfRounds=_rounds.first;
  int puzzleSize=_sizes.first;

  void returnNewValues(){
    Map<String,int> val={
      'noOfRounds': noOfRounds,
      'puzzleSize': puzzleSize,
    };
    widget.onUpdate(val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xe8000000),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
          const Text(
            'Enter your basic details Enter your username',
            style: TextStyle(
              fontSize: 12,
              color: Color(0x75ffffff),
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 40,),
          const Text(
            'No. of games',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context,index)=>const SizedBox(width: 10,),
              itemCount: _rounds.length,
              itemBuilder: (context,index){
                return TextButton(
                  onPressed: (){
                    setState(()=>noOfRounds=_rounds[index]);
                    returnNewValues();
                  },
                  child: Text(
                    _rounds[index].toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom().copyWith(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(color: noOfRounds==_rounds[index]?Themes.primaryColor:Colors.transparent,width: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(60, 30)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(const Color(0xff1d1d1d),),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Themes.primaryColor;
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return noOfRounds==_rounds[index]?Themes.primaryColor:Colors.white;
                    }),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30,),
          const Text(
            'No. of tiles',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context,index)=>const SizedBox(width: 10,),
              itemCount: _sizes.length,
              itemBuilder: (context,index){
                return TextButton(
                  onPressed: (){
                    setState(()=>puzzleSize=_sizes[index]);
                    returnNewValues();
                  },
                  child: Text(
                    _sizes[index].toString()+'*'+_sizes[index].toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom().copyWith(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(color: puzzleSize==_sizes[index]?Themes.primaryColor:Colors.transparent,width: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(60, 30)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(const Color(0xff1d1d1d),),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Themes.primaryColor;
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return puzzleSize==_sizes[index]?Themes.primaryColor:Colors.white;
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
