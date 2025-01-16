import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/modules/vwlinknoderendered/vwlinknoderendered.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodeusergroupaccess/vwnodeusergroupaccess.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/vwformsubmitpage/vwformsubmitpage.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:vwutil/modules/util/widgetutil.dart';

class VwShareNodeAcccesGroupPage extends StatefulWidget {
  VwShareNodeAcccesGroupPage(
      {required this.node,
      this.targetUserGroup,
      this.refreshDataOnParentFunction,
      required this.appInstanceParam});
  final VwNode node;
  final VwNode? targetUserGroup;
  final VwAppInstanceParam appInstanceParam;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  static String fsLoading = "fsLoading";
  static String fsServerHasResponded = "fsServerHasResponded";
  static String fsDataSuccessfullyLoaded = "fsDataSuccessfullyLoaded";
  static String fsErrorConnectingServer = "fsErrorConnectingServer";
  static String fsUseLocalData = "fsUseLocalData";
  VwShareNodeAccesGroupPageState createState() =>
      VwShareNodeAccesGroupPageState();
}

class VwShareNodeAccesGroupPageState extends State<VwShareNodeAcccesGroupPage> {
  late Key stateKey;
  late StreamController<String> _refreshController;
  late bool loadFromServer;
  VwNodeRequestResponse? nodeRequestResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.stateKey = Key(Uuid().v4());

    this.loadFromServer = false;
    if (widget.targetUserGroup != null) {
      this.loadFromServer = true;
    }

