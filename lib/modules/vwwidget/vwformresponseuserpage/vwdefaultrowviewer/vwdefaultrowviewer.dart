import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwbrowsefolderrowviewer/vwbrowsefolderrowviewer.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwheadmessagemessengerrowviewer/vwheadmessagemessengerrowviewer.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwusermessagemessengerrowviewer/vwusermessagemessengerrowviewer.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwDefaultRowViewer extends StatefulWidget {
  VwDefaultRowViewer(
      {required super.key,
      required this.appInstanceParam,
      required this.rowNode,
      this.highlightedText,
      this.refreshDataOnParentFunction,
      this.rowViewerBoxContraints,
      this.commandToParentFunction,
      this.localeId = "id_ID",
      this.customCardtapper,
      this.reloadPeriodic = 20});

  final int reloadPeriodic;
  final VwAppInstanceParam appInstanceParam;
  final VwNode rowNode;
  final String? highlightedText;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final BoxConstraints? rowViewerBoxContraints;
  final CommandToParentFunction? commandToParentFunction;
  final String localeId;
  final InkWell? customCardtapper;
  VwDefaultRowViewerState createState() => VwDefaultRowViewerState();
}

class VwDefaultRowViewerState extends State<VwDefaultRowViewer> {
  late StreamController<String> _refreshController;
  late VwNode nodeCurrent;

  Timer? timer;
  late String currentState; // init, doRefresh onRefresh, standby
  DateTime? lastRefresh;
  late bool isVisible;
  late bool isForceRefreshRecord;

  static String initRvState="initRvState";
  static String doRefreshRvState="doRefreshRvState";
  static String onRefreshRvState="onRefreshRvState";
  static String standbyRvState="standbyRvState";

  @override
  void initState() {
    super.initState();

    nodeCurrent = widget.rowNode;
    currentState = VwDefaultRowViewerState.initRvState;
    this._refreshController = new StreamController<String>();
    this.timer = Timer.periodic(
        Duration(seconds: widget.reloadPeriodic), implementOnTimer);
    isVisible = true;
    this.isForceRefreshRecord = false;
  }

  void implementReloadRecordOnParent() {
    setState(() {
      this.isForceRefreshRecord = true;
      this._handleRefresh();
    });
  }

  Future<void> _handleRefresh() async {
    try {
      if (this.isVisible == true || this.isForceRefreshRecord == true) {
        int deltaSeconds = lastRefresh == null
            ? 0
            : DateTime.now().difference(lastRefresh!).inSeconds;
        if ((lastRefresh != null && deltaSeconds > widget.reloadPeriodic) ||
            this.isForceRefreshRecord == true) {
          this.isForceRefreshRecord = false;
          try {
            await this._asyncLoadData();
          } catch (error) {}
          this.lastRefresh = DateTime.now();
        } else if (lastRefresh == null) {
          this.lastRefresh = DateTime.now();
        }
      }
    } catch (error) {}
  }

  @override
  void dispose() {
    this.timer!.cancel();
    this._refreshController.close();
    super.dispose();
  }

  void implementOnTimer(Timer timer) async {
    // callback function

    setState(() {
      this._handleRefresh();
    });


  }

  VwRowData apiCallParam() {
    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId", valueString: this.widget.rowNode.recordId),
          VwFieldValue(
              fieldName: "currentStateKey", valueString: this.nodeCurrent.stateKey),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          /*VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: { "nodeType": VwNode.ntnFolder }),*/
          VwFieldValue(
              fieldName: "sortObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {"displayName": 1}),
          VwFieldValue(
              fieldName: "disableUserGroupPOV",
              valueTypeId: VwFieldValue.vatBoolean,
              valueBoolean: true),
        ]);

