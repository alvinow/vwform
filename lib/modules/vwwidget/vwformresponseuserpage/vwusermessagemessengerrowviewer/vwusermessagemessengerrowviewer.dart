import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwwidget/noderowviewer/noderowviewer.dart';
import 'package:matrixclient/modules/vwwidget/vwformresponseuserpage/vwusermessagemessengerrowviewer/messagemessengerviewer.dart';

class VwUserMessageMessengerRowViewer extends NodeRowViewer {
  VwUserMessageMessengerRowViewer({
    super.key,
    required super.appInstanceParam,
    required super.rowNode,
    super.highlightedText,
    super.refreshDataOnParentFunction,
    super.rowViewerBoxContraints,
    super.commandToParentFunction,
    super.localeId,
  });

  String? getMessageText() {
    String? returnValue;
    try {
      returnValue =
          this.rowNode.content.rowData?.getFieldByName("message")?.valueString;
    } catch (error) {}
    return returnValue;
  }

  String? getCurrentUserRecordId() {
    String? returnValue;
    try {
      returnValue =
          this.appInstanceParam.loginResponse?.userInfo?.user?.recordId;
    } catch (error) {}
    return returnValue;
  }

  String? getSenderRecordId() {
    String? returnValue;
    try {
      VwFieldValue? senderFieldValue =
          this.rowNode.content.rowData?.getFieldByName("sender");

      if (senderFieldValue != null) {
        returnValue = senderFieldValue!.valueLinkNode!.nodeId!;
      }
    } catch (error) {}
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    String? messageText = this.getMessageText();

    Widget myMessageWidget = MessageMessengerViewer(
      nodeId: this.rowNode.recordId,
        rowMainAxisAlignment: MainAxisAlignment.end,
        textMessage: messageText.toString(),
        backgroundColor:Colors.blue,
        dateTime: this.rowNode.timestamp!.created);
    //Widget otherMessageWidget=Row(mainAxisAlignment: MainAxisAlignment.end, children:[Container(padding:EdgeInsets.all(6),margin: EdgeInsets.fromLTRB(0, 2,0, 2), color: Colors.green, constraints: BoxConstraints(maxWidth: 400), child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(messageText.toString(),style: TextStyle(fontSize: 14,color: Colors.white),),Text(this.rowNode.timestamp!.updated.toString(),style: TextStyle(fontSize: 11),)]))]);
    Widget otherMessageWidget = MessageMessengerViewer(
        nodeId: this.rowNode.recordId,
        rowMainAxisAlignment: MainAxisAlignment.start,
        backgroundColor: Color.fromARGB(255, 50, 50, 50),
        textMessage: messageText.toString(),
        dateTime: this.rowNode.timestamp!.created);

    Widget messageRow = myMessageWidget;

    String? senderRecordId = this.getSenderRecordId();
    String? currentUserRecordId = this.getCurrentUserRecordId();

    if (currentUserRecordId != null) {
      if (senderRecordId != currentUserRecordId) {
        messageRow = otherMessageWidget;
      }
    }

    return messageRow;
  }
}
