import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwapicall/synctokenblock/synctokenblock.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodeupsyncresult/vwnodeupsyncresult.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';
import 'package:matrixclient/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:matrixclient/modules/base/vwuser/vwuser.dart';
import 'package:matrixclient/modules/deployedcollectionname.dart';
import 'package:matrixclient/modules/edokumen2022/remoteapi/remote_api.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/util/widgetutil.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
import 'package:matrixclient/modules/vwformpage/vwdefaultformpage.dart';
import 'package:matrixclient/modules/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:matrixclient/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:matrixclient/modules/vwwidget/vwnodesubmitpage/vwformeditorpage.dart';
import 'package:matrixclient/modules/vwwidget/vwnodesubmitpage/vwnodeeditorpage.dart';
import 'package:uuid/uuid.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

typedef VwNodeSubmitPageStateChanged = void Function(
    {required String pageState});

class VwNodeSubmitPage extends StatefulWidget {
  VwNodeSubmitPage({
    super.key,
    this.node,
    required this.parentNodeId,
    required this.appInstanceParam,
    this.refreshDataOnParentFunction,
    this.useParentFormDefinitionList = true,
    this.formDefinitionIdList,
    this.resultCallback,
    this.presetValues,
    this.nodeSubmitPageStateChanged,
    this.lockPresetValue = true,
    this.selectedFormDefinitionNode,
  });

  final VwNode? node;
  final String parentNodeId;
  final bool useParentFormDefinitionList;
  final VwAppInstanceParam appInstanceParam;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final List<String>? formDefinitionIdList;
  final VwFormPageResult? resultCallback;
  final VwRowData? presetValues;
  final bool lockPresetValue;
  final VwNodeSubmitPageStateChanged? nodeSubmitPageStateChanged;
  final VwNode? selectedFormDefinitionNode;

  static const String nspInitDataLoaded = 'nspInitDataLoaded';
  static const String nspErrorDataNotValid = 'nspErrorDataNotValid';
  static const String nspErrorLoadingInitData = 'nspErrorLoadingInitData';
  static const String nspLoadingInitData = 'nspLoadingInitData';
  static const String nspSyncingNode = 'nspSyncingNode';
  static const String nspErrorSyncingNode = 'nspErrorSyncingNode';
  static const String nspErrorSyncingNodeAuthError =
      'nspErrorSyncingNodeAuthError';
  static const String nspErrorSyncingNodeInvalidFormResponse =
      'nspErrorSyncingNodeInvalidFormResponse';
  static const String nspErrorSyncingNodeHttpError =
      'nspErrorSyncingNodeHttpError';
  static const String nspSuccessSyncingNode = 'nspSuccessSyncingNode';

  VwNodeSubmitPageState createState() => VwNodeSubmitPageState();
}

class VwNodeSubmitPageState extends State<VwNodeSubmitPage> {
  late StreamController<String> _refreshController;
  late String pageState;
  late VwNode? parentNode;
  late VwNode? currentNode;
  VwNode? selectedFormDefinitionNode;

  VwNodeUpsyncResult? lastNodeUpsyncResult;

  void implementOnSelectedFormDefinitionNodeChanged(
      {required VwNode selectedFormDefinitionNode}) {
    this.selectedFormDefinitionNode = selectedFormDefinitionNode;
    setState(() {});
  }

  List<VwNode> getDefaultFormDefinitionList() {
    List<VwNode> returnValue = [];
    try {
      if (this.parentNode != null &&
          this.parentNode!.defaultFormDefinitionList != null) {
        returnValue = this.parentNode!.defaultFormDefinitionList!;
      } else if (this.parentNode != null &&
          this.parentNode!.content.rowData != null) {
        VwNode? rowDataFormDefinitionNode = NodeUtil.extractNodeFromLinkNode(
            this.parentNode!.content.rowData!.formDefinitionLinkNode!);

        if (rowDataFormDefinitionNode != null) {
          VwFormDefinition? rowDataFormDefinition =
              NodeUtil.extractFormDefinitionFromNode(
                  rowDataFormDefinitionNode!);

          if (rowDataFormDefinition != null) {
            if (rowDataFormDefinition!.isAllowChildNodeContentRowData &&
                rowDataFormDefinition!.isSpecificChildNodeContentRowData) {
              if (rowDataFormDefinition!.childNodeFormDefinitionList != null) {
                returnValue =
                    rowDataFormDefinition!.childNodeFormDefinitionList;
              }
            }
          }
        }
      }

      if (returnValue.length > 0 &&
          widget.formDefinitionIdList != null &&
          widget.formDefinitionIdList!.length > 0) {
        List<VwNode> includedNode = [];

        for (int la = 0; la < returnValue.length; la++) {
          VwNode currentNode = returnValue.elementAt(la);
          if (widget.formDefinitionIdList!.indexOf(currentNode.recordId) >= 0) {
            includedNode.add(currentNode);
          }
        }
        returnValue = includedNode;
      }
    } catch (error) {}

    return returnValue;
  }

