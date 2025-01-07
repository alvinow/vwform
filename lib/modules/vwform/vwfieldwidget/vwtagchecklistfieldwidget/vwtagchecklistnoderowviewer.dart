import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfieldfilestorage/vwfieldfilestorage.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/filestorageutil.dart';
import 'package:matrixclient/modules/util/formutil.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwtagchecklistfieldwidget/vwtagchecklistfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:matrixclient/modules/vwmultimediaviewer/vwmultimediaviewer.dart';
import 'package:matrixclient/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:matrixclient/modules/vwwidget/noderowviewer/noderowviewer.dart';
import 'package:matrixclient/modules/vwwidget/vwcheckbox/vwcheckbox.dart';

class VwTagCheckListNodeRowViewer extends NodeRowViewer {
  VwTagCheckListNodeRowViewer(
      {super.key,
      super.topRowWidget,
      required super.rowNode,
      required super.appInstanceParam,
      super.highlightedText,
      super.refreshDataOnParentFunction,
      super.collectionListViewDefinition,
      super.updateSelectedState,
      super.selectedList,
      super.selectedIcon,
      super.unselectedIcon,
      required this.nodeResponseLinkNodeListFieldValue,
      required this.tagLinkNodeListFieldValue,
      this.fieldFileStorage,
      required this.context,
      required this.formField,
      required this.currentUserId,
      required this.creatorUserId,
      required this.formDefinition,
      required this.getCurrentFormResponseFunction,
      required this.field,
      this.readOnly=false
      });

  final VwFieldValue tagLinkNodeListFieldValue;
  final VwFieldValue nodeResponseLinkNodeListFieldValue;
  final VwFieldFileStorage? fieldFileStorage;
  final BuildContext context;
  final VwFormField formField;
  final String currentUserId;
  final String creatorUserId;
  final VwFormDefinition formDefinition;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;
  final VwFieldValue field;
  final bool readOnly;

  Widget createTagLinkWidget(
      {required VwRowData filePageNodeTag,
      required VwFieldFileStorage fieldFileStorage}) {
    Widget returnValue = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: InkWell(
          child: Center(child: Icon(Icons.not_interested, color: Colors.grey)),
          onTap: () {
            print("Empty link Tapped");
          },
        ));

