import 'package:flutter/cupertino.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwlocalfieldref/vwlocalfieldref.dart';
import 'package:matrixclient/modules/vwformpage/vwdefaultformpage.dart';
import 'package:matrixclient/modules/vwformpage/vwoldformpage.dart';

class VwFormPageNodeViewerWidget extends StatefulWidget {
  const VwFormPageNodeViewerWidget({
    super.key,
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

  VwFormPageNodeViewerWidgetState createState() =>
      VwFormPageNodeViewerWidgetState();
}

class VwFormPageNodeViewerWidgetState
    extends State<VwFormPageNodeViewerWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  VwFormDefinition? getFormDefinitionFromFormResponse(
      VwLocalFieldRef localFieldRef, VwRowData formResponse) {
    VwFormDefinition? returnValue;
    try {
      VwFieldValue? formDefinitionFieldValue =
          this.getLocalFieldRef(localFieldRef, formResponse);

      if (formDefinitionFieldValue != null &&
          formDefinitionFieldValue.valueLinkNode != null) {
        VwNode? formDefinitionNode = NodeUtil.extractNodeFromLinkNode(
            formDefinitionFieldValue.valueLinkNode!);

        if (formDefinitionNode != null) {
          returnValue = VwFormDefinition.fromJson(
              formDefinitionNode!.content.classEncodedJson!.data!);
        }
      }
    } catch (error) {}
    return returnValue;
  }

  VwFieldValue? getLocalFieldRef(
      VwLocalFieldRef localFieldRef, VwRowData formResponse) {
    VwFieldValue? returnValue;
    try {
      if (localFieldRef.localFieldName != null) {
        returnValue =
            formResponse.getFieldByName(localFieldRef.localFieldName!);

        if (returnValue != null &&
            localFieldRef.internalFieldName != null &&
            returnValue.valueLinkNode != null) {
          VwNode? localFieldNode =
              NodeUtil.extractNodeFromLinkNode(returnValue.valueLinkNode!);

          if (localFieldNode != null &&
              localFieldNode.content.rowData != null) {
            returnValue = localFieldNode.content.rowData!
                .getFieldByName(localFieldRef.internalFieldName!);

            if (localFieldRef.internalSubFieldName != null &&
                returnValue != null &&
                returnValue.valueLinkNode != null) {
              VwNode? internalNode =
                  NodeUtil.extractNodeFromLinkNode(returnValue.valueLinkNode!);

              if (internalNode != null) {
                returnValue = internalNode.content.rowData!
                    .getFieldByName(localFieldRef.internalSubFieldName!);

                if (localFieldRef.internalSub2FieldName != null &&
                    returnValue != null &&
                    returnValue.valueLinkNode != null) {
                  VwNode? internalSubNode = NodeUtil.extractNodeFromLinkNode(
                      returnValue.valueLinkNode!);

                  if (internalSubNode != null) {
                    returnValue = internalSubNode.content.rowData!
                        .getFieldByName(localFieldRef.internalSub2FieldName!);

                    if (localFieldRef.internalSub3FieldName != null &&
                        returnValue != null &&
                        returnValue.valueLinkNode != null) {
                      VwNode? internalSub2Node =
                          NodeUtil.extractNodeFromLinkNode(
                              returnValue.valueLinkNode!);

                      if (internalSub2Node != null) {
                        returnValue = internalSub2Node.content.rowData!
                            .getFieldByName(
                                localFieldRef.internalSub3FieldName!);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (error) {}
    return returnValue;
  }

  Widget buildForm(VwRowData formResponse) {
    Widget captionWidget = VwFieldWidget.getLabel(
        widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        widget.readOnly);

    try {
      VwFormDefinition? formDefinition;
      VwFormDefinition? formDefinitionRead;

      try {
        formDefinition = NodeUtil.extractFormDefinitionFromContent(
            nodeContent: NodeUtil.extractNodeFromLinkNode(
                    formResponse.formDefinitionLinkNode!)!
                .content);

        formDefinitionRead = NodeUtil.extractFormDefinitionFromContent(
            nodeContent: NodeUtil.extractNodeFromLinkNode(
                    formResponse.cmReadFormDefinitionLinkNode!)!
                .content);
      } catch (error) {}

      VwFormDefinition? currentFormDefinition = formDefinitionRead;

      if (currentFormDefinition == null) {
        currentFormDefinition = formDefinition;
      }

      if (currentFormDefinition == null &&
          this.widget.formField.fieldUiParam.formDefinitionLocalFieldRef !=
              null) {

        currentFormDefinition=this.getFormDefinitionFromFormResponse(
            this.widget.formField.fieldUiParam.formDefinitionLocalFieldRef!,
            this.widget.getFieldvalueCurrentResponseFunction());
      }

      if (currentFormDefinition != null) {

        currentFormDefinition.isReadOnly=this.widget.formField.fieldUiParam
        .isReadOnly||this.widget.readOnly;

        Widget currentFormPage = VwFormPage(
            key: widget.key,
            isShowSaveButton: false,
            enablePopContextAfterSucessfullySaved: false,
            isMultipageSections: true,
            isShowAppBar: false,
            appInstanceParam: this.widget.appInstanceParam,
            formResponse: formResponse,
            formDefinition: currentFormDefinition!,
            formDefinitionFolderNodeId: AppConfig.formDefinitionFolderNodeId);

        //return currentFormPage;

        return Column(
            key: widget.key,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              captionWidget,
              Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                      key: widget.key, height: 300, child: currentFormPage))
            ]);
      }
    } catch (error) {}
    return Column(
        key: widget.key,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          captionWidget,
          Flexible(
              fit: FlexFit.loose,
              child: Container(
                  key: widget.key,
                  child: Text("Error :Invalid form FormDefinitionId ")))
        ]);
  }

  VwRowData? getFormResponse() {
    VwRowData? returnValue;
    try {
      VwFieldValue? localFieldValue = this
          .widget
          .getFieldvalueCurrentResponseFunction()
          .getFieldByName(
              this.widget.formField.fieldUiParam.localFieldRef!.localFieldName);

      if (localFieldValue != null && localFieldValue!.valueLinkNode != null) {
        VwNode? internalNode =
            NodeUtil.extractNodeFromLinkNode(localFieldValue!.valueLinkNode!);

        VwFieldValue? internalFieldValue = internalNode!.content.rowData!
            .getFieldByName(this
                .widget
                .formField
                .fieldUiParam
                .localFieldRef!
                .internalFieldName!);

        VwNode? subInternalNode = NodeUtil.extractNodeFromLinkNode(
            internalFieldValue!.valueLinkNode!);

        VwFieldValue? subInternalFieldValue = subInternalNode!.content.rowData!
            .getFieldByName(this
                .widget
                .formField
                .fieldUiParam
                .localFieldRef!
                .internalSubFieldName!);

        returnValue = subInternalFieldValue!.valueFormResponse;
      }
    } catch (error) {}
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget captionWidget = VwFieldWidget.getLabel(
        widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        widget.readOnly);

    if (this.getFormResponse() != null) {
      return this.buildForm(this.getFormResponse()!);
    }

    return Column(
        key: widget.key,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          captionWidget,
          Flexible(
              fit: FlexFit.loose,
              child: Container(
                  key: widget.key,
                  child: Text("Error : Invalid FormResponseId ")))
        ]);
  }
}
