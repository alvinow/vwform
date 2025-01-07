import 'package:flutter/cupertino.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient/modules/edokumen2022/remoteapi/remote_api.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidgetutil.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwformpage/vwdefaultformpage.dart';
import 'package:matrixclient/modules/vwformpage/vwoldformpage.dart';
import 'package:matrixclient/modules/vwwidget/vwoperatorticketpage/modules/vwoperatorticketpagedefinition/vwoperatorticketpagedefinition.dart';

class VwFormFieldWidget extends StatefulWidget {
  const VwFormFieldWidget(
      {super.key,

        required this.appInstanceParam,
        required this.field,
        this.readOnly = false,
        required this.formField,
        this.onValueChanged,
        required this.getFieldvalueCurrentResponseFunction,

      });
  final VwAppInstanceParam appInstanceParam;
  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final GetCurrentFormResponseFunction getFieldvalueCurrentResponseFunction;


  _VwFormFieldWidgetState createState() => _VwFormFieldWidgetState();
}

class _VwFormFieldWidgetState extends State<VwFormFieldWidget> {
  VwFormDefinition? currentFormDefinition;

  @override
  void initState() {
    super.initState();
    this.setFormDefinition();
    this.clearAttachments();
  }

  void clearAttachments() {
    try {
      List<int> willBeDeleteList = [];
      for (int la = 0;
      la < widget.field.valueFormResponse!.attachments!.length;
      la++) {
        VwNodeContent currentNodeContent =
        widget.field.valueFormResponse!.attachments!.elementAt(la);

        if (currentNodeContent.tag == AppConfig.vwFormDefinition) {
          willBeDeleteList.add(la);
        }
      }

      for (int la = willBeDeleteList.length - 1; la >= 0; la--) {
        int deletedIndex = willBeDeleteList.elementAt(la);
        widget.field.valueFormResponse!.attachments!.removeAt(deletedIndex);
      }
    } catch (error) {}
  }