    try {
      String fileStorageId = filePageNodeTag
          .getFieldByName("fileStorageId")!
          .valueString!;
      int page = filePageNodeTag
          .getFieldByName("page")!
          .valueNumber!
          .round();

      VwFileStorage? currentFileStorage;

      if (fieldFileStorage.uploadFile != null) {
        currentFileStorage = FileStorageUtil.getFileStorageById(
            fileStorageId: fileStorageId,
            fileStorageList: fieldFileStorage.uploadFile!);
      }

      if (currentFileStorage == null && fieldFileStorage.serverFile != null) {
        currentFileStorage = FileStorageUtil.getFileStorageById(
            fileStorageId: fileStorageId,
            fileStorageList: fieldFileStorage.serverFile!);
      }

      returnValue = Container(
        alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
          child: InkWell(
            child: Icon(Icons.link, color: Colors.blue, size: 35),
            onTap: () {
              print("Link Tapped");

              // String tagLinkNodeListFieldName=this.formField.fieldUiParam.fieldFileTagDefinition!.linkNodeListFieldName;
              //VwFormField? tagLinkNodeListFormField=FormUtil.getFormField(fieldName: tagLinkNodeListFieldName, formDefinition: this.formDefinition);
              VwFieldValue? tagListFieldValue = this
                  .getCurrentFormResponseFunction()
                  .getFieldByName(this
                      .formField
                      .fieldUiParam
                      .refTagListFieldFileStorageFieldName!);
              VwFormField? tagListFieldFormField = FormUtil.getFormField(
                  fieldName: this
                      .formField
                      .fieldUiParam
                      .refTagListFieldFileStorageFieldName!,
                  formDefinition: this.formDefinition);

              List<VwLinkNode>? tagRefLinkNodeList = [];
              if (tagListFieldValue != null && tagListFieldFormField != null) {
                if (tagListFieldFormField!.fieldUiParam.fieldFileTagDefinition!
                        .linkNodeListFieldName !=
                    null) {
                  String linkNodeListFieldName = tagListFieldFormField!
                      .fieldUiParam
                      .fieldFileTagDefinition!
                      .linkNodeListFieldName;

                  if (this
                          .getCurrentFormResponseFunction()
                          .getFieldByName(linkNodeListFieldName) !=
                      null) {
                    tagListFieldValue = this
                        .getCurrentFormResponseFunction()
                        .getFieldByName(linkNodeListFieldName);
                  }
                }

                if (tagListFieldFormField!.fieldUiParam.fieldFileTagDefinition!
                        .linkNodeListFieldName !=
                    null) {
                  String tagLinkNodeListFieldName = tagListFieldFormField!
                      .fieldUiParam
                      .fieldFileTagDefinition!
                      .linkNodeListFieldName;

                  if (this
                          .getCurrentFormResponseFunction()
                          .getFieldByName(tagLinkNodeListFieldName) !=
                      null) {
                    tagListFieldValue = this
                        .getCurrentFormResponseFunction()
                        .getFieldByName(tagLinkNodeListFieldName);

                    //String linkNodeListFieldName=linkNodeListFieldName;
                    VwFormDefinition currentFormDefinition =
                        this.formDefinition;

                    VwFormField? tagLinkNodeListFormField =
                        FormUtil.getFormField(
                            fieldName: tagLinkNodeListFieldName,
                            formDefinition: currentFormDefinition);

                    if (tagLinkNodeListFormField != null) {
                      if (tagLinkNodeListFormField
                                  .fieldUiParam.nodeContainerTagLinkNode !=
                              null &&
                          tagLinkNodeListFormField
                                  .fieldUiParam
                                  .nodeContainerTagLinkNode!
                                  .childrenNodeRendered !=
                              null) {
                        tagRefLinkNodeList =
                            NodeUtil.convertNodeListToLinkNodeList(
                                nodeList: tagListFieldFormField
                                    .fieldUiParam
                                    .nodeContainerTagLinkNode!
                                    .childrenNodeRendered!
                                    .rows);
                      }
                    }
                  }
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VwMultimediaViewer(
                        initPage: page,
                        appInstanceParam: this.appInstanceParam,
                        multimediaViewerParam: VwMultimediaViewerParam(
                            refTagLinkNodeList: tagRefLinkNodeList,
                            fieldFileTagDefinition:
                                tagListFieldFormField != null
                                    ? tagListFieldFormField!
                                        .fieldUiParam.fieldFileTagDefinition
                                    : null),
                        multimediaViewerInstanceParam:
                            VwMultimediaViewerInstanceParam(
                                tagFieldvalue: tagListFieldValue,
                                remoteSource: [currentFileStorage!],
                                fileSource: [],
                                memorySource: []))),
              );
            },
          ));
    } catch (error) {}

    return returnValue;
  }


  VwRowData? getRefTagNodeOnRowDataList({
    required VwNode refNode,
    required List<VwRowData> sourceRowDataList
})
{
  VwRowData? returnValue;
  try {
    for (int la = 0; la < sourceRowDataList.length; la++) {
      VwRowData currentRowDataSource = sourceRowDataList[la];

      VwFieldValue? linkTagNodeFieldValue =
      currentRowDataSource.getFieldByName("linkTagNode");

      if (linkTagNodeFieldValue != null &&
          linkTagNodeFieldValue!.valueLinkNode != null &&
          linkTagNodeFieldValue!.valueLinkNode!.nodeId ==
              refNode.recordId) {
        returnValue = currentRowDataSource;
        break;
      }
    }
  }
  catch(error)
  {

  }
  return returnValue;
}

