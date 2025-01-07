import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/edokumen2022/pagecoordinator/bloc/pagecoordinator_bloc.dart';

class FatalErrorPage extends StatelessWidget{
  FatalErrorPage({
    super.key,
    required this.errorMessage,
    required this.appInstanceParam
});
  final String errorMessage;

  final VwAppInstanceParam appInstanceParam;

  @override
  Widget build(BuildContext context) {
    return Scaffold (key: super.key, body: SingleChildScrollView(child:Center(child:Container( margin: EdgeInsets.fromLTRB(0, 150, 0, 50), child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        this.appInstanceParam.appBloc==null?Container():TextButton.icon(icon:Icon(Icons.logout,color:Colors.white) , style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
        ), label: Text("Logout",style: TextStyle(color:Colors.white),),   onPressed: (){
          this.appInstanceParam.appBloc!.add(LogoutPagecoordinatorEvent (timestamp: DateTime.now()));
        },),
        Icon(Icons.error_outline,color:Colors.red,size: 45,),
        Container(padding: EdgeInsets.all(13), child:Flexible(child:Text(errorMessage, maxLines: 100,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20),))),
        ],)))));
  }
}