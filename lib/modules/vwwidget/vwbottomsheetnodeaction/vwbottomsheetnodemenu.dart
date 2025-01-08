import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/vwbottomsheetnodeaction/vwbottomsheetrow.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/vwnodesubmitpage.dart';
import 'package:vwform/modules/vwwidget/vwnodeusergroupaccesspages/vwnodeusergroupaccesspage.dart';
import 'package:vwform/modules/vwwidget/vwnodeusergroupaccesspages/vwsharenodeaccessgrouppage.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class VwBottomSheetNodeMenu extends StatefulWidget{

  VwBottomSheetNodeMenu({
    required this.appInstanceParam,
    required this.currentNode,
    this.refreshDataOnParentFunction
});

final VwAppInstanceParam appInstanceParam;
final VwNode currentNode;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  VwBottomSheetNodeMenuState createState()=> VwBottomSheetNodeMenuState();
}

class VwBottomSheetNodeMenuState extends State<VwBottomSheetNodeMenu>{
 late bool isNodeSuccesfullyUpdated;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isNodeSuccesfullyUpdated=false;
  }

  void onChangePageState({required String pageState})
  {

    if(pageState==VwNodeSubmitPage.nspSuccessSyncingNode)
    {
      this.isNodeSuccesfullyUpdated=true;
    }
  }



  @override
  Widget build(BuildContext context) {

    Widget bottomMenu1=VwBottomSheetRow(key:Key("share"), appInstanceParam: widget.appInstanceParam, currentNode: widget.currentNode, icon: Icon(Icons.person_add_alt), bottomSheetOnTapFunction: (key, buildContext, currentNode,appInstanceParam){

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VwShareNodeAcccesGroupPage(node: widget.currentNode, appInstanceParam: widget.appInstanceParam),
          ));


    }, caption: "Share");

    Widget bottomMenu2=VwBottomSheetRow(key:Key("manageaccess"), appInstanceParam: widget.appInstanceParam, currentNode: widget.currentNode, icon: Icon(Icons.supervised_user_circle), bottomSheetOnTapFunction: (key, buildContext, currentNode,appInstanceParam){

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VwNodeUserGroupAccessPage(node: widget.currentNode, appInstanceParam: widget.appInstanceParam),
          ));


    }, caption: "Manage Access");

    Widget bottomMenu3=VwBottomSheetRow(key:Key("createnode"), appInstanceParam: widget.appInstanceParam, currentNode: widget.currentNode, icon: Icon(FontAwesomeIcons.file), bottomSheetOnTapFunction: (key, buildContext, currentNode,appInstanceParam){

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VwNodeSubmitPage( parentNodeId: currentNode.recordId, appInstanceParam: appInstanceParam, refreshDataOnParentFunction: widget.refreshDataOnParentFunction),
          ));


    }, caption: "Create New Record");

    Widget bottomMenu4=VwBottomSheetRow(key:Key("createnode"), appInstanceParam: widget.appInstanceParam, currentNode: widget.currentNode, icon: Icon(FontAwesomeIcons.file), bottomSheetOnTapFunction: (key, buildContext, currentNode,appInstanceParam) async{

      Navigator.pop(context);

      String currentNodeString=json.encode(this.widget.currentNode.toJson());

      VwNode injectNode=VwNode.fromJson(json.decode(currentNodeString) );
      isNodeSuccesfullyUpdated=false;
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VwNodeSubmitPage(nodeSubmitPageStateChanged: this.onChangePageState, node: injectNode, parentNodeId: injectNode.parentNodeId==null?"<invalid_node_id>":currentNode!.parentNodeId.toString(), appInstanceParam: appInstanceParam, refreshDataOnParentFunction: widget.refreshDataOnParentFunction),
          ));

      if(this.isNodeSuccesfullyUpdated)
        {
          VwRowData updatedNodeRowData=VwRowData(recordId: Uuid().v4());

          NodeUtil.nodeToRowData(nodeSource: injectNode, rowDataDestination: updatedNodeRowData);

          NodeUtil.updateNodeFromRowData(nodeDestination: this.widget.currentNode, rowDataSource: updatedNodeRowData);
        }



    }, caption: "Edit Record");

    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children:[this.widget.currentNode.nodeType==VwNode.ntnFolder?Icon(Icons.folder,color: Colors.blueGrey,):Icon(Icons.file_present) , Flexible(child:Container(margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child:Column( children:[Text(this.widget.currentNode.displayName,style: TextStyle(fontSize: 16),)])))]),
      Divider(
          color: Colors.black
      ),
      Container(margin: EdgeInsets.fromLTRB(3, 0, 0, 0), child:bottomMenu4),
      SizedBox(height: 8,),
      Container(margin: EdgeInsets.fromLTRB(3, 0, 0, 0), child:bottomMenu3),
      SizedBox(height: 8,),
      Divider(
          color: Colors.black12
      ),
      Container(margin: EdgeInsets.fromLTRB(3, 0, 0, 0), child:bottomMenu1),
      SizedBox(height: 8,),
      Container(margin: EdgeInsets.fromLTRB(3, 0, 0, 0), child:bottomMenu2),
      SizedBox(height: 8,),


    ],);
  }
}