/*
  VwNode? getRefTagNodeOnLinkNodeList(
      {required VwNode refNode, required List<VwLinkNode> linkNodeList}) {
    VwNode? returnValue;

    try {
      for (int la = 0; la < linkNodeList.length; la++) {
        VwLinkNode currentLinkNode = linkNodeList.elementAt(la);

        VwNode? currentNode = NodeUtil.extractNodeFromLinkNode(currentLinkNode);

        if (currentNode != null && currentNode.content.rowData != null) {
          VwFieldValue? linkTagNodeFieldValue =
              currentNode.content.rowData!.getFieldByName("linkTagNode");

          if (linkTagNodeFieldValue != null &&
              linkTagNodeFieldValue!.valueLinkNode != null &&
              linkTagNodeFieldValue!.valueLinkNode!.nodeId ==
                  refNode.recordId) {
            returnValue = currentNode;
            break;
          }
        }
      }
    } catch (error) {}
    return returnValue;
  }*/

  static VwNode? getRefTagNodeOnNodeList(
      {required VwNode refNode,
      required List<VwLinkNode> nodeResponseLinkNodeList}) {
    VwNode? returnValue;

    try {
      for (int la = 0; la < nodeResponseLinkNodeList.length; la++) {
        VwLinkNode currentLinkNode = nodeResponseLinkNodeList.elementAt(la);

        VwNode? currentNode = NodeUtil.extractNodeFromLinkNode(currentLinkNode);

        if (currentNode!.recordId == refNode.recordId) {
          returnValue = currentNode;
          break;
        }
      }
    } catch (error) {}
    return returnValue;
  }


  List<Widget> userNodeResponseCheckboxList({bool readOnly=false }) {
    List<Widget> returnValue = [];
    try {
      if (this.nodeResponseLinkNodeListFieldValue.valueRowDataList != null) {
        for (int la = 0;
            la <
                this
                    .nodeResponseLinkNodeListFieldValue
                    .valueRowDataList!
                    .length;
            la++) {

          VwRowData currentNode = this
              .nodeResponseLinkNodeListFieldValue
              .valueRowDataList!
              .elementAt(la);

          if (currentNode.getFieldByName(
                  VwTagCheckListFieldWidget.userTagResponseFieldName) !=
              null) {
            if (currentNode
                    .getFieldByName(
                        VwTagCheckListFieldWidget.userTagResponseFieldName)!
                    .valueLinkNodeList ==
                null) {
              currentNode
                  .getFieldByName(
                      VwTagCheckListFieldWidget.userTagResponseFieldName)!
                  .valueLinkNodeList = [];
            }

            VwFieldValue userTagResponseFieldValue = currentNode.getFieldByName(
                VwTagCheckListFieldWidget.userTagResponseFieldName)!;

            VwNode? userTagNode = getRefTagNodeOnNodeList(
                refNode: this.rowNode,
                nodeResponseLinkNodeList:
                    userTagResponseFieldValue.valueLinkNodeList!);

            bool applyReadOnly = readOnly;

            if(applyReadOnly==false) {
              applyReadOnly=currentNode.creatorUserId ==
                  this.appInstanceParam.loginResponse!.userInfo!.user.recordId
                  ? false
                  : true;
            }

            Widget userResponseCheckboxWidget = Expanded(
                flex: 1,
                child: VwCheckBox(
                  isReadOnly: applyReadOnly,
                  selectedIcon: Icon(
                    Icons.check_box,
                    color: applyReadOnly == true ? Colors.blueGrey : Colors.blue,
                  ),
                  unselectedIcon: Icon(
                    Icons.check_box_outline_blank,
                    color: applyReadOnly == true ? Colors.blueGrey : Colors.blue,
                  ),
                  initialState: userTagNode != null,
                  onTap: (isChecked) {
                    if (isChecked == true) {
                      NodeUtil.injectNodeToLinkNodeList(this.rowNode,
                          userTagResponseFieldValue!.valueLinkNodeList!);
                    } else {
                      NodeUtil.removeNodeFromLinkNodeList(this.rowNode.recordId,
                          userTagResponseFieldValue!.valueLinkNodeList!);
                    }
                  },
                ));

            returnValue.add(userResponseCheckboxWidget);
          }
        }
      }
    } catch (error) {}

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    if (rowNode.content.rowData != null) {
      VwFieldValue? titleFieldValue =
          rowNode.content.rowData!.getFieldByName("title");
      if (titleFieldValue != null && titleFieldValue!.valueString != null) {
        VwRowData? filePageNodeTag;

        if (this.tagLinkNodeListFieldValue.valueRowDataList != null) {
          filePageNodeTag = getRefTagNodeOnRowDataList(
              refNode: this.rowNode,
              sourceRowDataList : this.tagLinkNodeListFieldValue.valueRowDataList!);
        }



        List<Widget> rowWidgetList = [];

        Widget berkasDescriptionTag = Expanded(
            flex: 5, child: Text(titleFieldValue!.valueString.toString()));

        Widget linkDocumentTag =
            filePageNodeTag == null || this.fieldFileStorage == null
                ? Expanded(flex: 1, child: Container())
                : Expanded(
                    flex: 1,
                    child: createTagLinkWidget(
                        filePageNodeTag: filePageNodeTag!,
                        fieldFileStorage: this.fieldFileStorage!));

        rowWidgetList.add(berkasDescriptionTag);
        rowWidgetList.add(linkDocumentTag);
        //rowWidgetList.add(checkboxWidget);

        /*
        if(this.appInstanceParam.loginResponse!.userInfo!.user.recordId!= this.creatorUserId) {
          rowWidgetList.add(currentUserResponseCheckboxWidget);
        }

         */
        rowWidgetList.addAll(this.userNodeResponseCheckboxList(readOnly: this.readOnly));

        return Row(
            key: Key(this.rowNode.recordId),
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowWidgetList);
      }
    }

    return Container();
  }
}
