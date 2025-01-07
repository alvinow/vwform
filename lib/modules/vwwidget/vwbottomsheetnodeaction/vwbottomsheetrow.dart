import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';

typedef BottomSheetOnTapFunction = void Function(
     Key key,  BuildContext context,  VwNode currentNode, VwAppInstanceParam appInstanceParam);

class VwBottomSheetRow extends StatelessWidget {
  VwBottomSheetRow(
      {
        required super.key,
        required this.appInstanceParam,
      required this.currentNode,
      required this.icon,
      required this.bottomSheetOnTapFunction,
      required this.caption});


  final BottomSheetOnTapFunction bottomSheetOnTapFunction;
  final VwAppInstanceParam appInstanceParam;
  final VwNode currentNode;
  final Widget icon;
  final String caption;

  @override
  Widget build(BuildContext context) {

    return InkWell(onTap:(){
      this.bottomSheetOnTapFunction(super.key!,context ,this.currentNode,this.appInstanceParam);
    } , child:Container(child: Row(children: [this.icon,SizedBox(width: 15,),Text(this.caption)]),));

  }
}
