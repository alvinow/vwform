import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'dart:convert';

import 'package:vwform/modules/vwwidget/vwselectnoderecordpage/vwselectnoderecordpagerowviewer.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

typedef NodeRecordSelected = void Function(VwLinkNode linkNode);

typedef SelectedNodeChanged = void Function(VwLinkNode? linkNode);

class VwSelectNodeRecordPage extends StatelessWidget {
  VwSelectNodeRecordPage(
      {required this.field,
      this.isMultiSelect = false,
      required this.appInstanceParam,
      required this.formField,
      required this.refreshDataOnParentFunction,
      this.candidateRecords,
      this.onChanged,
        this.getNodeContextId,
        this.contextNodeFilter,
        this.parentFormResponse

      });

  final VwFieldValue field;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final bool isMultiSelect;
  final VwAppInstanceParam appInstanceParam;
  final VwFormField formField;
  final List<VwLinkNode>? candidateRecords;
  final SelectedNodeChanged? onChanged;
  final String? getNodeContextId;
  final Map<String, dynamic>? contextNodeFilter;
  final VwRowData? parentFormResponse;

  void modifyParamFunction(VwRowData apiCallParam) {}

  Widget nodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    Widget clearSelectionWidget = TextButton.icon(
        onPressed: () {
          field.valueLinkNode = null;
          if (this.refreshDataOnParentFunction != null) {
            this.refreshDataOnParentFunction!();
          }
          Navigator.pop(context);
          if(this.onChanged!=null){
            this.onChanged!(null);
          }
        },
        icon: Icon(Icons.clear, color: Colors.black),
        label: Text("(Clear selection)",
            style: TextStyle(fontSize: 16, color: Colors.black)));

