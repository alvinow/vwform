import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwmessenger/vwusermessagemessenger.dart';


class VwMessageRecipientRowViewer extends StatefulWidget {
  VwMessageRecipientRowViewer({
    required this.appInstanceParam,
    required this.rowNode,
    this.highlightedText,
    this.refreshDataOnParentFunction,
    this.rowViewerBoxContraints,
    this.commandToParentFunction,
    this.localeId = "id_ID",
    this.customCardtapper,

  });

  final VwAppInstanceParam appInstanceParam;
  final VwNode rowNode;
  final String? highlightedText;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final BoxConstraints? rowViewerBoxContraints;
  final CommandToParentFunction? commandToParentFunction;
  final String localeId;
  final InkWell? customCardtapper;


  VwMessageRecipientRowViewerState createState() =>
      VwMessageRecipientRowViewerState();
}

class VwMessageRecipientRowViewerState
    extends State<VwMessageRecipientRowViewer> {
  String getSenderTitle() {
    String returnValue = this.widget.rowNode.recordId;
    try {
      returnValue =
          this.widget.rowNode.content.classEncodedJson?.data?["displayname"] +
              " (" +
              this.widget.rowNode.content.classEncodedJson?.data?["username"] +
              ")";
    } catch (error) {}
    return returnValue;
  }

  Future<void> openUserMessageMessenger() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VwUserMessageMessenger(


              senderRecord: this.widget.rowNode,
              appInstanceParam: this.widget.appInstanceParam),
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await this.openUserMessageMessenger();
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 8, 5, 8),
            child: Row(children: [
              Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.blueGrey,
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                  child: Text(
                    this.getSenderTitle(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ))
            ])));
  }
}
