import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontentutil.dart';
import 'package:matrixclient2base/modules/base/vwqueryresult/vwqueryresult.dart';
import 'package:matrixclient2base/modules/base/vwrenderednodepackage/vwrenderednodepackage.dart';
import 'package:matrixclient2base/modules/base/vwuser/vwuser.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwform/modules/vwwidget/vwsimpledropdown3/vwsimpledropdown3.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwFormResponseViewer extends StatefulWidget {
  VwFormResponseViewer({
    required this.appInstanceParam,
    required this.formResponsesNode,
    required this.formParam,
    this.initFormResponseId,
  });
  final VwAppInstanceParam appInstanceParam;
  final VwRenderedNodePackage formResponsesNode;
  final VwFormDefinition formParam;
  String? initFormResponseId;

  static VwQueryResult createQueryResultFromNodeList({required  List<VwNode> nodes,
    required String tagLinkBaseModelFormDefinition
  }) {
    VwQueryResult returnValue = VwQueryResult(rows: <VwRowData>[]);

    for (int la = 0; la < nodes.length; la++) {
      VwNode currentNode = nodes.elementAt(la);
      try {
        if (currentNode.nodeType == VwNode.ntnLinkRowCollection &&
            currentNode.content.linkRowCollection != null &&
            currentNode.content.linkRowCollection!.rendered != null) {
          VwRowData formResponse =
              currentNode.content.linkRowCollection!.rendered!;

          if (formResponse.attachments != null) {
            VwNodeContent? formDefinitionNodeContent =
                VwNodeContentUtil.getAttachmentByTag(
                    tag: tagLinkBaseModelFormDefinition,
                    attachments: formResponse.attachments!);

            if (formDefinitionNodeContent != null &&
                formDefinitionNodeContent.linkbasemodel != null &&
                formDefinitionNodeContent.linkbasemodel!.rendered != null) {
              VwFormDefinition formDefinition = VwFormDefinition.fromJson(
                  formDefinitionNodeContent
                      .linkbasemodel!.rendered!.data!);


              VwUser ? creatorUser;

              if(formResponse.creatorUserLinkNode!=null && formResponse.creatorUserLinkNode!.cache!=null)
                {
                  try {

                    creatorUser = VwUser.fromJson(formResponse.creatorUserLinkNode!.cache!.node!.content.linkbasemodel!.rendered!.data!);
    }
    catch(error)
    {

    }
                }



              String? displayName ;

              String? userName ;
              String? email ;

              if(creatorUser!=null)
                {
                 displayName =creatorUser.displayname;
                 userName = creatorUser.username;
                 email = creatorUser.email;
                }

              VwFieldValue keyFieldvalue = VwFieldValue(
                  fieldName: "key", valueString: formResponse.recordId);
              VwFieldValue displayFieldvalue = VwFieldValue(
                  fieldName: "display",
                  valueString: userName! +
                      "/" +
                      email! +
                      " (" +
                      (formResponse.timestamp==null?"-": DateFormat('dd-MMM-yyyy HH:mm', 'id_ID').format(
                          formResponse.timestamp!.created
                              .subtract(Duration(days: 90)))) +
                      " )");

              VwRowData rowData = VwRowData(
                  timestamp: VwDateUtil.nowTimestamp(),
                  recordId: Uuid().v4(),
                  fields: [keyFieldvalue, displayFieldvalue]);

              returnValue.rows.add(rowData);
            }
          }
        }
      } catch (error) {
        print("Error catched on createQueryResultFromNodeList" +
            error.toString());
      }
    }

    return returnValue;
  }

  _VwFormResponseViewer createState() => _VwFormResponseViewer();
}

class _VwFormResponseViewer extends State<VwFormResponseViewer> {
  VwRowData? selectedFormResponse;
  VwFormDefinition? selectedFormDefinition;
  late int selectedComboBoxIndex;
  late VwQueryResult choices;
  late bool flipForm;

