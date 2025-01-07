import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';

class VwNodeInfoForm extends StatefulWidget{

  VwNodeInfoForm({required this.formResponse});
  final VwRowData formResponse;
  VwNodeInfoFormState createState()=> VwNodeInfoFormState();
}

class VwNodeInfoFormState extends State<VwNodeInfoForm>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Record Info"),), backgroundColor: Colors.grey, body:  Container(padding: EdgeInsets.fromLTRB(20, 5, 20, 5), color: Colors.white, child:Row(children: [
      Expanded(
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.black),
              children: <InlineSpan>[
                WidgetSpan(
                    child: InkWell(
                        onLongPress: () async {
                          await Clipboard.setData(ClipboardData(
                              text: widget.formResponse.recordId));

                          Fluttertoast.showToast(
                              msg: "Copied to clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.greenAccent,
                              textColor: Colors.white,
                              webBgColor:
                              "linear-gradient(to right, #07d0a9, #07d0a9)",
                              webPosition: "center",
                              fontSize: 16.0);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.copy, size: 14),
                              SizedBox(width: 20,),
                              Expanded(
                                  child: Text(
                                      overflow: TextOverflow.clip,
                                      "recordId: " +
                                          widget.formResponse.recordId,
                                      textAlign: TextAlign
                                          .start, // _snapshot.data['username']
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)))
                            ]))),
                TextSpan(text: "\n"),
                TextSpan(
                    text: widget.formResponse.creatorUserId == null
                        ? ""
                        : "Collection Name: " +
                        widget.formResponse.collectionName.toString() +
                        "\n"),
                TextSpan(
                    text: widget.formResponse.creatorUserId == null
                        ? ""
                        : "created by: " +
                        widget.formResponse.creatorUserId.toString() +
                        "\n"),
                TextSpan(
                    text: widget.formResponse.timestamp == null
                        ? ""
                        : "created: " +
                        VwDateUtil.indonesianShortFormatLocalTimeZone(
                            widget.formResponse.timestamp!.created) +
                        "\n"),
                TextSpan(
                    text: widget.formResponse.timestamp == null
                        ? ""
                        : "updated: " +
                        VwDateUtil.indonesianShortFormatLocalTimeZone(
                            widget.formResponse.timestamp!.updated))
              ],
            ),
          ))
    ])));
  }
}