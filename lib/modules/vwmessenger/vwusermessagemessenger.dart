import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwmessenger/sendmessageboxwidget.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwdefaultrowviewer/vwdefaultrowviewer.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwUserMessageMessenger extends StatefulWidget {
  VwUserMessageMessenger({
    required this.appInstanceParam,
    required this.senderRecord,
    required this.baseurl
  });
  VwAppInstanceParam appInstanceParam;
  VwNode senderRecord;
  final String baseurl;

  VwUserMessageMessengerState createState() => VwUserMessageMessengerState();
}

class VwUserMessageMessengerState extends State<VwUserMessageMessenger> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("entering chat with " + widget.senderRecord.recordId);
  }

  Widget messageBoxPluginWidget(
      {required VwRowData? parameter,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
    String? recipientRecordId;

    if (parameter != null) {
      recipientRecordId =
          parameter.getFieldByName("recipientRecordId")?.valueString;
    }

    return SendMesageBoxWidget(
      refreshDataOnParentFunction: refreshDataOnParentFunction,
      appInstanceParam: this.widget.appInstanceParam,
      recipientRecordId: recipientRecordId.toString(),
    );
  }

  Widget nodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
    //this.localRefreshDataOnParentFunction = refreshDataOnParentFunction;

    if (renderedNode.nodeType == VwNode.ntnTopNodeInsert) {
      if (topRowWidget != null) {
        return topRowWidget;
      } else {
        return Container();
      }
    }

    return VwDefaultRowViewer(
      key:Key(renderedNode.recordId),
      rowNode: renderedNode,
      appInstanceParam: this.widget.appInstanceParam,
      //rowViewerBoxContraints: this.widget.rowViewerBoxContraints,
      highlightedText: highlightedText,
      refreshDataOnParentFunction: refreshDataOnParentFunction,
      //commandToParentFunction:this.widget.commandToParentFunction != null? implementCommandToParentFunction:null,
    );
  }

  VwRowData getHeadMessengerApiCallParam() {
    String currentUserId =
        widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;

    dynamic sortObject = {"timestamp.created": -1};

    dynamic fromMeFilterObject = {
      "nodeStatusId": VwNode.nsActive,
      "content.rowData.fields": {
        r"$all": [
          {
            r"$elemMatch": {
              "fieldName": "recipient",
              "valueLinkNode.nodeId":{ r"$in": [this.widget.senderRecord.recordId]}
            }
          },
          {
            r"$elemMatch": {
              "fieldName": "sender",
              "valueLinkNode.nodeId": { r"$in": [currentUserId]}
            }
          },
        ]
      }
    };

    dynamic fromOtherFilterObject = {
      "nodeStatusId": VwNode.nsActive,
      "content.rowData.fields": {
        r"$all": [
          {
            r"$elemMatch": {
              "fieldName": "recipient",
              "valueLinkNode.nodeId":{ r"$in": [currentUserId,]}
            }
          },
          {
            r"$elemMatch": {
              "fieldName": "sender",
              "valueLinkNode.nodeId": { r"$in": [this.widget.senderRecord.recordId]}
            }
          },
        ]
      }
    };


    dynamic depth1FilterObject={
      r"$or":[
        fromMeFilterObject,
        fromOtherFilterObject
      ]
    };

    print(depth1FilterObject.toString());

    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: "response_messagemessengerformdefinition"),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: depth1FilterObject),
          VwFieldValue(
              fieldName: "sortObject",
              valueTypeId: VwFieldValue.vatObject,
              value: sortObject)
        ]);

    return returnValue;
  }

  String getSenderTitle() {
    String returnValue = this.widget.senderRecord.recordId;
    try {
      returnValue = this
              .widget
              .senderRecord
              .content
              .classEncodedJson
              ?.data?["displayname"] +
          " (" +
          this.widget.senderRecord.content.classEncodedJson?.data?["username"] +
          ")";
    } catch (error) {}
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return NodeListView(
      baseUrl:  this.widget.baseurl,
        isListReverse: true,
        footer: this.messageBoxPluginWidget,
        footerWidgetParameter: VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "recipientRecordId",
              valueString: widget.senderRecord.recordId)
        ]),
        margin: EdgeInsets.fromLTRB(20, 65, 10, 65),
        backgroundColor: Colors.black,
        mainLogoMode: NodeListView.mlmText,
        mainLogoTextCaption: this.getSenderTitle(),
        showBackArrow: true,
        appInstanceParam: widget.appInstanceParam,
        apiCallParam: getHeadMessengerApiCallParam(),
        nodeRowViewerFunction: nodeRowViewer);
  }
}
