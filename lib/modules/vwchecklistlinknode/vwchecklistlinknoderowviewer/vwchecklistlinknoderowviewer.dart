import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwusergroup/vwusergroup.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwform/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:vwform/modules/vwwidget/vwcheckbox/vwcheckbox.dart';
import 'package:vwutil/modules/util/collectionlistviewutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwCheckListLinkNodeRowViewer extends NodeRowViewer {
  VwCheckListLinkNodeRowViewer({
    super.key,
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
    this.unselectedConfirmation = false,
    this.isReadOnly = false,

  });
  final bool unselectedConfirmation;
  final bool isReadOnly;

  Widget openEditModeFormPage(
      {required BuildContext context,
      required VwFormDefinition formDefinition,
      required VwRowData formResponse}) {
    Widget captionRow = Expanded(
        flex: 5,
        child: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "[Respon] ${formDefinition.formName}",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: formResponse.timestamp == null
                  ? Container()
                  : Text(
                      "Update " +
                          VwDateUtil.indonesianFormatLocalTimeZone(
                              formResponse.timestamp!.updated),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    )),
        ])));

    Widget iconRow = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
              child: Icon(Icons.list_alt, color: Colors.purple, size: 20)),
          Icon(
            Icons.person_sharp,
            color: Colors.black,
            size: 20,
          )
        ],
      ),
    );

    Widget row = Container(
        padding: EdgeInsets.all(10),
        child: Row(children: [iconRow, captionRow]));

    String formResponseString = json.encode(formResponse.toJson());
    VwRowData shadowFormResponse =
        VwRowData.fromJson(json.decode(formResponseString));

    return VwFormPage(
        baseUrl: this.baseUrl,
        isShowSaveButton: false,
        isMultipageSections: true,
        formDefinitionFolderNodeId: AppConfig.formDefinitionFolderNodeId,
        appInstanceParam: appInstanceParam,
        formDefinition: formDefinition,
        formResponse: shadowFormResponse,
        refreshDataOnParentFunction: this.refreshDataOnParentFunction);
  }

  void _onRowTap(BuildContext context, VwRowData formResponse) {
    /*
    VwFormDefinition? formDefinition = formResponse.attachments ==
        null
        ? null
        : VwFormDefinitionUtil
        .extractFirstOccurenceFormDefinition(
        nodeContents: formResponse.attachments!);
*/

    VwFormDefinition? formDefinition = this.collectionListViewDefinition == null
        ? null
        : CollectionListViewUtil.getFormDefinition(
            this.collectionListViewDefinition!);
    Widget? formPage = formDefinition == null
        ? null
        : this.openEditModeFormPage(
            context: context,
            formDefinition: formDefinition,
            formResponse: formResponse);

    if (formPage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => formPage),
      );
    } else {
      print("VwCollectionListViewRoeViewer.onTap: There is no FormDefinition");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.rowNode.nodeType == VwNode.ntnTopNodeInsert) {
      if (this.topRowWidget == null) {
        return Container();
      } else {
        return this.topRowWidget!;
      }
    }

    if (this.rowNode.nodeType == VwNode.ntnLinkBaseModelCollection &&
        this.rowNode.content.linkbasemodel!.rendered!.className ==
            "VwUserGroup") {
      try {
        VwUserGroup userGroup = VwUserGroup.fromJson(
            this.rowNode.content.linkbasemodel!.rendered!.data!);

        print("Functional Role Id=" + userGroup.functionalRoleId.toString());
      } catch (error) {}
    }

    Widget returnValue = Container();
    try {
      VwRowData? formResponse =
          NodeUtil.getRowDataFromNodeContentRecordCollection(this.rowNode);
      InkWell cardTapper = InkWell(
        onTap: () {
          if (formResponse != null) {
            _onRowTap(context, formResponse);
          } else {
            print(
                "VwCollectionListViewRoeViewer.onTap: There is no FormResponse");
          }
        },
      );

      bool isSelected = false;

      for (int la = 0;
          this.selectedList != null && la < this.selectedList!.length;
          la++) {
        if (this.selectedList!.elementAt(la).nodeId == this.rowNode.recordId) {
          isSelected = true;
        }
      }

      Widget deleteWidget = VwCheckBox(
          unselectConfirmation: this.unselectedConfirmation,
          selectedIcon: this.selectedIcon,
          unselectedIcon: this.unselectedIcon,
          onTap: (selected) {
            if (this.isReadOnly == false && this.updateSelectedState != null) {
              this.updateSelectedState!(selected, this.rowNode);
            }
          },
          initialState: isSelected,
          key: super.key);

      returnValue = VwCardParameterNodeViewerMaterial(
        appInstanceParam: this.appInstanceParam,
        cardTapper: cardTapper,
        trailingWidget: this.isReadOnly == true ? null : deleteWidget,
        key: Key(this.rowNode.recordId),
        cardParameter: this.collectionListViewDefinition!.cardParameter,
        rowNode: this.rowNode,
      );
    } catch (error) {
      print("Error Catched on VwCollectionListViewRowViewer: " +
          error.toString());
      returnValue = Text("Error on Node: " + rowNode.recordId);
    }

    return returnValue;
  }
}
