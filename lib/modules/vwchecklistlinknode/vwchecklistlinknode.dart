import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwchecklistlinknode/vwchecklistlinknoderowviewer/vwchecklistlinknoderowviewer.dart';
import 'package:vwform/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfieldlocalfieldref/vwfieldlocalfieldref.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

typedef UpdateSelectedState = void Function(bool selected, VwNode node);
typedef GetFloatingActionBubbleFunction = Widget Function(
    BuildContext context, VwLoginResponse loginResponse, Bloc parentBloc);

class VwCheckListLinkNode extends StatefulWidget {
  VwCheckListLinkNode(
      {super.key,
      required this.fieldValue,
      required this.formField,
      this.parentRef,
      required this.appInstanceParam,

      // required this.collectionListViewDefinition,
      required this.fieldUiParam,
      this.refreshDataOnParentFunction,
      this.drawer,
      this.nodeRowViewerFunction,
      this.syncLinkNodeListToParentFunction,
      this.isReadOnly = false,
      required this.getFieldvalueCurrentResponseFunction,
      this.getCurrentFormDefinitionFunction,
      required this.baseUrl
      });

  final VwLinkNode? parentRef;
  final VwAppInstanceParam appInstanceParam;
  //final VwCollectionListViewDefinition collectionListViewDefinition;
  final VwFieldUiParam fieldUiParam;
  final VwFormField formField;
  final RefreshDataOnParentFunction ? refreshDataOnParentFunction;
  final BuildWidgetWithContextFunction ? drawer;
  final NodeRowViewerFunction? nodeRowViewerFunction;
  final SyncLinkNodeListToParentFunction? syncLinkNodeListToParentFunction;
  final VwFieldValue fieldValue;
  final bool isReadOnly;
  final GetCurrentFormResponseFunction getFieldvalueCurrentResponseFunction;
  final GetCurrentFormDefinitionFunction? getCurrentFormDefinitionFunction;
  final String baseUrl;

  VwCheckListLinkNodeState createState() => VwCheckListLinkNodeState();
}

class VwCheckListLinkNodeState extends State<VwCheckListLinkNode> {
  late Key stateKey;

  RefreshDataOnParentFunction? refreshDataOnParentFunction;

