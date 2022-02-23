import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class UserNameWidget extends StatefulWidget {
  final String roomId;
  final String otherPlayerId;
  final String userName;

  const UserNameWidget({
    Key? key,
    required this.roomId,
    required this.otherPlayerId,
    required this.userName,
  }) : super(key: key);

  @override
  _UserNameWidgetState createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  bool newMessage=false;

  @override
  void initState() {
    animationController=AnimationController(vsync: this);
    CollectionReferences.room.doc(widget.roomId).collection('messages')
        .where('userId',isEqualTo: widget.otherPlayerId).limit(1)
        .snapshots().listen((QuerySnapshot snapshot){
          if(snapshot.docs.isNotEmpty){
            onNewMessage(snapshot.docs.first);
          }
    });
    super.initState();
  }

  void onNewMessage(DocumentSnapshot snapshot){
    setState(() {
      newMessage=true;
    });
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        newMessage=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 400),
          style: TextStyle(
            fontSize: newMessage?(Responsive.isMobile(context)?14:16):(Responsive.isMobile(context)?20:26),
            color: Colors.white,
          ),
          child: Text(
            widget.userName,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
