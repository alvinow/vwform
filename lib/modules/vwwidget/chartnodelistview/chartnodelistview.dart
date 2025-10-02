import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/chartnodelistview/chartnodeviewer.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class ChartNodeListView extends StatefulWidget{
  ChartNodeListView({
    super.key,
    required this.appInstanceParam,
    this.isRootFolder=true,
    required this.pageTitleCaption,
    required this.folderNodeId,
     this.currentNode
});

  static const String btrSearchNodeComment="btrSearchNodeComment";

  final VwAppInstanceParam appInstanceParam;
  final bool isRootFolder;
  final String pageTitleCaption;
  final String folderNodeId;
  final VwNode? currentNode;


  ChartNodeListViewState createState()=>ChartNodeListViewState();
}

class ChartNodeListViewState extends State<ChartNodeListView>{

  late Key stateKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.stateKey =widget.key==null?Key(Uuid().v4().toString()):widget.key!;
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


    return ChartNodeViewer(appInstanceParam: widget.appInstanceParam, rowNode: renderedNode, highlightedText: highlightedText);

  }

  VwRowData apiCallParam(){
    return VwRowData(
        timestamp: VwDateUtil .nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: this.widget.folderNodeId ),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "sortObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {"indexKey.sortKey":-1, "displayName": 1}),
          VwFieldValue(
              fieldName: "disableUserGroupPOV",
              valueTypeId: VwFieldValue.vatBoolean,
              valueBoolean: true),
        ]);
  }

  @override
  Widget build(BuildContext context) {

    Widget body=NodeListView (
      mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
      mainHeaderBackgroundColor: const Color.fromARGB(255,200, 200, 200),
        mainHeaderTitleTextColor: Colors.black,
        appInstanceParam:  this.widget.appInstanceParam,
        key: this.stateKey,
        apiCallId: "getNodes",
        mainLogoMode: NodeListView.mlmText,
        mainLogoTextCaption: widget.pageTitleCaption,
        showUserInfoIcon: widget.isRootFolder,
        nodeRowViewerFunction: nodeRowViewer,
        apiCallParam: this.apiCallParam(),
        showSearchIcon: false,
        showBackArrow: this.widget.isRootFolder==false,
        );
    return body;
  }
}