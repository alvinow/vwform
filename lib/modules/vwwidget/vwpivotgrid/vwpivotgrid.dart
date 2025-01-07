import 'package:flutter/cupertino.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';



class VwPivotGrid extends StatefulWidget{
  VwPivotGrid({required this.value});


  final List<VwRowData > value;

  _VwPivotGridState createState()=>_VwPivotGridState();

}

class  _VwPivotGridState extends State<VwPivotGrid>{

  @override
  Widget build(BuildContext context) {
    return Center(child:Container(child:Text("VwPivotGrid")));
  }
}