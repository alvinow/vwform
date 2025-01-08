import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwwidget/vwbottomsheetnodeaction/vwbottomsheetnodemenu.dart';
import 'package:vwform/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/branchviewer/branchviewer.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/branchviewer/childbranch.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/vwnodesubmitpage.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class VwBrowseFolderRowViewer extends NodeRowViewer {
  VwBrowseFolderRowViewer(
      {super.key,
      required super.appInstanceParam,
      required super.rowNode,
      super.highlightedText,
      super.refreshDataOnParentFunction,
      super.refreshDataOnParentRecordFunction,
      super.rowViewerBoxContraints,
      super.commandToParentFunction,
      super.localeId});

  void implementRefreshOnAfterNodeUpdate() {
    if (this.refreshDataOnParentRecordFunction != null) {
      this.refreshDataOnParentRecordFunction!();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      VwCardParameter cardParameter = VwCardParameter(
        titleFieldName: "displayName",
        iconHexCode: "0xe2a3",
        iconHexColor: "ff385674",
        isShowSubtitle: false,
        isShowDate: false,
      );

      bool isEnableClassEncodedJsonSyncUseRowDataFormat =
          rowNode.nodeType == VwNode.ntnClassEncodedJson &&
              rowNode.content.rowData != null &&
              rowNode.content.classEncodedJson != null &&
              rowNode.content.classEncodedJson!.syncUseRowDataFormat != null &&
              rowNode.content.classEncodedJson!.syncUseRowDataFormat == true;

      if (rowNode.nodeType != VwNode.ntnFolder) {
        cardParameter = VwCardParameter(
          titleFieldName: "name",
          iconHexCode: "0xf434",
          iconHexColor: "ff6da9e4",
          isShowSubtitle: false,
          isShowDate: true,
        );

        if (rowNode.nodeType == VwNode.ntnRowData ||
            isEnableClassEncodedJsonSyncUseRowDataFormat == true) {
          VwFormDefinition? currentFormDefinition;

          if (rowNode.content.rowData!.formDefinitionLinkNode != null) {
            VwNode? currentFormDefinitionNode =
                NodeUtil.extractNodeFromLinkNode(
                    rowNode.content.rowData!.formDefinitionLinkNode!);

            currentFormDefinition = currentFormDefinitionNode != null &&
                    currentFormDefinitionNode!.content != null
                ? NodeUtil.extractFormDefinitionFromContent(
                    nodeContent: currentFormDefinitionNode!.content!)
                : null;
          }

          if (currentFormDefinition != null) {
            cardParameter = currentFormDefinition.cardParameter;
          }
        } else if (rowNode.nodeType == VwNode.ntnClassEncodedJson) {
          cardParameter = VwCardParameter(
            titleFieldName: "formName",
            iconHexCode: "0xf434",
            iconHexColor: "ff6da9e4",
            isShowSubtitle: false,
            isShowDate: true,
          );
        }
      }

      InkWell cardTapperNtnFolder = InkWell(
        onTap: () async {
          print("Open Folder: " + rowNode.recordId);

          Widget folderPage = VwFormResponseUserPage(
            currentNode: rowNode,
            appInstanceParam: this.appInstanceParam,
            mainLogoTextCaption: rowNode.displayName,
            folderNodeId: rowNode.recordId,
            isRootFolder: false,
          );

          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => folderPage),
          );
        },
      );

      InkWell cardTapperNtnRowData = InkWell(
        onTap: () async {
          Widget nodeSubmitPage = VwNodeSubmitPage(
              parentNodeId: this.rowNode.parentNodeId!,
              node: this.rowNode,
              appInstanceParam: this.appInstanceParam,
              refreshDataOnParentFunction:
                  this.implementRefreshOnAfterNodeUpdate);

          await Navigator.push(
              context, MaterialPageRoute(builder: (context) => nodeSubmitPage));
        },
      );

      InkWell cardTapperNtnClassEncodedJson = InkWell(
        onTap: () {
          print("Open ClassEncodedJson " + rowNode.recordId);
        },
      );

      InkWell cardTapper = InkWell(
        onLongPress: () {
          this.rowNode.isSelected = true;
        },
        onTap: () {
          print("Generic Tap node" + rowNode.recordId);
        },
      );

      if (rowNode.nodeType == VwNode.ntnRowData ||
          rowNode.nodeType == VwNode.ntnFileStorage ||
          isEnableClassEncodedJsonSyncUseRowDataFormat == true) {
        cardTapper = cardTapperNtnRowData;
      } else if (rowNode.nodeType == VwNode.ntnClassEncodedJson) {
        cardTapper = cardTapperNtnClassEncodedJson;
      } else if (rowNode.nodeType == VwNode.ntnFolder) {
        cardTapper = cardTapperNtnFolder;
      }

      Widget parentWidget = VwCardParameterNodeViewerMaterial(
          rowViewerBoxConstraint: this.rowViewerBoxContraints,
          appInstanceParam: this.appInstanceParam,
          cardParameter: cardParameter,
          rowNode: rowNode,
          cardTapper: cardTapper,
          commandToParentFunction: this.commandToParentFunction);

      Widget trailingWidget = InkWell(
        onTap: () {
          showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => Container(
                  color: Colors.transparent,
                  constraints: BoxConstraints(maxHeight: 500, maxWidth: 500),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Container(
                                padding: EdgeInsets.all(20),
                                color: Colors.white,
                                constraints: BoxConstraints(maxWidth: 500),
                                child: VwBottomSheetNodeMenu(
                                    refreshDataOnParentFunction:
                                        this.implementRefreshOnAfterNodeUpdate,
                                    appInstanceParam: appInstanceParam,
                                    currentNode: this.rowNode)))
                      ])));
        },
        child: Icon(Icons.more_vert_sharp),
      );

      if (rowNode.content.rowData != null &&
          rowNode.content.rowData!.collectionName == "lhpformdefinition") {
        String parentBranchRecordId = rowNode.content.rowData!.recordId;

        dynamic depth1FilterObject = {"parentNodeId": parentBranchRecordId};

        VwRowData presetValuesChildBranch1 =
            VwRowData(recordId: Uuid().v4(), fields: [
              new VwFieldValue(fieldName: "lhp",valueLinkNode: new VwLinkNode(nodeId: parentBranchRecordId, nodeType: VwNode.ntnRowData), valueTypeId: VwFieldValue.vatValueLinkNode)
            ]);

        CreateRecordButtonChildBranch createRecordButtonChildBranch1 =
            CreateRecordButtonChildBranch(
          icon: Icons.snippet_folder,
          title: "Folder",
          newRecordPresetValues: presetValuesChildBranch1,
          createRecordFormDefinitionId: "subfolderlhpformdefinition",
        );

        ChildBranch childBranch1 = ChildBranch(
          branchNodeId: parentBranchRecordId,
          createRecordButtonList: [createRecordButtonChildBranch1],
          showCreateButton: true,
          depth1FilterObject: depth1FilterObject,
        );

        return BranchViewer(
          key: Key(parentBranchRecordId),
          isRoot: true,
          refreshDataOnParentFunction: this.implementRefreshOnAfterNodeUpdate,
          //key: Key(parentBranchRecordId),
          commandToParentFunction: this.commandToParentFunction,
          localeId: this.localeId,
          summaryId: "temuanlhp",
          parentNode: this.rowNode,
          childrenBranch: [childBranch1],
          appInstanceParam: this.appInstanceParam,
          parentWidget: parentWidget,
          isExpanded: false,
          actionMenuButton: trailingWidget,
        );
      } else if (rowNode.content.rowData != null &&
          rowNode.content.rowData!.collectionName ==
              "subfolderlhpformdefinition") {
        String parentBranchRecordId = rowNode.content.rowData!.recordId;

        dynamic temuanLhpDepth1FilterObject = {
          "parentNodeId": parentBranchRecordId
        };

        VwRowData presetValues = VwRowData(recordId: Uuid().v4(), fields: [
          new VwFieldValue(fieldName: "subfolderlhp",valueLinkNode: new VwLinkNode(nodeId: parentBranchRecordId, nodeType: VwNode.ntnRowData), valueTypeId: VwFieldValue.vatValueLinkNode)
        ]);

        CreateRecordButtonChildBranch createRecordButtonChildBranch =
            CreateRecordButtonChildBranch(
          title: "Temuan",
          icon: Icons.insert_drive_file_outlined,
          newRecordPresetValues: presetValues,
          createRecordFormDefinitionId: "temuanlhpformdefinition",
        );

        ChildBranch childBranchTemuanLHP = ChildBranch(
          branchNodeId: parentBranchRecordId,
          createRecordButtonList: [createRecordButtonChildBranch],
          showCreateButton: true,
          depth1FilterObject: temuanLhpDepth1FilterObject,
        );

        return BranchViewer(
          key: Key(parentBranchRecordId),
          refreshDataOnParentFunction: this.implementRefreshOnAfterNodeUpdate,
          commandToParentFunction: this.commandToParentFunction,
          localeId: this.localeId,
          summaryId: "temuanlhp",
          parentNode: this.rowNode,
          childrenBranch: [childBranchTemuanLHP],
          appInstanceParam: this.appInstanceParam,
          parentWidget: parentWidget,
          isExpanded: false,
          actionMenuButton: trailingWidget,
        );
      } else if (rowNode.content.rowData != null &&
          rowNode.content.rowData!.collectionName ==
              "temuanlhpformdefinition") {
        String parentBranchRecordId = rowNode.content.rowData!.recordId;

        dynamic rekomendasitemuanLHPDepth1FilterObject = {
          "content.rowData.collectionName":
              "rekomendasitemuanlhpformdefinition",
          "parentNodeId": parentBranchRecordId,
          "nodeType": VwNode.ntnRowData,
          "nodeStatusId": VwNode.nsActive

        };

        dynamic subtemuanLHPDepth1FilterObject = {
          "content.rowData.collectionName": "subtemuanlhpformdefinition",
          "parentNodeId": parentBranchRecordId,
          "nodeType": VwNode.ntnRowData,
          "nodeStatusId": VwNode.nsActive,
        };

        VwRowData presetValuesSubTemuanLHP =
            VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "temuanlhp",
              valueLinkNode: VwLinkNode(
                  nodeType: VwNode.ntnRowData, nodeId: parentBranchRecordId),
              valueTypeId: VwFieldValue.vatValueLinkNode)
        ]);

        VwRowData presetValuesRekomendasiTemuanLHP =
            VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "temuanlhp",
              valueLinkNode: VwLinkNode(
                  nodeType: VwNode.ntnRowData, nodeId: parentBranchRecordId),
              valueTypeId: VwFieldValue.vatValueLinkNode)
        ]);

        CreateRecordButtonChildBranch
            createRecordButtonChildBranchSubTemuanLHP =
            CreateRecordButtonChildBranch(
          icon: Icons.file_present,
          title: "Sub Temuan",
          newRecordPresetValues: presetValuesSubTemuanLHP,
          createRecordFormDefinitionId: "subtemuanlhpformdefinition",
        );

        ChildBranch childBranchSubTemuanLHP = ChildBranch(
          branchNodeId: parentBranchRecordId,
          isInitiallyExpanded: true,
          createRecordButtonList: [createRecordButtonChildBranchSubTemuanLHP],
          showCreateButton: true,
          depth: 1,
          depth1FilterObject: subtemuanLHPDepth1FilterObject,
        );

        CreateRecordButtonChildBranch createRecordButtonChildBranchTemuanLHP =
            CreateRecordButtonChildBranch(
          title: "Rekomendasi Temuan",
          icon: Icons.message_outlined,
          newRecordPresetValues: presetValuesRekomendasiTemuanLHP,
          createRecordFormDefinitionId: "rekomendasitemuanlhpformdefinition",
        );

        ChildBranch childBranchRekomendasiTemuanLHP = ChildBranch(
          branchNodeId: parentBranchRecordId,
          createRecordButtonList: [createRecordButtonChildBranchTemuanLHP],
          showCreateButton: true,
          depth1FilterObject: rekomendasitemuanLHPDepth1FilterObject,
        );

        return BranchViewer(
          key: Key(parentBranchRecordId),
          localeId: this.localeId,
          refreshDataOnParentFunction: this.implementRefreshOnAfterNodeUpdate,
          summaryId: "temuanlhp",
          parentNode: this.rowNode,
          childrenBranch: [
            childBranchRekomendasiTemuanLHP,
            childBranchSubTemuanLHP
          ],
          appInstanceParam: this.appInstanceParam,
          parentWidget: parentWidget,
          isExpanded: false,
          actionMenuButton: trailingWidget,
        );
      } else if (rowNode.content.rowData != null &&
          rowNode.content.rowData!.collectionName ==
              "rekomendasitemuanlhpformdefinition") {
        String parentBranchRecordId = rowNode.content.rowData!.recordId;
        dynamic tindakLanjutRekomendasiLHPDepth1FilterObject = {
          "content.rowData.collectionName":
              "tindaklanjutrekomendasitemuanlhpformdefinition",
          "parentNodeId": parentBranchRecordId,
          "nodeType": VwNode.ntnRowData,
          "nodeStatusId": VwNode.nsActive

        };

        VwRowData presetValues = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "rekomendasitemuanlhp",
              valueLinkNode: VwLinkNode(
                  nodeType: VwNode.ntnRowData, nodeId: parentBranchRecordId),
              valueTypeId: VwFieldValue.vatValueLinkNode)
        ]);

        CreateRecordButtonChildBranch createRecordButtonChildBranch =
            CreateRecordButtonChildBranch(
          icon: Icons.text_snippet_outlined,
          title: "Tindak Lanjut Rekomendasi Temuan",
          newRecordPresetValues: presetValues,
          createRecordFormDefinitionId:
              "tindaklanjutrekomendasitemuanlhpformdefinition",
        );

        ChildBranch childBranchTindakLanjutRekomendasiTemuanLHP = ChildBranch(
          createRecordButtonList: [createRecordButtonChildBranch],
          branchNodeId: parentBranchRecordId,
          leftMargin: 40,
          showCreateButton: true,
          depth1FilterObject: tindakLanjutRekomendasiLHPDepth1FilterObject,
        );

        return BranchViewer(
          key: Key(parentBranchRecordId),
          localeId: this.localeId,
          summaryId: "rekomendasitemuanlhp",
          refreshDataOnParentFunction: this.implementRefreshOnAfterNodeUpdate,
          parentNode: this.rowNode,
          childrenBranch: [childBranchTindakLanjutRekomendasiTemuanLHP],
          appInstanceParam: this.appInstanceParam,
          parentWidget: parentWidget,
          isExpanded: false,
          actionMenuButton: trailingWidget,
        );
      } else if (rowNode.content.rowData != null &&
          rowNode.content.rowData!.collectionName ==
              "subtemuanlhpformdefinition") {
        String parentBranchRecordId = rowNode.content.rowData!.recordId;
        dynamic rekomendasisubtemuanLHPDepth1FilterObject = {
          "content.rowData.collectionName":
              "rekomendasisubtemuanlhpformdefinition",
          "parentNodeId": parentBranchRecordId,
          "nodeType": VwNode.ntnRowData,
          "nodeStatusId": VwNode.nsActive,
        };

        VwRowData presetValues = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "subtemuanlhp",
              valueLinkNode: VwLinkNode(
                  nodeType: VwNode.ntnRowData, nodeId: parentBranchRecordId),
              valueTypeId: VwFieldValue.vatValueLinkNode)
        ]);

        CreateRecordButtonChildBranch createRecordButtonChildBranch =
            CreateRecordButtonChildBranch(
          icon: Icons.comment_rounded,
          title: "Rekomendasi Sub Temuan",
          newRecordPresetValues: presetValues,
          createRecordFormDefinitionId: "rekomendasisubtemuanlhpformdefinition",
        );

        ChildBranch childBranchRekomendasiSubTemuanLHP = ChildBranch(
          branchNodeId: parentBranchRecordId,
          createRecordButtonList: [createRecordButtonChildBranch],
          showCreateButton: true,
          depth1FilterObject: rekomendasisubtemuanLHPDepth1FilterObject,
        );

        return BranchViewer(
          key: Key(parentBranchRecordId),
          refreshDataOnParentFunction: this.implementRefreshOnAfterNodeUpdate,
          localeId: this.localeId,
          summaryId: "subtemuanlhp",
          parentNode: this.rowNode,
          childrenBranch: [childBranchRekomendasiSubTemuanLHP],
          appInstanceParam: this.appInstanceParam,
          parentWidget: parentWidget,
          isExpanded: false,
          actionMenuButton: trailingWidget,
        );
      } else if (rowNode.content.rowData != null &&
          rowNode.content.rowData!.collectionName ==
              "rekomendasisubtemuanlhpformdefinition") {
        String parentBranchRecordId = rowNode.content.rowData!.recordId;
        dynamic tindakLanjutLHPDepth1FilterObject = {
          "content.rowData.collectionName":
              "tindaklanjutrekomendasisubtemuanlhpformdefinition",
          "parentNodeId": parentBranchRecordId,
          "nodeType": VwNode.ntnRowData,
          "nodeStatusId": VwNode.nsActive

        };

        VwRowData presetValues = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "rekomendasisubtemuanlhp",
              valueLinkNode: VwLinkNode(
                  nodeType: VwNode.ntnRowData, nodeId: parentBranchRecordId),
              valueTypeId: VwFieldValue.vatValueLinkNode)
        ]);

        CreateRecordButtonChildBranch createRecordButtonChildBranch =
            CreateRecordButtonChildBranch(
          icon: Icons.text_snippet_outlined,
          title: "Tindak Lanjut Rekomendasi Sub Temuan",
          newRecordPresetValues: presetValues,
          createRecordFormDefinitionId:
              "tindaklanjutrekomendasisubtemuanlhpformdefinition",
        );

        //ChildBranch childBranchTemuanLHP=ChildBranch(depth1FilterObject: temuanLHPDepth1FilterObject, branchNodeId: "response_subtemuanlhpformdefinition", );
        ChildBranch childBranchTindakLanjutRekomendasiTemuanLHP = ChildBranch(
          branchNodeId: parentBranchRecordId,
          createRecordButtonList: [createRecordButtonChildBranch],
          showCreateButton: true,
          depth1FilterObject: tindakLanjutLHPDepth1FilterObject,
        );

        return BranchViewer(
          key: Key(parentBranchRecordId),
          refreshDataOnParentFunction: this.implementRefreshOnAfterNodeUpdate,
          localeId: this.localeId,
          summaryId: "rekomendasisubtemuanlhp",
          parentNode: this.rowNode,
          childrenBranch: [childBranchTindakLanjutRekomendasiTemuanLHP],
          appInstanceParam: this.appInstanceParam,
          parentWidget: parentWidget,
          isExpanded: false,
          actionMenuButton: trailingWidget,
        );
      } else {
        return VwCardParameterNodeViewerMaterial(
          key: this.key,
          trailingWidget: trailingWidget,
          rowViewerBoxConstraint: this.rowViewerBoxContraints,
          appInstanceParam: this.appInstanceParam,
          cardParameter: cardParameter,
          rowNode: rowNode,
          cardTapper: cardTapper,
          commandToParentFunction: this.commandToParentFunction,
        );
      }
    } catch (error) {
      print("Error Catched on VwBrowseFolderRowViewer.build= " +
          error.toString());
    }
    return Container();
  }
}