    this._refreshController = StreamController<String>(onListen: () async {
      if (this.loadFromServer) {
        this._refreshController.sink.add(VwShareNodeAcccesGroupPage.fsLoading);
        await this.asyncLoadDataFromServer();
      } else {
        this
            ._refreshController
            .sink
            .add(VwShareNodeAcccesGroupPage.fsUseLocalData);
      }
    });
  }

  VwRowData apiCallParam() {
    String currentUserId =
        widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;

    dynamic depth1FilterObject = {
      "nodeId": this.widget.node.recordId,
    };

    if (this.widget.targetUserGroup != null) {
      depth1FilterObject = {
        "nodeId": this.widget.node.recordId,
        "targetUserGroupId": this.widget.targetUserGroup!.recordId
      };
    }

    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: "response_vwnodeusergroupaccess"),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: depth1FilterObject)
        ]);

    return returnValue;

    return returnValue;
  }

  Future<void> asyncLoadDataFromServer() async {
    try {
      this.nodeRequestResponse = await RemoteApi.nodeRequestApiCall(
        baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
          graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
          apiCallId: "getNodes",
          apiCallParam: this.apiCallParam(),
          loginSessionId: widget.appInstanceParam.loginResponse != null
              ? widget.appInstanceParam.loginResponse!.loginSessionId!
              : "<invalid_loginSessionId>");

      if (this.isDataSucessfullyLoaded()) {
        this
            ._refreshController
            .sink
            .add(VwShareNodeAcccesGroupPage.fsDataSuccessfullyLoaded);
      } else if (this.isServerResponded()) {
        this
            ._refreshController
            .sink
            .add(VwShareNodeAcccesGroupPage.fsServerHasResponded);
      } else {
        this
            ._refreshController
            .sink
            .add(VwShareNodeAcccesGroupPage.fsErrorConnectingServer);
      }
    } catch (error) {
      print("Error catched on Future<void> asyncLoadDataFromServer() async " +
          error.toString());
    }
    //await this._refreshController.close();
  }

  VwNode? getNodeUserGroupAccess(VwNodeRequestResponse? fNodeRequestResponse) {
    VwNode? returnValue;
    try {
      if (fNodeRequestResponse != null &&
          fNodeRequestResponse.renderedNodePackage != null &&
          fNodeRequestResponse.renderedNodePackage!.renderedNodeList != null) {
        returnValue = fNodeRequestResponse
            .renderedNodePackage!.renderedNodeList!
            .elementAt(0);
      }
    } catch (error) {}
    return returnValue;
  }

  List<String> getNodeAccessList(VwNodeRequestResponse? fNodeRequestResponse) {
    List<String> returnValue = [];
    try {
      VwNode? currentNode = this.getNodeUserGroupAccess(fNodeRequestResponse);

      if (currentNode != null) {
        VwNodeUserGroupAccess currentNodeUserGroupAccess =
            VwNodeUserGroupAccess.fromJson(
                currentNode.content.classEncodedJson!.data!);

        if (currentNodeUserGroupAccess.access != null) {
          returnValue = currentNodeUserGroupAccess.access!;
        }
      }
    } catch (error) {}

    return returnValue;
  }

  void refreshAfterSuccessfulSubmit() {
    if (this.widget.refreshDataOnParentFunction != null) {
      this.widget.refreshDataOnParentFunction!();
    }
  }

  VwRowData? presetValues() {
    VwRowData? returnValue;
    try {
      String shareNodeAccessGroupRecordId = Uuid().v4();

      if (this.getNodeUserGroupAccess(this.nodeRequestResponse) != null) {
        try {
          VwNode? userGroupAccessNode =
              this.getNodeUserGroupAccess(this.nodeRequestResponse);

          VwNodeUserGroupAccess nodeUserGroupAccess =
              VwNodeUserGroupAccess.fromJson(
                  userGroupAccessNode!.content!.classEncodedJson!.data!);

          shareNodeAccessGroupRecordId = nodeUserGroupAccess.recordId;
        } catch (error) {}
      }

      returnValue = VwRowData(recordId: shareNodeAccessGroupRecordId, fields: [
        VwFieldValue(fieldName: "nodeid", valueString: widget.node.recordId),
        VwFieldValue(
            fieldName: "sharedbyuser",
            valueTypeId: VwFieldValue.vatValueLinkNode,
            valueLinkNode: VwLinkNode(
                nodeType: VwNode.ntnClassEncodedJson,
                nodeId: this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .userInfo!
                    .user
                    .recordId)),
        VwFieldValue(
            fieldName: "nodeaccess",
            valueTypeId: VwFieldValue.vatValueStringList,
            valueStringList: this.getNodeAccessList(this.nodeRequestResponse))
      ]);

      if (this.widget.targetUserGroup != null) {
        VwFieldValue targetUserGroup = VwFieldValue(
            fieldName: "targetusergroup",
            valueTypeId: VwFieldValue.vatValueLinkNode,
            valueLinkNode: VwLinkNode(
                nodeId: this.widget.targetUserGroup!.recordId,
                nodeType: VwNode.ntnClassEncodedJson,
                rendered: VwLinkNodeRendered(
                    renderedDate: DateTime.now(),
                    node: this.widget.targetUserGroup)));

        returnValue.fields!.add(targetUserGroup);
      }
    } catch (error) {}

    return returnValue;
  }

  Widget _buildLoadingWidget(String caption) {
    return WidgetUtil.loadingWidget(caption);
  }

  Widget _reloadForm(String caption) {
    Widget body = InkWell(
        onTap: () async {
          this
              ._refreshController
              .sink
              .add(VwShareNodeAcccesGroupPage.fsLoading);
          await this.asyncLoadDataFromServer();
        },
        child: Container(
            color: Colors.blue,
            child: Icon(Icons.refresh, color: Colors.white, size: 60)));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        body,
        Container(margin: EdgeInsets.all(10), child: Text(caption))
      ],
    );
  }

  Widget _reloadFormWithScaffold(String caption) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(child: this._reloadForm(caption)));
  }

  Widget _builReloadForm(String caption) {
    return this._reloadFormWithScaffold(caption);
  }

  bool isDataSucessfullyLoaded() {
    bool returnValue = false;
    try {
      if (this.loadFromServer == true &&
          this.nodeRequestResponse != null &&
          this.nodeRequestResponse!.httpResponse!.statusCode == 200 &&
          this.nodeRequestResponse!.renderedNodePackage!.renderedNodeList !=
              null &&
          this
                  .nodeRequestResponse!
                  .renderedNodePackage!
                  .renderedNodeList!
                  .length >
              0) {
        returnValue = true;
      }
    } catch (error) {}
    return returnValue;
  }

  bool isServerResponded() {
    bool returnValue = false;
    try {
      if (this.loadFromServer == true &&
          this.nodeRequestResponse != null &&
          this.nodeRequestResponse!.httpResponse!.statusCode == 200) {
        returnValue = true;
      }
    } catch (error) {}
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _refreshController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == VwShareNodeAcccesGroupPage.fsUseLocalData) {
              return VwFormSubmitPage(
                presetValues: this.presetValues(),
                key: this.stateKey,
                defaultFormDefinitionIdList: [
                  "sharenodeaccessusergroupformdefinition"
                ],
                appInstanceParam: widget.appInstanceParam,
                refreshDataOnParentFunction: this.refreshAfterSuccessfulSubmit,
              );
            } else if (snapshot.data ==
                VwShareNodeAcccesGroupPage.fsDataSuccessfullyLoaded) {
              return VwFormSubmitPage(
                presetValues: this.presetValues(),
                key: this.stateKey,
                defaultFormDefinitionIdList: [
                  "sharenodeaccessusergroupeditrecordformdefinition"
                ],
                appInstanceParam: widget.appInstanceParam,
                refreshDataOnParentFunction: this.refreshAfterSuccessfulSubmit,
              );
            } else if (snapshot.data ==
                VwShareNodeAcccesGroupPage.fsServerHasResponded) {
              return this._buildLoadingWidget("Data Not Available");
            } else if (snapshot.data == VwShareNodeAcccesGroupPage.fsLoading) {
              return this._buildLoadingWidget("Loading From Server...");
            } else {
              return this._builReloadForm(
                  "Error: Not Connected To Server. Click to Reload Page");
            }
          } else {
            return this._buildLoadingWidget("Loading...");
          }
        });
  }
}