  @override
  void initState() {
    this.pageState = VwNodeSubmitPage.nspLoadingInitData;

    super.initState();

    this._refreshController = StreamController<String>(onListen: () async {
      if (this.widget.node != null) {
        this.currentNode = widget.node;
      } else {
        String recordId = Uuid().v4();

        String creatorUserId =
            this.widget.appInstanceParam.loginResponse != null &&
                    this.widget.appInstanceParam.loginResponse!.userInfo != null
                ? this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .userInfo!
                    .user
                    .recordId
                : "invalid_user_record_id";

        this.currentNode = VwNode(
            creatorUserId: creatorUserId,
            parentNodeId: widget.parentNodeId,
            recordId: recordId,
            ownerUserId:
                widget.appInstanceParam.loginResponse!.userInfo!.user.recordId,
            displayName: recordId,
            nodeType: VwNode.ntnRowData,
            content: VwNodeContent(rowData: VwRowData(parentNodeId: this.widget.parentNodeId, recordId: Uuid().v4())));
      }

      await this._asyncLoadData();
    });
  }

  Future<void> _asyncLoadData() async {
    await _asyncLoadParentNodeFromServer();
  }

  String getLoginSessionId() {
    String returnValue = AppConfig.loginSessionGuestUserId;
    try {
      returnValue = widget.appInstanceParam.loginResponse!.loginSessionId!;
    } catch (error) {}

    return returnValue;
  }

  Future<void> _syncNodeToServer(
      {String crudMode = VwBaseModel.cmCreateOrUpdate}) async {
    try {
      SyncTokenBlock? syncTokenBlock = await VwNodeStoreOnHive.getToken(
          loginSessionId:
              widget.appInstanceParam.loginResponse!.loginSessionId!,
          count: 1,
          apiCallId: "getToken");

      if (syncTokenBlock != null && syncTokenBlock!.tokenList.length > 0) {
        this.currentNode!.upsyncToken = syncTokenBlock!.tokenList.elementAt(0);

        this.currentNode!.crudMode = crudMode;

        VwRowData apiCallParam = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "node",
              valueTypeId: VwFieldValue.vatClassEncodedJson,
              valueClassEncodedJson: VwClassEncodedJson(
                  className: DeployedCollectionName.vwNode,
                  instanceId: this.currentNode!.recordId,
                  data: this.currentNode!.toJson())),
        ]);

        VwNodeRequestResponse nodeRequestRespose =
            await RemoteApi.nodeRequestApiCall(
                apiCallId: "syncNode",
                apiCallParam: apiCallParam,
                loginSessionId: this.getLoginSessionId());

