import 'package:flutter/cupertino.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwcontentcontext/vwcontentcontext.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwnoderesponse/vwnoderesponse.dart';
import 'package:matrixclient/modules/deployedcollectionname.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/util/vwrowdatautil.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwtagchecklistfieldwidget/vwtagchecklistnoderowviewer.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/modules/listviewtitlecolumn/listviewtitlecolumn.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';

class VwTagCheckListFieldWidget extends StatefulWidget {
  const VwTagCheckListFieldWidget(
      {super.key,
      required this.appInstanceParam,
      required this.field,
      this.readOnly = false,
      required this.formField,
      this.onValueChanged,
      required this.getCurrentFormResponseFunction,
      required this.formDefinition});

  final VwAppInstanceParam appInstanceParam;
  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;
  final VwFormDefinition formDefinition;

  static const userTagResponseFieldName = "userTagResponse";

  VwTagCheckListFieldWidgetState createState() =>
      VwTagCheckListFieldWidgetState();
}

class VwTagCheckListFieldWidgetState extends State<VwTagCheckListFieldWidget> {
  @override
  void initState() {
    super.initState();

    String? currentUserId =
        widget.appInstanceParam.loginResponse!.userInfo!.user!.recordId;

    String? creatorUserId =
        this.widget.getCurrentFormResponseFunction().creatorUserId;

   VwRowData currentFormResponse= this.widget.getCurrentFormResponseFunction();

    if (currentUserId != creatorUserId &&
        (this.widget.getCurrentFormResponseFunction().crudMode ==
                VwBaseModel.cmCreateOrUpdate ||
            this.widget.getCurrentFormResponseFunction().crudMode ==
                VwBaseModel.cmUpdate)) {
      initUserCommentResponse(userId: currentUserId);
    }
    //this.createCurrentUserRowDataIfNotExists();
  }

  RefreshDataOnParentFunction? refreshDataOnParentFunction;

  Widget implementNodeRowViewerFunction(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    this.refreshDataOnParentFunction = refreshDataOnParentFunction;

    VwRowData formResponse = widget.getCurrentFormResponseFunction();

    VwFieldValue? fieldFileStorageFieldValue;

    if (widget.formField.fieldUiParam.refTagListFieldFileStorageFieldName !=
        null) {
      fieldFileStorageFieldValue = formResponse.getFieldByName(
          widget.formField.fieldUiParam.refTagListFieldFileStorageFieldName!);
    }

    return VwTagCheckListNodeRowViewer(
      readOnly: this.widget.readOnly,
        field: this.widget.field,
        getCurrentFormResponseFunction:
            this.widget.getCurrentFormResponseFunction,
        formDefinition: this.widget.formDefinition,
        tagLinkNodeListFieldValue: this.widget.field,
        creatorUserId:
            this.widget.getCurrentFormResponseFunction().creatorUserId!,
        currentUserId:
            widget.appInstanceParam.loginResponse!.userInfo!.user.recordId,
        formField: widget.formField,
        context: context,
        fieldFileStorage: fieldFileStorageFieldValue?.valueFieldFileStorage,
        rowNode: renderedNode,
        appInstanceParam: widget.appInstanceParam,
        nodeResponseLinkNodeListFieldValue: VwFieldValue(
            fieldName: "nodeResponse",
            valueRowDataList: this.arrangeNodeResponse()));
  }

  void initUserCommentResponse({required String userId}) {
    try {
     VwRowData currentFormResponse= this.widget.getCurrentFormResponseFunction();

      //todo: fill by parent form data
      List<VwRowData> currentUserNodeResponseList = [];

      if (this.widget.field.syncFormResponseList != null) {
        currentUserNodeResponseList =
            VwRowDataUtil.getFormResponseByFieldNameAndUserId(
                formResponseList: this.widget.field.syncFormResponseList!,
                fieldName: this.widget.formField.fieldDefinition.fieldName,
                userId: userId);
      }




      if ( currentUserNodeResponseList.length == 0) {
        if (this.widget.field.renderedFormResponseList != null) {
          currentUserNodeResponseList =
              VwRowDataUtil.getFormResponseByFieldNameAndUserId(
                  formResponseList: this.widget.field.renderedFormResponseList!,
                  fieldName: this.widget.formField.fieldDefinition.fieldName,
                  userId: userId);
          if (currentUserNodeResponseList.length > 0 )  {
            this
                .widget
                .field
                .syncFormResponseList!
                .add(currentUserNodeResponseList.elementAt(0));
          }
        }

        if (currentUserNodeResponseList.length == 0) {
          VwRowData currentUserRowData = VwRowData(
              collectionName: "usercommentformdefinition",
              creatorUserLinkNode: VwLinkNode(
                  nodeId: userId,
                  nodeType: VwNode.ntnClassEncodedJson,
                  contentContext: VwContentContext(
                      className: "VwUser",
                      recordId: userId,
                      collectionName: DeployedCollectionName.vwUser)),
              recordId: Uuid().v4(),
              creatorUserId: userId,
              fields: [
                VwFieldValue(
                    fieldName:
                        VwTagCheckListFieldWidget.userTagResponseFieldName,
                    valueTypeId: VwFieldValue.vatValueLinkNodeList,
                    valueLinkNodeList: [])
              ]);

          //VwNode currentUserNodeResponse=NodeUtil.generateNodeRowData( rowData: currentUserRowData, upsyncToken: "<invalid_upsync_token>", parentNodeId: "response_comment", ownerUserId: userId);

          currentUserRowData.responseInfo = VwNodeResponse(
              targetNodeId: widget.getCurrentFormResponseFunction().recordId,
              contextTypeId: "fieldName",
              contextId: this.widget.formField.fieldDefinition.fieldName);

          if (this.widget.field.syncFormResponseList == null) {
            this.widget.field.syncFormResponseList = [];
          }
          //this.widget.field.syncFormResponseList!.add(currentUserRowData);
          // returnValue=currentUserNodeResponse;
          currentUserNodeResponseList.add(currentUserRowData);

          if (currentUserNodeResponseList.length > 0 )  {
            this
                .widget
                .field
                .syncFormResponseList!
                .add(currentUserNodeResponseList.elementAt(0));
          }
        }


      }
    } catch (error) {
      print("Error catched on VwTagListFieldWIdget.initUserNodeResponse=" +
          error.toString());
    }

    // return returnValue!;
  }

