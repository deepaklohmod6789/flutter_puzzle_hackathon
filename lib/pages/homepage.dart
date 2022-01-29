import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';

class HomePage extends StatelessWidget {
  String? currentUserName;
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (String value){
              currentUserName=value;
            },
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: ()=>FluroRouting.navigateToPage(routeName: '/game', context: context),
            child: const Text("Single Player"),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){
              if(currentUserName!=null){
                FluroRouting.navigateToPage(routeName: '/room', context: context,username: currentUserName);
              } else {
                
              }
            },
            child: const Text("Multi- Player"),
          ),
        ],
      ),
    );
  }
}
