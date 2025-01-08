import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwmessenger/vwmessagerecipientrowviewer.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwSelectRecipientWidget extends StatefulWidget{

  const VwSelectRecipientWidget({required this.appInstanceParam,

  });

  final VwAppInstanceParam appInstanceParam;


  VwSelectRecipientWidgetState createState()=> VwSelectRecipientWidgetState();
}

class VwSelectRecipientWidgetState extends State<VwSelectRecipientWidget>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    return VwMessageRecipientRowViewer( rowNode: renderedNode,
      appInstanceParam: this.widget.appInstanceParam,
      //rowViewerBoxContraints: this.widget.rowViewerBoxContraints,
      highlightedText: highlightedText,
      refreshDataOnParentFunction: refreshDataOnParentFunction,

      //commandToParentFunction:this.widget.commandToParentFunction != null? implementCommandToParentFunction:null,
    );


  }

  VwRowData getRecipientListApiCallParam(){

    String currentUserId=widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;

    dynamic depth1FilterObject = {
      "nodeStatusId":VwNode.nsActive,
      "content.classEncodedJson.collectionName":"vwuser",

    };


    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId", valueString: "response_vwuser"),
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
    return NodeListView(

      appInstanceParam: this.widget.appInstanceParam,
      apiCallId: "getNodes",
      mainLogoTextCaption: "Select user",
      mainLogoMode: NodeListView.mlmText,
      showBackArrow: true,
      nodeRowViewerFunction: nodeRowViewer,
      apiCallParam: this.getRecipientListApiCallParam(),
    );
  }
}