  List<ListViewTitleColumn> arrangeNodeResponseTitle() {
    String creatorUserId =
        widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;
    return VwRowDataUtil.createFormResponseTitle(
        creatorUserId: creatorUserId,
        formResponseList: this.arrangeNodeResponse());
  }

  List<VwRowData> arrangeNodeResponse() {
    List<VwRowData> activeNodeResponseList = [];

    List<VwRowData> currentRenderedFormResponseList =
        VwRowDataUtil.getFormResponseByFieldName(
            formResponseList: this.widget.field.renderedFormResponseList!,
            fieldName: this.widget.field.fieldName);

    //get all rendered the minus by the sync

    for (int la = 0; la < currentRenderedFormResponseList.length; la++) {
      VwRowData currentRendered = currentRenderedFormResponseList.elementAt(la);

      List<VwRowData> commentList = VwRowDataUtil.getFormResponseByRecordId(
          formResponseList: this.widget.field.syncFormResponseList!,
          recordId: currentRendered.recordId);

      if (commentList.length == 0 && currentRendered.creatorUserId!=this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId) {
        activeNodeResponseList.add(currentRendered);
      }
    }

    List<VwRowData> syncList = VwRowDataUtil.getFormResponseByFieldName(
        formResponseList: this.widget.field.syncFormResponseList!,
        fieldName: this.widget.formField.fieldDefinition.fieldName);

    activeNodeResponseList.addAll(syncList);

    return activeNodeResponseList;
  }

  @override
  Widget build(BuildContext context) {
    Widget captionWidget = Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: VwFieldWidget.getLabel(widget.field, widget.formField,
            DefaultTextStyle.of(context).style, widget.readOnly));

    VwFieldValue? refFieldValue;

    if (widget.formField.fieldUiParam.nodeContainerTagLinkNode != null &&
        widget.formField.fieldUiParam.nodeContainerTagLinkNode!
                .childrenNodeRendered !=
            null) {
      refFieldValue = VwFieldValue(
          fieldName: '<invalid_fieldname>',
          valueTypeId: VwFieldValue.vatValueLinkNodeList,
          valueLinkNodeList: NodeUtil.convertNodeListToLinkNodeList(
              nodeList: widget.formField.fieldUiParam.nodeContainerTagLinkNode!
                  .childrenNodeRendered!.rows));
    }

    List<ListViewTitleColumn> listViewTitleColumnList = [];

    listViewTitleColumnList
        .add(ListViewTitleColumn(caption: "Berkas Dokumen", flex: 5));
    listViewTitleColumnList.add(ListViewTitleColumn(caption: "Link", flex: 1));

    /*
    if(this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId!= this.widget.getFieldvalueCurrentResponseFunction().creatorUserId) {
      listViewTitleColumnList.add(ListViewTitleColumn(caption:"(Anda)",flex:2 ));
    }*/

    listViewTitleColumnList.addAll(arrangeNodeResponseTitle());

    if (widget.formField.fieldUiParam.nodeContainerTagLinkNode!
            .childrenNodeRendered !=
        null) {
      return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        captionWidget,

        Flexible(
            fit: FlexFit.loose,
            child: Container(

          
            child: NodeListView(
              enableScaffold: false,
              titleColumns: listViewTitleColumnList,
              nodeFetchMode: NodeListView.nfmParent,
              fieldValue: refFieldValue,
              appInstanceParam: widget.appInstanceParam,
              apiCallParam: VwRowData(recordId: Uuid().v4()),
              nodeRowViewerFunction: implementNodeRowViewerFunction,
            ))),

      ]);
    } else {
      return Column(
          mainAxisSize: MainAxisSize.min,
          key: this.widget.key,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [captionWidget, Text("Error: Ref Node is not found")]);
    }
  }
}