  @override
  void initState() {
    super.initState();
    flipForm = false;
    choices = VwQueryResult(rows: []);
    if (this.widget.formResponsesNode.renderedNodeList != null) {
      choices = VwFormResponseViewer.createQueryResultFromNodeList(
          nodes:  this.widget.formResponsesNode.renderedNodeList!,
          tagLinkBaseModelFormDefinition: this.widget.appInstanceParam.baseAppConfig.generalConfig.tagLinkBaseModelFormDefinition
      );
    }
    selectedComboBoxIndex = -1;
  }

  void onDropdown3Selected(
      {required int selectedIndex,
      String? keyValue,
      String? displayValue,
      VwRowData? rowData}) {
    selectedComboBoxIndex = selectedIndex;
    selectedFormResponse = null;
    selectedFormDefinition = null;
    if (selectedIndex >= 0 &&
        this.widget.formResponsesNode.renderedNodeList != null &&
        this.widget.formResponsesNode.renderedNodeList!.length > 0) {
      VwNode selectedNode = this
          .widget
          .formResponsesNode
          .renderedNodeList!
          .elementAt(selectedIndex);

      if (selectedNode.content.linkRowCollection != null &&
          selectedNode.content.linkRowCollection!.rendered != null &&
          selectedNode.content.linkRowCollection!.rendered!.attachments !=
              null) {
        flipForm = !flipForm;
        VwRowData formResponse =
            selectedNode.content.linkRowCollection!.rendered!;

        VwNodeContent? nodeContent = VwNodeContentUtil.getAttachmentByTag(
            tag: this.widget.appInstanceParam.baseAppConfig.generalConfig.tagLinkBaseModelFormDefinition,
            attachments: formResponse.attachments!);

        if (nodeContent != null) {
          VwFormDefinition formDefinition = VwFormDefinition.fromJson(
              nodeContent.linkbasemodel!.rendered!.data!);

          selectedFormResponse = formResponse;
          selectedFormDefinition = formDefinition;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? key;

    if (this.selectedComboBoxIndex >= 0) {
      key = choices.rows
          .elementAt(this.selectedComboBoxIndex)
          .getFieldByName("key")!
          .valueString;
    }

    Widget responseCombo = VwSimpleDropdown3(
        choices: choices,
        initialChoiceKeyValue: key,
        callback: onDropdown3Selected);

    if (flipForm == false) {
      Widget formPage1 = this.selectedFormDefinition != null &&
              this.selectedFormResponse != null
          ? VwFormPage(
        appInstanceParam:  this.widget.appInstanceParam,
              isShowAppBar: false,
              formDefinitionFolderNodeId: this.widget.appInstanceParam.baseAppConfig.generalConfig.formDefinitionFolderNodeId,

              formResponse: this.selectedFormResponse!,
              formDefinition: this.selectedFormDefinition!,
              )
          : Container();
      return Scaffold(
        appBar: AppBar(
            title: Text(this.choices.rows.length.toString() + " respon")),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: responseCombo))
            ]),
            Expanded(child: formPage1)
          ],
        ),
      );
    } else {
      Widget formPage2 = this.selectedFormDefinition != null &&
              this.selectedFormResponse != null
          ? Container(
              child: VwFormPage(
                  isShowAppBar: false,
                  formDefinitionFolderNodeId:
                  this.widget.appInstanceParam.baseAppConfig.generalConfig.formDefinitionFolderNodeId,
                  appInstanceParam: this.widget.appInstanceParam,
                  formResponse: this.selectedFormResponse!,
                  formDefinition: this.selectedFormDefinition!,
                  ))
          : Container();
      return Scaffold(
        appBar: AppBar(
            title: Text(this.choices.rows.length.toString() + " respon")),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: responseCombo))
            ]),
            Expanded(child: formPage2)
          ],
        ),
      );
    }


  }
}
