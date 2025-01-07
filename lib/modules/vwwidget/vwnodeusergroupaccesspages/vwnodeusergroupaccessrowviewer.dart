import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodeusergroupaccess/vwnodeusergroupaccess.dart';
import 'package:matrixclient/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:matrixclient/modules/edokumen2022/remoteapi/remote_api.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwclassencodedjsonhiveprovider/vwclassencodedjsonhiveprovider.dart';
import 'package:matrixclient/modules/vwclassencodedjsonstoreonhive/vwclassencodedjsonstoreonhive.dart';
import 'package:matrixclient/modules/vwmessenger/vwusermessagemessenger.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:matrixclient/modules/vwwidget/vwnodeusergroupaccesspages/vwsharenodeaccessgrouppage.dart';

class VwNodeUserGroupAccessRowViewer extends StatefulWidget{


  VwNodeUserGroupAccessRowViewer({required this.appInstanceParam,
    required this.rowNode,
    required this.targetNode,
    this.highlightedText,
    this.refreshDataOnParentFunction,
    this.rowViewerBoxContraints,
    this.commandToParentFunction,
    this.localeId = "id_ID",
    this.customCardtapper,

  });


  final VwAppInstanceParam appInstanceParam;
  final VwNode rowNode;
  final VwNode targetNode;
  final String? highlightedText;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final BoxConstraints? rowViewerBoxContraints;
  final CommandToParentFunction? commandToParentFunction;
  final String localeId;
  final InkWell? customCardtapper;

  VwNodeUserGroupAccessRowViewerState createState()=> VwNodeUserGroupAccessRowViewerState();
}



class VwNodeUserGroupAccessRowViewerState extends State<VwNodeUserGroupAccessRowViewer>{

  VwNodeRequestResponse? nodeRequestResponse;

  String getSenderTitle(){
    String returnValue=this.widget.rowNode.recordId;
    try
    {
      returnValue=this.widget.rowNode.content.classEncodedJson?.data?["displayname"]+" ("+this.widget.rowNode.content.classEncodedJson?.data?["username"]+")";
    }
    catch(error)
    {

    }
    return returnValue;
  }

  VwNode? getTargetUserGroupRecord(){
    VwNode? returnValue;
    try
    {
      VwNodeUserGroupAccess currentObject=VwNodeUserGroupAccess.fromJson(widget.rowNode.content.classEncodedJson!.data!);
      returnValue=NodeUtil.extractNodeFromLinkNode(currentObject.targetUserGroup!);
    }
    catch(error)
    {

    }

    return returnValue;
  }

  String? getTargetUserGroupRecordId(){
    String? returnValue;
    try
        {
          VwNodeUserGroupAccess currentObject=VwNodeUserGroupAccess.fromJson(widget.rowNode.content.classEncodedJson!.data!);
          returnValue= currentObject.targetUserGroup!.nodeId;
        }
        catch(error)
    {

    }

    return returnValue;
  }

  void openUserMessageMessenger(){

    String? targetUserGroupRecordId= this.getTargetUserGroupRecordId();

    //Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(

          builder: (context) => VwShareNodeAcccesGroupPage(refreshDataOnParentFunction: this.widget.refreshDataOnParentFunction, node: this.widget.targetNode, targetUserGroup: this.getTargetUserGroupRecord(), appInstanceParam: widget.appInstanceParam),
        ));

  }





  VwNode? getSharedByUserNode(){
    VwNode? returnValue;
    if(this.widget.rowNode.content.classEncodedJson!=null && this.widget.rowNode.content.classEncodedJson!.collectionName=="vwnodeusergroupaccess" )
    {
      try
      {
        VwClassEncodedJson currentClassEncodedJson=this.widget.rowNode.content.classEncodedJson!;

        if(currentClassEncodedJson.isCompressed==true)
        {
          RemoteApi.decompressClassEncodedJson(currentClassEncodedJson);
        }

        VwLinkNode currentLinkNode=VwLinkNode.fromJson(currentClassEncodedJson.data!["sharedByUser"]);

        returnValue= NodeUtil.extractNodeFromLinkNode(currentLinkNode);


      }
      catch(error)
      {

      }
    }

    return returnValue;
  }

  String getTargetUserGroupDisplayName(){
    String returnValue=this.widget.rowNode.recordId;
    try {
      returnValue=this.getTargetUserGroupRecord()!.content.classEncodedJson!.data!["displayname"]+" ("+this.getTargetUserGroupRecord()!.content.classEncodedJson!.data!["username"]+")";
    }
    catch(error)
    {

    }

    return returnValue;
  }

  String getSharedByUserDisplayName(){
    String returnValue=this.widget.rowNode.recordId;
    try {
      returnValue=this.getSharedByUserNode()!.content.classEncodedJson!.data!["displayname"]+" ("+this.getSharedByUserNode()!.content.classEncodedJson!.data!["username"]+")";
    }
    catch(error)
    {

    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {



    return InkWell(onTap: (){
      this.openUserMessageMessenger();
    }, child: Container(margin: EdgeInsets.fromLTRB(0, 8, 5, 8), child:Row(children:[Icon(Icons.account_circle,size: 40, color: Colors.blueGrey,), Container(margin: EdgeInsets.fromLTRB(7, 0, 0, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[  Text(this.getTargetUserGroupDisplayName(),style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600), ),Text("Shared by "+this.getSharedByUserDisplayName(),style: TextStyle(fontSize: 11,fontWeight: FontWeight.w300), ) ])  )])));
  }
}