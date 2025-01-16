import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodeusergroupaccess/vwnodeusergroupaccess.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwmessenger/vwmessagerecipientrowviewer.dart';
import 'package:vwform/modules/vwwidget/vwnodeusergroupaccesspages/vwnodeusergroupaccessrowviewer.dart';
import 'package:vwform/modules/vwwidget/vwnodeusergroupaccesspages/vwsharenodeaccessgrouppage.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwNodeUserGroupAccessPage extends StatefulWidget{
  VwNodeUserGroupAccessPage({required this.node,this.refreshDataOnParentFunction,  required this.appInstanceParam,});
  final VwNode node;
  final VwAppInstanceParam appInstanceParam;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  VwNodeUserGroupAccessPageState createState()=> VwNodeUserGroupAccessPageState();
}

class VwNodeUserGroupAccessPageState extends State<VwNodeUserGroupAccessPage>{

  late Key stateKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.stateKey=Key(Uuid().v4());



  }

  VwNode? getTargetUserNode(VwNode fRenderedNode){
    VwNode? returnValue;
    try {
      VwNodeUserGroupAccess currentObject= VwNodeUserGroupAccess.fromJson(fRenderedNode.content!.classEncodedJson!.data!);


      returnValue=NodeUtil.extractNodeFromLinkNode(currentObject.targetUserGroup!);


    }
    catch(error)
    {

    }
    return returnValue;
  }

  void implementRefreshDataOnParentFunction() {
    print("refresh data from isi form");


    setState(() {
      this.stateKey = Key(Uuid().v4());
    });
  }

  Widget nodeRowViewer(
      {required VwNode renderedNode,
        required BuildContext context,
        required int index,
        Widget? topRowWidget,
        String? highlightedText,
        RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    //this.localRefreshDataOnParentFunction = refreshDataOnParentFunction;

    if (renderedNode.nodeType == VwNode.ntnTopNodeInsert) {
      if (topRowWidget != null) {
        return topRowWidget;
      } else {
        return Container();
      }
    }




    return VwNodeUserGroupAccessRowViewer(refreshDataOnParentFunction: implementRefreshDataOnParentFunction,  targetNode: this.widget.node,  appInstanceParam: widget.appInstanceParam, rowNode: renderedNode);




  }

  VwRowData getRecipientListApiCallParam(){

    String currentUserId=widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;

    dynamic depth1FilterObject = {
      "nodeId":this.widget.node.recordId
    };


    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId", valueString: "response_vwnodeusergroupaccess"),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: depth1FilterObject)
        ]);

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {

    Widget peopleWithAccessNodeList= NodeListView(
      mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
      key: this.stateKey,
      enableScaffold: true,
      appInstanceParam: this.widget.appInstanceParam,
      apiCallId: "getNodes",
      mainLogoTextCaption: 'User With Access ',
      mainLogoMode: NodeListView.mlmText,
      showBackArrow: false,
      nodeRowViewerFunction: nodeRowViewer,
      apiCallParam: this.getRecipientListApiCallParam(),

    );

    Widget addUserGroupAccess=InkWell(onTap: () async{

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VwShareNodeAcccesGroupPage(refreshDataOnParentFunction: this.implementRefreshDataOnParentFunction,   node: this.widget.node, appInstanceParam: this.widget.appInstanceParam,)),
      );



    }, child: Icon(Icons.person_add_alt),);




    return Scaffold(
      appBar: AppBar(
        actions: [addUserGroupAccess,SizedBox(width: 30,)],

        leading: InkWell(onTap: (){
        Navigator.pop(context);
      },  child: Icon(Icons.close_rounded),), title: Text('Manage Access '+'"'+this.widget.node.displayName+'"',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),),
      body: Column(children: [
        Flexible(flex:2, child: peopleWithAccessNodeList),

      ],),
    );



  }
}