        if (nodeRequestRespose.httpResponse != null &&
            nodeRequestRespose.httpResponse!.statusCode == 200) {
          if (nodeRequestRespose.apiCallResponse != null) {
            if (nodeRequestRespose
                    .apiCallResponse!.valueResponseClassEncodedJson !=
                null) {
              RemoteApi.decompressClassEncodedJson(nodeRequestRespose
                  .apiCallResponse!.valueResponseClassEncodedJson!);

              VwNodeUpsyncResultPackage nodeUpsyncResultPackage =
                  VwNodeUpsyncResultPackage.fromJson(nodeRequestRespose
                      .apiCallResponse!.valueResponseClassEncodedJson!.data!);

              if (nodeUpsyncResultPackage.nodeUpsyncResultList.length > 0) {
                lastNodeUpsyncResult =
                    nodeUpsyncResultPackage.nodeUpsyncResultList.elementAt(0);
                if (lastNodeUpsyncResult!.syncResult.createdCount == 1 ||
                    lastNodeUpsyncResult!.syncResult.updatedCount == 1) {
                  this.pageState = VwNodeSubmitPage.nspSuccessSyncingNode;
                  if (widget.refreshDataOnParentFunction != null) {
                    widget.refreshDataOnParentFunction!();
                  }
                } else {
                  if (this.currentNode!.nodeType == VwNode.ntnRowData &&
                      lastNodeUpsyncResult!.formValidationResponse != null &&
                      lastNodeUpsyncResult!
                              .formValidationResponse!.isFormResponseValid ==
                          false) {
                    this.pageState =
                        VwNodeSubmitPage.nspErrorSyncingNodeInvalidFormResponse;
                  } else {
                    this.pageState = VwNodeSubmitPage.nspErrorSyncingNode;
                  }
                }
              } else {
                this.pageState = VwNodeSubmitPage.nspErrorSyncingNode;
              }
            }
          } else {
            this.pageState = VwNodeSubmitPage.nspErrorSyncingNode;
          }
        }
      } else {
        if (syncTokenBlock != null && syncTokenBlock.isServerResponded) {
          this.pageState = VwNodeSubmitPage.nspErrorSyncingNodeAuthError;
        } else {
          this.pageState = VwNodeSubmitPage.nspErrorSyncingNodeHttpError;
        }
      }

      if (this.widget.nodeSubmitPageStateChanged != null) {
        this.widget.nodeSubmitPageStateChanged!(pageState: this.pageState);
      }
      this._refreshController.sink.add(this.pageState);

      setState(() {});
    } catch (error) {}
  }

  Future<void> _asyncLoadParentNodeFromServer() async {
    try {
      VwRowData apiCallParam = VwRowData(recordId: Uuid().v4(), fields: [
        VwFieldValue(
            fieldName: "nodeId", valueString: this.widget.parentNodeId),
      ]);

      VwNodeRequestResponse returnValue = await RemoteApi.nodeRequestApiCall(
          apiCallId: "getNodes",
          apiCallParam: apiCallParam,
          loginSessionId: this.getLoginSessionId());

      if (returnValue.renderedNodePackage != null &&
          returnValue.renderedNodePackage!.rootNode != null) {
        this.parentNode = returnValue.renderedNodePackage!.rootNode;

        this.currentNode!.defaultFormDefinitionList =
            this.getDefaultFormDefinitionList();
        this.pageState = VwNodeSubmitPage.nspInitDataLoaded;

        this._refreshController.sink.add(this.pageState);
      } else {
        this.pageState = VwNodeSubmitPage.nspErrorLoadingInitData;
        this._refreshController.sink.add(this.pageState);
      }
    } catch (error) {
      this.pageState = VwNodeSubmitPage.nspErrorLoadingInitData;
      this._refreshController.sink.add(this.pageState);
    }
  }

  Widget _buildLoadingWidget(String caption) {
    return WidgetUtil.loadingWidget(caption);
  }

  Widget _reloadForm(String caption) {
    Widget body = InkWell(
        onTap: () async {
          this.pageState = VwNodeSubmitPage.nspLoadingInitData;
          this._refreshController.sink.add(VwNodeSubmitPage.nspLoadingInitData);
          await this._asyncLoadData();
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

  Widget _submitSuccessForm(String caption) {
    Widget body = InkWell(
        onTap: () async {
          this.pageState = VwNodeSubmitPage.nspLoadingInitData;
          this._refreshController.sink.add(VwNodeSubmitPage.nspLoadingInitData);
          await this._asyncLoadData();
        },
        child: Container(
            //color: Colors.,
            child: Icon(Icons.check_circle_outline_outlined,
                color: Colors.green, size: 60)));

    Widget contentBody = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        body,
        Container(margin: EdgeInsets.all(10), child: Text(caption)),
        TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            label: Text("Close"))
      ],
    );

    return Scaffold(
      body: Stack(
        children: [Center(child: contentBody)],
      ),
    );
  }

  Widget _reloadFormWithScaffold(String caption) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(child: this._reloadForm(caption)));
  }

  bool isShowErrorMessage() {
    bool returnValue = false;
    if (this.pageState != VwNodeSubmitPage.nspInitDataLoaded) {
      returnValue = true;
    }

    return returnValue;
  }

  Widget showErrorMessageWidget() {
    try {
      if (isShowErrorMessage()) {
        String description = this.lastNodeUpsyncResult != null &&
                this.lastNodeUpsyncResult!.syncResult != null
            ? this.lastNodeUpsyncResult!.syncResult!.errorMessage.toString()
            : "<none>";

        return Container(
          constraints: BoxConstraints(maxWidth: 600),
          color: Colors.red,
          child: Text(
            "Error : " + this.pageState + ". Description: " + description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        );
      } else {
        return Container();
      }
    } catch (eror) {}
    return Container();
  }

  Icon getNodeTypeIcon() {
    Icon returnValue = Icon(Icons.list_alt);

    if (this.currentNode!.nodeType == VwNode.ntnFolder) {
      returnValue = Icon(
        Icons.folder,
        color: Colors.blueGrey,
      );
    } else if (this.currentNode!.nodeType == VwNode.ntnClassEncodedJson) {
      returnValue = Icon(Icons.data_object);
    }

    return returnValue;
  }

  void initiationDefaultFormDefinition() {
    List<VwNode> defaultFormDefinitionNodeList = [];
    try {
      if (widget.node!.nodeType == VwNode.ntnRowData) {
        if (widget.node!.content.rowData != null) {
          if (widget.node!.content.rowData!.formDefinitionLinkNode != null) {
            VwNode? currentDefaultFormDefinitionNode =
                NodeUtil.extractNodeFromLinkNode(
                    widget.node!.content.rowData!.formDefinitionLinkNode!);

            if (currentDefaultFormDefinitionNode != null) {
              VwFormDefinition? currentDefaultFormDefinition =
                  NodeUtil.extractFormDefinitionFromNode(
                      currentDefaultFormDefinitionNode);

              if (currentDefaultFormDefinition != null) {
                this.selectedFormDefinitionNode =
                    currentDefaultFormDefinitionNode;
              }
            }
          }
        } else if (this.selectedFormDefinitionNode == null) {
          if (widget.node!.defaultFormDefinitionList != null) {
            defaultFormDefinitionNodeList =
                widget.node!.defaultFormDefinitionList!;
          }

          if (defaultFormDefinitionNodeList.length == 1) {
            selectedFormDefinitionNode =
                defaultFormDefinitionNodeList!.elementAt(0);
          }
        }
      }
      else if(widget.node!.nodeType == VwNode.ntnFileStorage)
        {

        }
    } catch (error) {
      print("Error catched on void initiationDefaultFormDefinition() :"+error.toString());
    }
  }

  void extractSelectedFormDefinitionNodeFormParentNode() {
    try {
      if (this.widget.node == null) {
        if (this.parentNode!.nodeType == VwNode.ntnRowData &&
            this.parentNode!.content.rowData!.formDefinitionLinkNode != null) {
          VwNode? parentFormDefinitionNode = NodeUtil.extractNodeFromLinkNode(
              this.parentNode!.content.rowData!.formDefinitionLinkNode!);

          if (parentFormDefinitionNode != null) {
            VwFormDefinition? parentFormDefinition =
                NodeUtil.extractFormDefinitionFromNode(
                    parentFormDefinitionNode);

            if (parentFormDefinition != null) {
              if (parentFormDefinition!.isAllowChildNodeContentRowData &&
                  parentFormDefinition.childNodeFormDefinitionList != null
                  ) {
                if(parentFormDefinition.childNodeFormDefinitionList.length ==
                    1)
                  {
                    this.selectedFormDefinitionNode = parentFormDefinition
                        .childNodeFormDefinitionList
                        .elementAt(0);
                  }
                else if(this.widget.formDefinitionIdList!=null && this.widget.formDefinitionIdList!.length==1)
                  {
                    for(int la=0;la<parentFormDefinition.childNodeFormDefinitionList.length;la++)
                    {
                      if(parentFormDefinition.childNodeFormDefinitionList.elementAt(la).recordId==this.widget.formDefinitionIdList!.elementAt(0))
                      {
                        this.selectedFormDefinitionNode=parentFormDefinition.childNodeFormDefinitionList.elementAt(la);
                        break;
                      }
                    }
                  }

              }
            }
          }
        }
        else if(this.parentNode!.nodeType == VwNode.ntnFolder && this.parentNode!.defaultFormDefinitionList!=null )
          {
            if(this.parentNode!.defaultFormDefinitionList!.length==1) {
              this.selectedFormDefinitionNode =
                  this.parentNode!.defaultFormDefinitionList!.elementAtOrNull(
                      0);
            }
            else if(this.parentNode!.defaultFormDefinitionList!.length>0 && this.widget.formDefinitionIdList!=null && this.widget.formDefinitionIdList!.length==1 )
              {
                for(int la=0;la<this.parentNode!.defaultFormDefinitionList!.length;la++)
                  {
                    if(this.parentNode!.defaultFormDefinitionList!.elementAt(la).recordId==this.widget.formDefinitionIdList!.elementAt(0))
                      {
                        this.selectedFormDefinitionNode=this.parentNode!.defaultFormDefinitionList!.elementAt(la);
                        break;
                      }
                  }
              }
          }
      } else {}
    } catch (error) {}
  }

  Widget nodeEditorWidget(BuildContext innerContext) {
    try {
      VwFormValidationResponse? formValidationResponse =
          this.lastNodeUpsyncResult == null
              ? null
              : this.lastNodeUpsyncResult!.formValidationResponse;

      Widget deleteNodeButton = InkWell(
        onLongPress: () async {
          String modalResult = "CANCEL";

          await Alert(
            context: context,
            type: AlertType.warning,
            title: "Delete Record Confirmation",
            desc: "Are you sure want to delete this Record?",
            buttons: [
              DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  modalResult = "OK";
                  Navigator.of(context, rootNavigator: true).pop();
                },
                color: Colors.red,
              ),
              DialogButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  modalResult = "CANCEL";
                  Navigator.of(context, rootNavigator: true).pop();
                },
                color: Colors.green,
              )
            ],
          ).show();

          if (modalResult == "OK") {
            this.pageState = VwNodeSubmitPage.nspSyncingNode;
            this._refreshController.sink.add(this.pageState);
            await this._syncNodeToServer(crudMode: VwBaseModel.cmDelete);
          }
        },
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      );

      Widget editNodeButton = InkWell(
        onLongPress: () async {
          VwRowData? currentNodeRowData =
              VwRowData(recordId: this.currentNode!.recordId);

          NodeUtil.nodeToRowData(
              nodeSource: this.currentNode!,
              rowDataDestination: currentNodeRowData);

          await Navigator.push(
              context,
              MaterialTransparentRoute(
                  builder: (context) => VwFormEditorPage(
                      showBackArrow: true,
                      formResponse: currentNodeRowData,
                      formDefinitionNode:
                          this.parentNode!.nodeEditorFormDefinitionNode!,
                      appInstanceParam: widget.appInstanceParam)));

          NodeUtil.updateNodeFromRowData(
              nodeDestination: this.currentNode!,
              rowDataSource: currentNodeRowData);
        },
        child: this.getNodeTypeIcon(),
      );

      Widget floatingSUbmitButton = FloatingActionButton(
        onPressed: () async {
          this.pageState = VwNodeSubmitPage.nspSyncingNode;
          this._refreshController.sink.add(this.pageState);
          await this._syncNodeToServer();
        },
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ],
        ),
      );

      Widget submitButton = TextButton.icon(
          onPressed: () async {

            if(this.currentNode!=null && this.currentNode!.nodeType==VwNode.ntnClassEncodedJson && this.currentNode!.content.classEncodedJson!=null)
              {
                try {
                  if (this.currentNode!.content.classEncodedJson!
                      .collectionName!.toLowerCase() == "vwuser") {
                    RemoteApi.decompressClassEncodedJson(
                        this.currentNode!.content.classEncodedJson!);

                    VwUser userCurrentRecord = VwUser.fromJson(
                        this.currentNode!.content.classEncodedJson!.data!);

                    userCurrentRecord.syncFromRowData(this.currentNode!.content.rowData!);
                    this.currentNode!.content.classEncodedJson!.data=userCurrentRecord.toJson();


                  }
                }
                catch(error)
            {

            }

              }

            this.pageState = VwNodeSubmitPage.nspSyncingNode;
            this._refreshController.sink.add(this.pageState);
            await this._syncNodeToServer();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.hovered)) {
                return Colors.lightBlueAccent;
              }
              return Colors.blue;
            }),
          ),
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          label: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ));

      String formName = "";

      if (this.selectedFormDefinitionNode != null) {
        try {
          VwFormDefinition? formDefinition =
              NodeUtil.extractFormDefinitionFromNode(
                  this.selectedFormDefinitionNode!);

          formName = formDefinition!.formName!;
        } catch (error) {}
      }
      else
        {
          if(this.currentNode!=null)
            {
              if(this.currentNode!.nodeType==VwNode.ntnFileStorage)
                {
                  try {
                    formName = this.currentNode!.content.fileStorage!.clientEncodedFile!.fileInfo.fileName;
                  }
                  catch(error)
    {

    }
                }
            }
        }

      PreferredSizeWidget appBar = PreferredSize(
          preferredSize: isShowErrorMessage() == true
              ? Size.fromHeight(80)
              : Size.fromHeight(60),
          child: Column(
            children: [
              this.showErrorMessageWidget(),
              AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: true,
                actions: [
                  deleteNodeButton,
                  SizedBox(
                    width: 5,
                  )
                ],
                title: Row(
                  children: [
                    editNodeButton,
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      formName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    ))
                    /*Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          this.currentNode!.recordId,
                          style: TextStyle(fontSize: 15),
                        ))*/
                  ],
                ),
                // actions: [submitButton],
              )
            ],
          ));

      return Scaffold(
        key: Key(this.currentNode == null
            ? this.widget.parentNodeId
            : this.currentNode!.recordId),
        appBar: appBar,
        floatingActionButton: submitButton,
        body: VwNodeEditorPage(
            //backgroundColour: Colors.green,
            presetValues: widget.presetValues,
            selectedFormDefinitionNode: this.selectedFormDefinitionNode,
            onNodeSelectedNodeFormDefinitionChanged:
                implementOnSelectedFormDefinitionNodeChanged,
            hideNodeEditor: true,
            node: this.currentNode!,
            formValidationResponse: formValidationResponse,
            nodeEditorFormDefinitionNode:
                parentNode!.nodeEditorFormDefinitionNode!,
            appInstanceParam: widget.appInstanceParam),
      );
    } catch (error) {}
    return Container();
  }



  @override
  Widget build(BuildContext context) {
    // load parent Node Id
    // load form definition

    return StreamBuilder(
        key: this.widget.key,
        stream: _refreshController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget returnValue = Container();
          if (this.pageState == VwNodeSubmitPage.nspLoadingInitData) {
            returnValue = this._buildLoadingWidget("Loading...");
          } else if (this.pageState == VwNodeSubmitPage.nspSyncingNode) {
            returnValue = this._buildLoadingWidget("Syncing Node...");
          } else if (this.pageState ==
                  VwNodeSubmitPage.nspErrorSyncingNodeInvalidFormResponse ||
              this.pageState == VwNodeSubmitPage.nspInitDataLoaded ||
              this.pageState == VwNodeSubmitPage.nspErrorSyncingNode ||
              this.pageState == VwNodeSubmitPage.nspErrorSyncingNodeHttpError ||
              this.pageState == VwNodeSubmitPage.nspErrorDataNotValid ||
              this.pageState == VwNodeSubmitPage.nspErrorSyncingNodeAuthError) {
            //VwFormDefinition? selectedFormDefinition;
            VwNode? selectedFormDefinitionNode;



                if (this.parentNode != null &&
                    parentNode!.nodeEditorFormDefinitionNode != null) {
                  this.initiationDefaultFormDefinition();
                  this.extractSelectedFormDefinitionNodeFormParentNode();
                  return this.nodeEditorWidget(context);
                } else {
                  this.pageState = VwNodeSubmitPage.nspErrorDataNotValid;

                  this._refreshController.sink.add(this.pageState);
                  returnValue = this._reloadFormWithScaffold(
                      "Error: Data Not Valid. Please contact the Administrator");
                }



          } else if (this.pageState == VwNodeSubmitPage.nspSuccessSyncingNode) {
            returnValue =
                this._submitSuccessForm("Successfully Sync To Server");
          } else {
            returnValue = this._reloadFormWithScaffold(
                "Error: Not Connected To Server. Click to Reload Page");
          }

          return returnValue;
        });
  }
}