    return returnValue;
  }

  Future<VwNode> _asyncLoadData() async {
    VwNode returnValue = nodeCurrent;
    try {
      currentState = VwDefaultRowViewerState.onRefreshRvState;

      VwNodeRequestResponse nodeRequestResponse =
          await RemoteApi.nodeRequestApiCall(
              baseUrl: this
                  .widget
                  .appInstanceParam
                  .baseAppConfig
                  .generalConfig
                  .baseUrl,
              graphqlServerAddress: this
                  .widget
                  .appInstanceParam
                  .baseAppConfig
                  .generalConfig
                  .graphqlServerAddress,
              apiCallId: "getNodes",
              apiCallParam: this.apiCallParam(),
              loginSessionId: widget.appInstanceParam.loginResponse != null
                  ? widget.appInstanceParam.loginResponse!.loginSessionId!
                  : "<invalid_loginSessionId>");

      if (nodeRequestResponse.renderedNodePackage!.rootNode != null) {

        bool doUpdateCurrentNode=true;
        VwNode newCandidateNode=nodeRequestResponse.renderedNodePackage!.rootNode!;

        if(newCandidateNode.nodeStatusId==VwNode.nsDeleted)
          {
            print("Record has been deleted");
          }

        if( newCandidateNode.nodeStatusId==VwNode.nsDeleted || (nodeCurrent.stateKey!=null && newCandidateNode.stateKey!=null && nodeCurrent.stateKey!=newCandidateNode.stateKey))
          {

          }
        else{
          doUpdateCurrentNode=false;
        }


        if(doUpdateCurrentNode)
          {
            nodeCurrent = newCandidateNode ;
            returnValue = nodeCurrent;
            setState(() {});
          }





      } else if (nodeRequestResponse.apiCallResponse!.responseStatusCode ==
              200 &&
          nodeRequestResponse.renderedNodePackage != null &&
          nodeRequestResponse.renderedNodePackage!.rootNode == null) {
        setState(() {
          this.nodeCurrent.nodeStatusId = VwNode.nsDeleted;
        });
      }
      currentState = VwDefaultRowViewerState.standbyRvState;
    } catch (error) {
      print(error.toString());
    }
    currentState =  VwDefaultRowViewerState.standbyRvState;
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _refreshController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (this.nodeCurrent.recordId ==
              "cd0a49d1-3f8b-4b7f-9c68-6880f8b97c03") {
            print(this.nodeCurrent.recordId);
            print(this.nodeCurrent.nodeStatusId);
          }

          if (this.nodeCurrent.nodeStatusId == VwNode.nsDeleted) {
            return Container();
          } else if (this.nodeCurrent.content.rowData != null &&
              this.nodeCurrent.content.rowData!.collectionName ==
                  "messagemessengerformdefinition") {
            return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: VisibilityDetector(
                  key: Key(this.nodeCurrent.recordId),
                  onVisibilityChanged: (visibilityInfo) {
                    var visiblePercentage =
                        visibilityInfo.visibleFraction * 100;
                    if (visiblePercentage > 10) {
                      this.isVisible = true;
                    } else {
                      this.isVisible = false;
                    }
                  },
                  child: VwUserMessageMessengerRowViewer(
                      appInstanceParam: widget.appInstanceParam,
                      rowNode: this.nodeCurrent,
                      rowViewerBoxContraints:
                          this.widget.rowViewerBoxContraints,
                      highlightedText: widget.highlightedText,
                      refreshDataOnParentFunction:
                          widget.refreshDataOnParentFunction,
                      commandToParentFunction: widget.commandToParentFunction),
                ));
          } else if (this.nodeCurrent.content.rowData != null &&
              this.nodeCurrent.content.rowData!.collectionName ==
                  "headmessagemessengerformdefinition") {
            return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: VisibilityDetector(
                  key: Key(this.nodeCurrent.recordId),
                  onVisibilityChanged: (visibilityInfo) {
                    var visiblePercentage =
                        visibilityInfo.visibleFraction * 100;
                    if (visiblePercentage > 10) {
                      this.isVisible = true;
                    } else {
                      this.isVisible = false;
                    }
                  },
                  child: VwHeadMessageMessengerRowViewer(
                      appInstanceParam: widget.appInstanceParam,
                      rowNode: this.nodeCurrent,
                      rowViewerBoxContraints:
                          this.widget.rowViewerBoxContraints,
                      highlightedText: widget.highlightedText,
                      refreshDataOnParentFunction:
                          widget.refreshDataOnParentFunction,
                      commandToParentFunction: widget.commandToParentFunction),
                ));
          } else {
            return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: VisibilityDetector(
                  key: widget.key == null
                      ? Key(this.nodeCurrent.recordId)
                      : widget.key!,
                  onVisibilityChanged: (visibilityInfo) {
                    var visiblePercentage =
                        visibilityInfo.visibleFraction * 100;
                    if (visiblePercentage > 10) {
                      this.isVisible = true;
                    } else {
                      this.isVisible = false;
                    }
                  },
                  child: VwBrowseFolderRowViewer(
                      key: Key(this.nodeCurrent.recordId),
                      appInstanceParam: widget.appInstanceParam,
                      rowNode: this.nodeCurrent,
                      rowViewerBoxContraints:
                          this.widget.rowViewerBoxContraints,
                      highlightedText: widget.highlightedText,
                      refreshDataOnParentRecordFunction:
                          implementReloadRecordOnParent,
                      refreshDataOnParentFunction:
                          widget.refreshDataOnParentFunction,
                      commandToParentFunction: widget.commandToParentFunction),
                ));
          }
        });
  }
}