  void setFormDefinition() {
    try {
      VwRowData? currentFormResponse =
      widget.getFieldvalueCurrentResponseFunction();

      VwFieldValue? refInternalFieldValue =
      VwFieldWidgetUtil.getInternalOfFielValueFromRowData(
          source: currentFormResponse,
          localFieldRef: widget.formField.fieldUiParam.localFieldRef!);

      if(this.widget.formField.fieldUiParam.uiTypeId==VwFieldUiParam.uitFormPageByLocalFieldSource)
      {
        try {
          VwFieldValue? formResponseFieldValue = NodeUtil
              .getFieldValueByLocalFieldRef(rowData: currentFormResponse,
              localFieldRef: widget.formField.fieldUiParam.localFieldRef!);
          VwNode? formResponseNode = NodeUtil.extractNodeFromLinkNode(
              formResponseFieldValue!.valueLinkNode!);

          VwClassEncodedJson? formResponseClassEncodedJson = NodeUtil
              .extractClassEncodedJsonFromContent(
              nodeContent: formResponseNode!.content);

          RemoteApi.decompressClassEncodedJson(formResponseClassEncodedJson!);
          currentFormDefinition =
              VwFormDefinition.fromJson(formResponseClassEncodedJson!.data!);

          if(currentFormResponse.collectionName=="vwticketeventresponse" && this.widget.formField.fieldDefinition.fieldName=="primeStateFormResponse")
          {
            if(this.widget.field.valueFormResponse!.creatorUserId==this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId)
            {
              currentFormDefinition =null;
            }
          }

        }
        catch(error)
        {

        }

      }

      else if (refInternalFieldValue!.valueLinkNode != null) {
        try {
          VwLinkNode currentLinkNode = refInternalFieldValue!.valueLinkNode!;

          VwRowData? currentRecordLinkNode;

          if (currentLinkNode.nodeType == VwNode.ntnRowData) {
            if (currentLinkNode.rendered != null) {
              currentRecordLinkNode =
                  currentLinkNode.rendered!.node!.content.rowData;
            }

            if (currentRecordLinkNode == null &&
                currentLinkNode.cache != null) {
              currentRecordLinkNode =
                  currentLinkNode.cache!.node!.content.rowData;
            }
          }

          VwFieldValue? currentFieldValue =
          currentRecordLinkNode!.getFieldByName("formDefinition");

          VwClassEncodedJson? currentClassEncodedJson;

          if (currentFieldValue!.valueLinkNode!.nodeType ==
              VwNode.ntnLinkBaseModelCollection) {
            try {
              currentClassEncodedJson = NodeUtil.extractBaseModel(
                  currentFieldValue!.valueLinkNode!.rendered!.node!.content);
            } catch (error) {}

            if (currentClassEncodedJson == null) {
              try {
                currentClassEncodedJson = NodeUtil.extractBaseModel(
                    currentFieldValue!.valueLinkNode!.cache!.node!.content);
              } catch (error) {}
            }
          } else if (currentFieldValue!.valueLinkNode!.nodeType ==
              VwNode.ntnClassEncodedJson) {
            VwNode? currentFormDefinitionNode =
            NodeUtil.extractNodeFromLinkNode(
                currentFieldValue!.valueLinkNode!);

            if (currentFormDefinitionNode != null) {
              currentClassEncodedJson =
                  currentFormDefinitionNode.content.classEncodedJson;
            }
          }

          if (currentClassEncodedJson != null) {
            RemoteApi.decompressClassEncodedJson(currentClassEncodedJson!);
            currentFormDefinition =
                VwFormDefinition.fromJson(currentClassEncodedJson!.data!);
          }
        } catch (error) {}
      } else if (refInternalFieldValue != null &&
          refInternalFieldValue.valueLinkNode != null &&
          refInternalFieldValue.valueLinkNode!.cache != null &&
          refInternalFieldValue
              .valueLinkNode!.cache!.node!.content.linkbasemodel !=
              null &&
          refInternalFieldValue.valueLinkNode!.cache!.node!.content
              .linkbasemodel!.rendered !=
              null &&
          refInternalFieldValue.valueLinkNode!.cache!.node!.content
              .linkbasemodel!.rendered!.data !=
              null) {
        currentFormDefinition = VwFormDefinition.fromJson(refInternalFieldValue
            .valueLinkNode!
            .cache!
            .node!
            .content
            .linkbasemodel!
            .rendered!
            .data!);
      }

      if (currentFormDefinition != null) {
        currentFormDefinition!.dataSource = VwDataSourceDefinition.smParent;

        if (widget.field.valueFormResponse == null) {
          if (currentFormDefinition!.attachments != null) {
            List<VwNodeContent> nodeContentList =
            NodeUtil.extractAttachmentsByTag(
                attachments: currentFormDefinition!.attachments!,
                nodeType: VwNode.ntnRowData,
                tag: VwOperatorTicketPageDefinition
                    .tagLatestFormResponseStateOnTicket);

            if (nodeContentList.length > 0) {
              widget.field.valueFormResponse =
                  nodeContentList.elementAt(0).rowData;
            }
          }
        }

        if (widget.field.valueFormResponse == null) {
          widget.field.valueFormResponse =
              VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                  formDefinition: currentFormDefinition!,
                  ownerUserId: widget.appInstanceParam.loginResponse!.userInfo!.user.recordId);
        }
      }
    } catch (error) {
      print("error catched on VwFormFieldWidget.setFormDefinition()");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget captionWidget = VwFieldWidget.getLabel(
        widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        widget.readOnly);

    if (currentFormDefinition != null) {
      currentFormDefinition!.isReadOnly =
          currentFormDefinition!.isReadOnly || widget.readOnly;


      if(this.widget.readOnly==true) {
        currentFormDefinition!.isReadOnly = this.widget.readOnly;
      }

      Widget currentFormPage = VwFormPage(
        enableScaffold: false,
          disableScrollView: true,
          key: widget.key,
          isShowSaveButton: false,
          enablePopContextAfterSucessfullySaved: false,
          isMultipageSections: true,
          isShowAppBar: false,
          appInstanceParam: this.widget.appInstanceParam,
          formResponse: widget.field.valueFormResponse!,
          formDefinition: currentFormDefinition!,
          formDefinitionFolderNodeId: AppConfig.formDefinitionFolderNodeId);

      //return currentFormPage;

      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible( fit: FlexFit.loose,child: captionWidget),

            Flexible(
                fit: FlexFit.loose,

                child: Container(

                    key: widget.key,   child: currentFormPage))
          ]);
    } else {
      return Center(child: Text("No Form"));
    }
  }
}