    return VwSelectNodeRecordPageRowViewer(
        topRowWidget: clearSelectionWidget,
        formField: this.formField,
        nodeRecordSelected: this.implementNodeRecordSelected,
        appInstanceParam: this.appInstanceParam,
        rowNode: renderedNode,
        highlightedText: highlightedText,
        refreshDataOnParentFunction: this.refreshDataOnParentFunction);
  }



  void implementNodeRecordSelected(VwLinkNode linkNode) {
    this.field.valueLinkNode = linkNode;
    if (this.refreshDataOnParentFunction != null) {
      this.refreshDataOnParentFunction!();
    }
    if(this.onChanged!=null){
      this.onChanged!(this.field.valueLinkNode );
    }
  }

  VwRowData apiCallParam() {
    final String nodeId = this
        .formField
        .fieldUiParam
        .collectionListViewDefinition!
        .dataSource
        .folderNodeId
        .toString();
    //final String? collectionName=this.formField.fieldDefinition.fieldConstraint.collectionName;

    VwRowData apiCallParam = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(fieldName: "nodeId", valueString: nodeId),
          VwFieldValue(
              fieldName: "depth",
              valueTypeId: VwFieldValue.vatNumber,
              valueNumber: 1),
          VwFieldValue(
              fieldName: "sortObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {"displayName": 1}),
          VwFieldValue(
              fieldName: "disableUserGroupPOV",
              valueTypeId: VwFieldValue.vatBoolean,
              valueBoolean: true),
        ]);

    if(this.formField.fieldUiParam.collectionListViewDefinition!=null)
      {
        if(this.formField.fieldUiParam.collectionListViewDefinition!.dataSource.folderUpNodeRowDataSearchParameter!=null &&  this.formField.fieldUiParam.collectionListViewDefinition!.dataSource.folderNodeMode==VwDataSourceDefinition.folderUpNodeRowDataSearch)
          {
           VwFieldValue isSearchUpNodeRowDataFieldValue=  VwFieldValue(fieldName: "isSearchUpNodeRowData",valueTypeId: VwFieldValue.vatBoolean,valueBoolean: true);
           VwFieldValue searchUpNodeRowDataTargetCollectionNameFieldValue=  VwFieldValue(fieldName: "searchUpNodeRowDataTargetCollectionName",valueTypeId: VwFieldValue.vatString,valueString: this.formField.fieldUiParam.collectionListViewDefinition!.dataSource.folderUpNodeRowDataSearchParameter!.targetCollectionName);

           apiCallParam.fields!.add(isSearchUpNodeRowDataFieldValue);
           apiCallParam.fields!.add(searchUpNodeRowDataTargetCollectionNameFieldValue);

           VwFieldValue? nodeIdFieldValue= apiCallParam.getFieldByName("nodeId");

           if(nodeIdFieldValue!=null && this.parentFormResponse!=null)
             {
               nodeIdFieldValue!.valueString=parentFormResponse!.parentNodeId;
             }



          }
      }

    if(this.getNodeContextId!=null)
      {
      VwFieldValue getNodeContextIdFieldValue=  VwFieldValue(fieldName: "getNodeContextId", valueString: this.getNodeContextId);
      apiCallParam.fields!.add(getNodeContextIdFieldValue);
      }

    if(this.contextNodeFilter!=null)
      {
        VwFieldValue contextNodeFilterFieldValue=VwFieldValue(fieldName: "contextNodeFilter", valueTypeId: VwFieldValue.vatObject, value: this.contextNodeFilter);
        apiCallParam.fields!.add(contextNodeFilterFieldValue);
      }

    if (this.formField.fieldUiParam.collectionListViewDefinition != null &&
        this.formField.fieldUiParam.collectionListViewDefinition!.dataSource !=
            null &&
        this
                .formField
                .fieldUiParam
                .collectionListViewDefinition!
                .dataSource
                .collectionNameList !=
            null &&
        this
                .formField
                .fieldUiParam
                .collectionListViewDefinition!
                .dataSource
                .collectionNameList!
                .length >
            0) {
      Map<String, dynamic> collectionNameListFilter = {
        "\$in": this
            .formField
            .fieldUiParam
            .collectionListViewDefinition!
            .dataSource
            .collectionNameList
      };

      dynamic filterObject;

      if (this
                  .formField
                  .fieldUiParam
                  .collectionListViewDefinition!
                  .dataSource
                  .nodeFilter !=
              null &&
          this
                  .formField
                  .fieldUiParam
                  .collectionListViewDefinition!
                  .dataSource
                  .nodeFilter!
                  .filter !=
              null) {
        filterObject = this
            .formField
            .fieldUiParam
            .collectionListViewDefinition!
            .dataSource
            .nodeFilter!
            .filter;

        filterObject["content.contentContext.collectionName"] =
            collectionNameListFilter;
      } else {
        filterObject = {
          "content.contentContext.collectionName": collectionNameListFilter
        };
      }

      print("filterObject= " + json.encode(filterObject));

      apiCallParam.fields!.add(
        VwFieldValue(
            fieldName: "depth1FilterObject",
            valueTypeId: VwFieldValue.vatObject,
            value: filterObject),
      );
      //apiCallParam.fields!.add(VwFieldValue(fieldName: "depth1FilterObject",valueTypeId: VwFieldValue.vatObject,value: {"content.contentContext.collectionName":collectionName}));
    }

    return apiCallParam;
  }

  @override
  Widget build(BuildContext context) {
    String nodeFetchMode = this.formField.fieldUiParam.uiTypeId ==
            VwFieldUiParam.uitDropdownLinkNodeByLocalFieldSource || (this.candidateRecords!=null && this.candidateRecords!.length>0)
        ? NodeListView.nfmParent
        : NodeListView.nfmServer;

    return NodeListView(
      mainLogoImageAsset: this.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
      appInstanceParam: this.appInstanceParam,
      apiCallId: "getNodes",
      mainLogoMode: NodeListView.mlmText,
      mainLogoTextCaption: "(Select)",
      showBackArrow: true,
      nodeFetchMode: nodeFetchMode,
      fieldValue: VwFieldValue(
          fieldName: "<invalidFieldNameValue>",
          valueTypeId: VwFieldValue.vatValueLinkNodeList,
          valueLinkNodeList: this.candidateRecords),
      nodeRowViewerFunction: nodeRowViewer,
      apiCallParam: this.apiCallParam(),

      //showSearchIcon: true,
      pageMode: NodeListView.pmSearch,

      topRowWidget: Text("Select"),
    );
  }
}
