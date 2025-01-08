import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';


class VwConfirmDialog extends StatefulWidget{

  VwConfirmDialog({
    required this.fieldValue
});

  final VwFieldValue fieldValue;

  _VwConfirmDialogState createState()=>_VwConfirmDialogState();
}
class _VwConfirmDialogState extends State<VwConfirmDialog>{

  @override
  Widget build(BuildContext context) {

    Widget buttonYes=TextButton.icon(

      label:Text("Ya",style: TextStyle(fontSize: 20)),
      icon:Icon(Icons.check,color:Colors.green,size: 35),
      onPressed: (){
        this.widget.fieldValue.valueString="yes";
        Navigator.pop(context);
      },
    );

    Widget buttonNo=TextButton.icon(
      label:Text("Tidak",style: TextStyle(fontSize: 20)),
      icon:Icon(Icons.cancel_outlined ,color:Colors.red,size:35),
      onPressed: (){
        this.widget.fieldValue.valueString="no";
        Navigator.pop(context);
      },
    );


    Widget  yesnoWidget=Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buttonYes,
          buttonNo,
        ],
      ),
    );

    //Widget warningIcon=Stack( alignment: Alignment.center, children:[Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:Icon(Icons.circle,color:Colors.black, size: 50, )) ,Icon(Icons.warning, size:30,color:Colors.yellow)]);

    Widget warningIcon=Stack( alignment: Alignment.center, children:[Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:Icon(Icons.circle,color:Colors.black, size: 70, )) ,Icon(Icons.delete_outlined, size:40,color:Colors.yellow)]);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),

      body:Container(
          color:Colors.transparent,
          child:AlertDialog(
            icon: warningIcon,
        title: Text("Delete Confirmation"),
        titleTextStyle:
        TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,fontSize: 20),
        actionsOverflowButtonSpacing: 60,
        actions: [
          buttonYes,
          buttonNo
        ],
        content: Row(children:[Text("Delete this record?",style:TextStyle(fontSize: 18)), ]),
      )),


    );
  }
}