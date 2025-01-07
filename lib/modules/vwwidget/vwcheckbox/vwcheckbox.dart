import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:matrixclient/modules/vwwidget/vwconfirmdialog/vwconfirmdialog.dart';

typedef VwCheckBoxOnTap = void Function(bool selected);
class VwCheckBox extends StatefulWidget{
  VwCheckBox({
    super.key ,
   this.initialState=false,
    this.onTap,
    this.selectedIcon=const Icon(Icons.check_box),
    this.unselectedIcon=const Icon(Icons.check_box_outline_blank),
    this.unselectConfirmation=false,
    this.isReadOnly=false
});

  final bool initialState;
  final Icon? selectedIcon;
  final Icon? unselectedIcon;
  final bool unselectConfirmation;
  final bool isReadOnly;

  VwCheckBoxOnTap? onTap;
  VwCheckBoxState createState()=>VwCheckBoxState();
}
class VwCheckBoxState extends State<VwCheckBox>{
  late bool currentState;
  final Icon defaultSelectedIcon=Icon(Icons.check_box,color:Colors.blue);
  final Icon defaultUnselectedIcon=Icon(Icons.check_box_outline_blank,color:Colors.black);

  late Icon selectedIconWidget;
  late Icon unselectedIconWidget;

  @override
  void initState() {

    super.initState();
    this.currentState=this.widget.initialState;

    selectedIconWidget=widget.selectedIcon==null?this.defaultSelectedIcon:widget.selectedIcon!;
    unselectedIconWidget=widget.unselectedIcon==null?this.defaultUnselectedIcon:widget.unselectedIcon!;


  }

  @override
  Widget build(BuildContext context) {
    if(this.currentState==false)
      {
        return InkWell(onTap: (){

          if(widget.isReadOnly==false)
            {
              this.currentState=!currentState;
              if(this.widget.onTap!=null)
              {
                this.widget.onTap!(this.currentState);
              }


              setState(() {

              });
            }



        }, child:this.unselectedIconWidget );
      }
    else{
      return InkWell(
        key: widget.key,

          onTap: () async{

            if(widget.isReadOnly==false)
              {
                if(this.widget.unselectConfirmation==true)
                {
                  VwFieldValue modalResult=VwFieldValue(fieldName: "modalResult");

                  await Navigator.push(
                    context,
                    MaterialTransparentRoute (builder: (context) => VwConfirmDialog(fieldValue: modalResult)),
                  );

                  if(modalResult.valueString=="yes")
                  {
                    this.currentState=!currentState;
                    if(this.widget.onTap!=null)
                    {
                      this.widget.onTap!(this.currentState);
                    }

                  }
                }
                else{
                  this.currentState=!currentState;
                  if(this.widget.onTap!=null)
                  {
                    this.widget.onTap!(this.currentState);
                  }
                }




                setState(() {

                });
              }









      }, child:this.selectedIconWidget);
    }
  }
}