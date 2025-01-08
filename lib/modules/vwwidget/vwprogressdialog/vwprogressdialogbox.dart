import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vwform/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';
import 'package:vwform/modules/vwwidget/vwprogressdialog/vwformcommand.dart';

class VwProgressDialogBox extends StatefulWidget{
  VwProgressDialogBox({
   required this.formCommand
});

  final VwFormCommand formCommand;


  _VwProgressDialogBox createState()=>_VwProgressDialogBox();
}

class _VwProgressDialogBox extends State<VwProgressDialogBox>{
  late Timer timer;
  late VwFormCommand lastStateFormCommand;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setLastStateFormCommand(widget.formCommand);
    this.timer=Timer(Duration(milliseconds: 100), handleTimeout);

  }

  bool isFormCommandChanged(){
    bool returnValue=true;

    if(widget.formCommand.message!=this.lastStateFormCommand.message)
      {
        returnValue=false;
        this.setLastStateFormCommand(widget.formCommand);
      }
    return returnValue;
  }
  void setLastStateFormCommand(VwFormCommand formCommand ){

    this.lastStateFormCommand.message=formCommand.message;
    this.lastStateFormCommand.image=formCommand.image;
    this.lastStateFormCommand.isClosed=formCommand.isClosed;

  }

  void handleTimeout() {  // callback function

    if (this.widget.formCommand.isClosed == true) {
      Navigator.pop(context);
    }

   else {

      if (this.isFormCommandChanged() == true) {
        setState(() {

        });
      }
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold (
        backgroundColor: Colors.white,

        body:Center(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VwCircularProgressIndicator(),
                Container(margin: EdgeInsets.all(10), child:Text(widget.formCommand.message))
              ],
            )


        ));
  }

}