  void implementRefreshDataOnParentFunction() {
    print("refresh data from isi form");
    setState(() {
      this.stateKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    this.stateKey = Key(Uuid().v4());
  }

  void refreshState() {
    this.stateKey = Key(Uuid().v4());
    setState(() {});
  }

  void implementUpdateSelectedState(bool selected, VwNode node) {
    if (selected == true) {
      String nodeEncoded = json.encode(node.toJson());
      VwNode nodeRecoded = VwNode.fromJson(json.decode(nodeEncoded));
      try {
        // nodeRecoded.content.linkRowCollection!.rendered = null;

        if (nodeRecoded.content.linkRowCollection!.rendered != null) {
          nodeRecoded.content.linkRowCollection!.cache =
              nodeRecoded.content.linkRowCollection!.rendered;
          nodeRecoded.content.linkRowCollection!.rendered = null;
        }
      } catch (error) {}
      NodeUtil.injectNodeToLinkNodeList(
          nodeRecoded, widget.fieldValue.valueLinkNodeList!);
    } else {
      NodeUtil.removeNodeFromLinkNodeList(
          node.recordId, widget.fieldValue.valueLinkNodeList!);
    }

    this.refreshState();
  }

  List<String> createExcludedNodeList() {
    List<String> returnValue = [];

    for (int la = 0; la < widget.fieldValue.valueLinkNodeList!.length; la++) {
      try {
        final currentNodeId = widget.fieldValue.valueLinkNodeList!.elementAt(la).nodeId;

        returnValue.add(currentNodeId);
      } catch (error) {}
    }

    return returnValue;
  }

  void modifyParamFunction(VwRowData apiCallParam) {}



  Widget? createTopRowWidget() {
    Widget? returnValue;

    if (this.widget.fieldValue.valueLinkNodeList != null) {
      List<Widget> nodeWidgetList = [];
      for (int la = 0;
          la < this.widget.fieldValue.valueLinkNodeList!.length;
          la++) {
        VwLinkNode currentLinkNode =
            this.widget.fieldValue.valueLinkNodeList!.elementAt(la);

        VwNode? currentNode = NodeUtil.extractNodeFromLinkNode(currentLinkNode);

        if (currentNode != null) {
          Widget currentLinkNodeWidget = VwCheckListLinkNodeRowViewer(
            key: Key(currentNode.recordId),
            rowNode: currentNode,
            selectedList: this.widget.fieldValue.valueLinkNodeList,
            appInstanceParam: widget.appInstanceParam,
            updateSelectedState: this.implementUpdateSelectedState,
            collectionListViewDefinition:
                this.widget.fieldUiParam.collectionListViewDefinition,
          );
          nodeWidgetList.add(currentLinkNodeWidget);
          nodeWidgetList.add(Divider());
        }
      }
      if (nodeWidgetList.length > 0) {
        returnValue = Column(children: nodeWidgetList);
      }
    }
    return returnValue;
  }

  Widget implementNodeRowViewerChooseRecord(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
    this.refreshDataOnParentFunction = refreshDataOnParentFunction;

    /*
    if (this.widget.fieldValue.valueLinkNodeList != null &&
        NodeUtil.isLinkNodeExistOnField(
                field: this.widget.fieldValue.valueLinkNodeList!,
                checking: renderedNode) ==
            true) {
      return Container();
    }*/

    return VwCheckListLinkNodeRowViewer(
      topRowWidget: topRowWidget,
      isReadOnly: this.widget.isReadOnly,
      key: Key(renderedNode.recordId),
      selectedList: this.widget.fieldValue.valueLinkNodeList,
      updateSelectedState: this.implementUpdateSelectedState,
      appInstanceParam: widget.appInstanceParam,
      rowNode: renderedNode,
      highlightedText: highlightedText,
      refreshDataOnParentFunction: refreshDataOnParentFunction,
      collectionListViewDefinition:
          widget.fieldUiParam.collectionListViewDefinition,
    );
  }

  Widget implementNodeRowViewerSelectedRecord(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
    this.refreshDataOnParentFunction = refreshDataOnParentFunction;

    return VwCheckListLinkNodeRowViewer(
      isReadOnly: this.widget.isReadOnly,
      unselectedConfirmation: true,
      selectedIcon: Icon(Icons.delete, color: Colors.grey),
      key: Key(renderedNode.recordId),
      selectedList: this.widget.fieldValue.valueLinkNodeList,
      updateSelectedState: this.implementUpdateSelectedState,
      appInstanceParam: widget.appInstanceParam,
      rowNode: renderedNode,
      highlightedText: highlightedText,
      refreshDataOnParentFunction: refreshState,
      collectionListViewDefinition:
          widget.fieldUiParam.collectionListViewDefinition,
    );
  }

  Widget? newRowDataFormPage(SyncNodeToParentFunction ? syncNodeToParentFunction,
      RefreshDataOnParentFunction? refreshDataOnParentFunction) {
    Widget? returnValue;

    VwFormDefinition? currentFormDefinition;

    if (widget.fieldUiParam.collectionListViewDefinition!
            .detailFormDefinitionMode ==
        VwFieldUiParam.dfmLocal) {
      currentFormDefinition = widget
          .fieldUiParam.collectionListViewDefinition!.detailFormDefinition;
    } else if (widget.fieldUiParam.collectionListViewDefinition!
                .detailFormDefinitionMode ==
            VwFieldUiParam.dfmLinkFormDefinition &&
        widget.fieldUiParam.collectionListViewDefinition!
                .detailLinkFormDefinition !=
            null) {
      try {
        currentFormDefinition = VwFormDefinition.fromJson(widget
            .fieldUiParam
            .collectionListViewDefinition!
            .detailLinkFormDefinition!
            .rendered!
            .node!
            .content!
            .classEncodedJson!
            .data!);
      } catch (error) {}
    }

    if (currentFormDefinition != null) {
      VwRowData blankFormResponse =
          VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
              formDefinition: currentFormDefinition,
              ownerUserId: widget
                  .appInstanceParam.loginResponse!.userInfo!.user.recordId);

      if (widget.parentRef != null) {
        blankFormResponse.ref = widget.parentRef;
      }
      //currentFormDefinition.dataSource=widget.collectionListViewDefinition.dataSource.syncMode;
      currentFormDefinition.dataSource = VwDataSourceDefinition.smServer;

      returnValue = VwFormPage(
          appInstanceParam: widget.appInstanceParam,
          syncNodeToParentFunction: syncNodeToParentFunction,
          refreshDataOnParentFunction: refreshDataOnParentFunction,
          formResponse: blankFormResponse,
          formDefinition: currentFormDefinition,
          formDefinitionFolderNodeId: AppConfig.formDefinitionFolderNodeId);
    }

    return returnValue;
  }

  Widget _getFloatingActiobButtonChooseRecord(
      {required BuildContext context,
      required VwAppInstanceParam appInstanceParam,
      SyncNodeToParentFunction? syncNodeToParentFunction,
      RefreshDataOnParentFunction? refreshDataOnParentFunction}) {
    return FloatingActionButton.small(
        backgroundColor: Colors.blue.withOpacity(0.5),
        key: UniqueKey(),
        heroTag: Uuid().v4(),
        child: const Icon(
          Icons.edit_outlined,
          size: 15,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => createSelectNodeListView(context,widget.baseUrl)),
          );
        });
  }

  Widget _getFloatingActionButtonNewRecord(
      {required BuildContext context,
      required VwAppInstanceParam appInstanceParam,
      SyncNodeToParentFunction? syncNodeToParentFunction,
      RefreshDataOnParentFunction? refreshDataOnParentFunction}) {


    return this
                .widget
                .fieldUiParam
                .collectionListViewDefinition!
                .enableCreateRecord ==
            false
        ? Container()
        : FloatingActionButton(
            backgroundColor: Colors.blue.withOpacity(0.5),
            key: UniqueKey(),
            heroTag: Uuid().v4(),
            child: const Icon(Icons.add),
            onPressed: () {
              Widget? currentFormPage = newRowDataFormPage(
                  syncNodeToParentFunction, refreshDataOnParentFunction);

              if (currentFormPage != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => currentFormPage),
                );
              } else {
                print(" formDefinition Doesn't exists");
              }
            });
  }

  VwRowData apiCallParamSelectRecord() {
    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: this
                  .widget
                  .fieldUiParam
                  .collectionListViewDefinition!
                  .dataSource
                  .folderNodeId),
          VwFieldValue(
              fieldName: "disableRenderFormDefinition",
              valueBoolean: this
                  .widget
                  .fieldUiParam
                  .collectionListViewDefinition!
                  .dataSource
                  .disableRenderFormDefinition),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "disableUserGroupPOV",
              valueTypeId: VwFieldValue.vatBoolean,
              valueBoolean: true),
          VwFieldValue(
              fieldName: "sortObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {"displayName": 1}),
        ]);

    Map<String, dynamic> collectionNameListFilter = {
      "\$in": widget.fieldUiParam.collectionListViewDefinition!.dataSource
          .collectionNameList
    };

    returnValue.fields!.add(
      VwFieldValue(
          fieldName: "depth1FilterObject",
          valueTypeId: VwFieldValue.vatObject,
          value: {
            "content.contentContext.collectionName": collectionNameListFilter
          }),
    );

    return returnValue;
  }

  VwRowData apiCallParamLastPrimseTicketEventResponseByTransaksiIndukId(
      {required String ticketId}) {
    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: "bf6ebf9f-06f1-46d7-a50b-c1fb6040f729"),
          VwFieldValue(fieldName: "ticketId", valueString: ticketId),
        ]);
    return returnValue;
  }

  VwRowData apiCallParamUiField() {
    try {
      VwFieldLocalFieldRef currentFieldLocalFieldRef = this
          .widget
          .fieldUiParam
          .collectionListViewDefinition!
          .dataSource
          .fieldLocalFieldRefList!
          .elementAt(0);

      String localFieldName =
          currentFieldLocalFieldRef.localFieldRef!.localFieldName;

      VwRowData currentFormResponse =
          this.widget.getFieldvalueCurrentResponseFunction();

      VwFormDefinition? currentFormDefinition;

      if (this.widget.getCurrentFormDefinitionFunction != null) {
        currentFormDefinition = this.widget.getCurrentFormDefinitionFunction!();
      }

      VwFieldValue? localFieldValue =
          currentFormResponse.getFieldByName(localFieldName);

      VwFieldValue? transaksiIndukFieldValue = this
          .widget
          .getFieldvalueCurrentResponseFunction()
          .getFieldByName("transaksiIndukId");

      String? currentCollectionName =
          this.widget.getFieldvalueCurrentResponseFunction().collectionName;

      if (this.widget.fieldValue.fieldName != null &&
          currentCollectionName != null &&
          ((currentFormDefinition != null &&
                  currentFormDefinition.formResponseSyncCollectionName ==
                      "transaksiinduksakti") ||
              currentCollectionName == "transaksiinduksakti") &&
          this.widget.fieldValue.fieldName == "berkasSpm" &&
          transaksiIndukFieldValue != null &&
          transaksiIndukFieldValue!.valueString != null) {
        return apiCallParamLastPrimseTicketEventResponseByTransaksiIndukId(
            ticketId: transaksiIndukFieldValue!.valueString!);
      } else {
        VwRowData returnValue = VwRowData(
            timestamp: VwDateUtil.nowTimestamp(),
            recordId: Uuid().v4(),
            fields: <VwFieldValue>[
              VwFieldValue(
                  fieldName: "nodeId",
                  valueString: this
                      .widget
                      .fieldUiParam
                      .collectionListViewDefinition!
                      .dataSource
                      .folderNodeId),
              VwFieldValue(
                  fieldName: "disableRenderFormDefinition",
                  valueBoolean: this
                      .widget
                      .fieldUiParam
                      .collectionListViewDefinition!
                      .dataSource
                      .disableRenderFormDefinition),
              VwFieldValue(fieldName: "depth", valueNumber: 1),
              VwFieldValue(
                  fieldName: "sortObject",
                  valueTypeId: VwFieldValue.vatObject,
                  value: this
                              .widget
                              .fieldUiParam
                              .collectionListViewDefinition!
                              .dataSource
                              .sortObject !=
                          null
                      ? this
                          .widget
                          .fieldUiParam
                          .collectionListViewDefinition!
                          .dataSource
                          .sortObject
                      : {"displayName": 1}),
            ]);

        if (this.widget.fieldUiParam.collectionListViewDefinition != null &&
            this
                    .widget
                    .fieldUiParam
                    .collectionListViewDefinition!
                    .dataSource
                    .fieldLocalFieldRefList !=
                null &&
            this
                    .widget
                    .fieldUiParam
                    .collectionListViewDefinition!
                    .dataSource
                    .fieldLocalFieldRefList!
                    .length >
                0) {
          if (localFieldValue != null) {
            if (localFieldValue.valueLinkNode != null &&
                localFieldValue.valueLinkNode!.contentContext != null &&
                localFieldValue.valueLinkNode!.contentContext!.collectionName !=
                    null) {
              String refRecordId = localFieldValue.valueLinkNode!.nodeId!;
              String refCollectionName = localFieldValue
                  .valueLinkNode!.contentContext!.collectionName!;

              List<String> refCollectionNameList = ["vwticket"];

              VwNode? refNode = NodeUtil.extractNodeFromLinkNode(
                  localFieldValue.valueLinkNode!);

              String recordId = refRecordId;
              if (refCollectionName == "vwticket") {
              } else if (refCollectionName == "transaksiinduksakti") {
                recordId =
                    this.widget.getFieldvalueCurrentResponseFunction().recordId;
              }

              Map<String, dynamic> filterObject = {
                "content.rowData.fields": {
                  r"$all": [
                    {
                      r"$elemMatch": {
                        "fieldName": "ticket",
                        "valueLinkNode.contentContext.collectionName": {
                          r"$in": refCollectionNameList
                        },
                        "valueLinkNode.contentContext.recordId": recordId
                      }
                    },
                  ]
                }
              };

              print(json.encode(filterObject));

              returnValue.fields!.add(VwFieldValue(
                  fieldName: "disableUserGroupPOV",
                  valueTypeId: VwFieldValue.vatBoolean,
                  valueBoolean: true));

              returnValue.fields!.add(VwFieldValue(
                  fieldName: "depth1FilterObject",
                  valueTypeId: VwFieldValue.vatObject,
                  value: filterObject));
            }
          }
        }

        /*if(widget.parentRef!=null  )
    {


      if(widget.collectionListViewDefinition.dataSource.collectionNameList!=null &&   widget.collectionListViewDefinition.dataSource.collectionNameList!.length>0) {
        Map<String,dynamic> collectionNameListFilter =  { "\$in" : widget.collectionListViewDefinition.dataSource.collectionNameList };

        String collectionNameListFilterString=json.encode(collectionNameListFilter);

        returnValue.fields!.add(VwFieldValue(
            fieldName: "depth1FilterObject",
            valueTypeId: VwFieldValue.vatObject,
            value: {
              "content.contentContext.recordRef.contentRecordId": widget
                  .parentRef!.contentRecordId,
              "content.contentContext.recordRef.collectionName": widget
                  .parentRef!.collectionName,
              "content.contentContext.collectionName": collectionNameListFilter
            }),);
      }
      else
        {
          returnValue.fields!.add(VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {
                "content.contentContext.recordRef.contentRecordId": widget
                    .parentRef!.contentRecordId,
                "content.contentContext.recordRef.collectionName": widget
                    .parentRef!.collectionName
              }),);

        }
    }*/
        else {
          if (widget.fieldUiParam.collectionListViewDefinition!.dataSource
                      .collectionNameList !=
                  null &&
              widget.fieldUiParam.collectionListViewDefinition!.dataSource
                      .collectionNameList!.length >
                  0) {
            Map<String, dynamic> collectionNameListFilter = {
              "\$in": widget.fieldUiParam.collectionListViewDefinition!
                  .dataSource.collectionNameList
            };

            returnValue.fields!.add(
              VwFieldValue(
                  fieldName: "depth1FilterObject",
                  valueTypeId: VwFieldValue.vatObject,
                  value: {
                    "content.contentContext.collectionName":
                        collectionNameListFilter
                  }),
            );
          } else {
            // filter nothing
          }
        }

        return returnValue;
      }
    } catch (error) {}

    return VwRowData(recordId: Uuid().v4());
  }

  Widget createSelectNodeListView(BuildContext context,String baseUrl) {
    Widget returnValue = Container();
    try {
      returnValue = NodeListView (
        baseUrl: baseUrl,
        excludedRow: this.createExcludedNodeList(),
        appInstanceParam: widget.appInstanceParam,
        topRowWidget: this.createTopRowWidget(),
        syncLinkNodeListToParentFunction:
            widget.syncLinkNodeListToParentFunction,

        key: this.stateKey,
        apiCallId: "getNodes",
        nodeFetchMode: NodeListView.nfmServer,
        showBackArrow: true,
        mainLogoTextCaption:
            this.widget.fieldUiParam.collectionListViewDefinition!.title,
        mainLogoMode: NodeListView.mlmText,

        //showSearchIcon:  this.widget.fieldUiParam.collectionListViewDefinition!.showSearchIcon,
        pageMode: NodeListView.pmSearch,
        showUserInfoIcon: this
            .widget
            .fieldUiParam
            .collectionListViewDefinition!
            .showUserInfoIcon,
        showNotificationIcon: this
            .widget
            .fieldUiParam
            .collectionListViewDefinition!
            .showNotificationIcon,
        nodeRowViewerFunction: widget.nodeRowViewerFunction != null
            ? widget.nodeRowViewerFunction!
            : this.implementNodeRowViewerChooseRecord,
        apiCallParam: this.apiCallParamSelectRecord(),

        getFloatingActionButton: this._getFloatingActionButtonNewRecord,
        drawer: widget.drawer,
        excludedNodeFetch: this.widget.fieldValue.valueLinkNodeList,
      );
    } catch (error) {}

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = NodeListView(
      baseUrl: widget.baseUrl,
      enableAppBar: false,
      showReloadButton: false,
        rowUpperPadding: 0,
        toolbarHeight: 30,
        toolbarPadding: 5,
        appInstanceParam: this.widget.appInstanceParam,
        fieldValue: this.widget.fieldValue,
        syncLinkNodeListToParentFunction:
            widget.syncLinkNodeListToParentFunction,
        key: this.stateKey,
        apiCallId: "getNodes",
        nodeFetchMode: this
                    .widget
                    .fieldUiParam
                    .collectionListViewDefinition!
                    .dataSource
                    .syncMode ==
                VwDataSourceDefinition.smServer
            ? NodeListView.nfmServer
            : NodeListView.nfmParent,
        showBackArrow: this
            .widget
            .fieldUiParam
            .collectionListViewDefinition!
            .showBackArrow,
        mainLogoMode: NodeListView.mlmText,
        mainLogoTextCaption:
            this.widget.fieldUiParam.collectionListViewDefinition!.title,
        //showSearchIcon:  this.widget.fieldUiParam.collectionListViewDefinition!.showSearchIcon,

        showUserInfoIcon: this
            .widget
            .fieldUiParam
            .collectionListViewDefinition!
            .showUserInfoIcon,
        showNotificationIcon: this
            .widget
            .fieldUiParam
            .collectionListViewDefinition!
            .showNotificationIcon,
        nodeRowViewerFunction: widget.nodeRowViewerFunction != null
            ? widget.nodeRowViewerFunction!
            : this.implementNodeRowViewerSelectedRecord,
        apiCallParam: this.apiCallParamUiField(),
        getFloatingActionButton: this.widget.isReadOnly == true
            ? null
            : _getFloatingActiobButtonChooseRecord,
        drawer: widget.drawer);
    return body;
  }
}
