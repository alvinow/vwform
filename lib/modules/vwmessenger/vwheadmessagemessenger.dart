import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwmessenger/vwselectmessagerecipientwidget.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:matrixclient/modules/vwwidget/vwformresponseuserpage/vwdefaultrowviewer/vwdefaultrowviewer.dart';
import 'package:uuid/uuid.dart';

class VwHeadMessageMessenger extends StatefulWidget{

  VwHeadMessageMessenger({required this.appInstanceParam});
  VwAppInstanceParam appInstanceParam;

  VwmessengerState createState() => VwmessengerState();
}

class VwmessengerState extends State<VwHeadMessageMessenger>{

  late Key stateKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.stateKey=Key(Uuid().v4());
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

    return VwDefaultRowViewer(key:Key(renderedNode.recordId), rowNode: renderedNode,
      appInstanceParam: this.widget.appInstanceParam,
      //rowViewerBoxContraints: this.widget.rowViewerBoxContraints,
      highlightedText: highlightedText,
      refreshDataOnParentFunction: this.implementRefreshDataOnParent,
      //commandToParentFunction:this.widget.commandToParentFunction != null? implementCommandToParentFunction:null,
    );


  }
  void implementRefreshDataOnParent()
  {
    this.reloadNodeListView();
  }

  VwRowData getHeadMessengerApiCallParam(){

    String currentUserId=widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;

    dynamic depth1FilterObject = {
      "nodeStatusId":VwNode.nsActive,
      "content.rowData.collectionName": "headmessagemessengerformdefinition",
      "content.rowData.fields": {
        r"$all": [
          {
            r"$elemMatch": {
             r"$and":[
               {
                 "fieldName": "me",
                 "valueLinkNode.nodeId": currentUserId
               },

             ]
            }
          },
        ]
      }
    };


    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId", valueString: "response_headmessagemessengerformdefinition"),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: depth1FilterObject)
        ]);

    return returnValue;
  }

  void reloadNodeListView(){
    this.stateKey=Key(Uuid().v4());
    setState(() {

    });
  }

  Widget _getCreateRecordFloatingActionButton(
      {required BuildContext context,
        required VwAppInstanceParam appInstanceParam,
        SyncNodeToParentFunction? syncNodeToParentFunction,
        RefreshDataOnParentFunction? refreshDataOnParentFunction}) {
    const widgetKey = "123456789";
    return FloatingActionButton.small(
      key: Key(widgetKey),
        backgroundColor: Color.fromARGB(160, 10, 139, 245),
        foregroundColor: Colors.white,
        child: const Stack(alignment: AlignmentDirectional.center, children:[Icon(Icons.messenger),Icon(Icons.add,size: 15, color: Colors.blue,), ]),
        onPressed: () async {
          await Navigator.of(context).push(

            MaterialPageRoute(
                builder: (context) => VwSelectRecipientWidget(appInstanceParam: this.widget.appInstanceParam),
          ));


          this.reloadNodeListView();

        });
  }

  @override
  Widget build(BuildContext context) {
    return NodeListView( key: this.stateKey, getFloatingActionButton: this._getCreateRecordFloatingActionButton, mainLogoMode: NodeListView.mlmText, mainLogoTextCaption: "Messenger", showBackArrow: true, appInstanceParam: widget.appInstanceParam, apiCallParam: getHeadMessengerApiCallParam(), nodeRowViewerFunction: nodeRowViewer);
  }
}