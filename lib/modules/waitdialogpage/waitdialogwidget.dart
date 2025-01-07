import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WaitDialogWidget extends StatefulWidget
{

  WaitDialogWidgetState createState()=> WaitDialogWidgetState();
}

class WaitDialogWidgetState extends State<WaitDialogWidget>{

  late Timer timer1;

  late DateTime start;

  @override
  void initState() {
    this.start=DateTime.now();
    this.timer1=Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {

      });
    });
  }

  int getAgeInMilisecond(){
    int returnValue=DateTime.now().difference(this.start).inMilliseconds;




    return returnValue;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this.timer1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.grey.withOpacity(0.5),
       body:Center(child:Container( padding: EdgeInsets.fromLTRB(0, 10, 0, 0), color: Colors.blue, width: 200,height: 100, child:
         Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(Icons.print,color: Colors.white,size: 60,),
                 LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 60),
               ],
             ),
             Text((this.getAgeInMilisecond()*0.001).round().toString() +" second(s)",style: TextStyle(color: Colors.white),)
           ],
         )
         ,))
   );
  }
}