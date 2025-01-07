import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwcardparameter/vwcardparameter.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:matrixclient/modules/vwformpage/vwdefaultformpage.dart';
import 'package:matrixclient/modules/vwformpage/vwoldformpage.dart';
import 'package:matrixclient/modules/vwwidget/noderowviewer/noderowviewer.dart';
import 'package:matrixclient/modules/vwwidget/rowviewermaterial/vwcardparametermaterial/vwcardparametermaterial.dart';
import 'package:uuid/uuid.dart';

class VwFormSubmitRowViewer extends NodeRowViewer {
  VwFormSubmitRowViewer({
    required super.rowNode,
    required super.appInstanceParam,
    super.highlightedText,
    super.refreshDataOnParentFunction,
  });

  @override
  Widget build(BuildContext context) {
    String title = rowNode.displayName != null
        ? rowNode.displayName.toString()
        : rowNode.recordId;

    String date = rowNode.timestamp == null
        ? ""
        : VwDateUtil.indonesianShortFormatLocalTimeZone(
            rowNode.timestamp!.updated);

    InkWell cardTapper = InkWell(
      onTap: () {},
    );

    try {
      if (rowNode.nodeType == VwNode.ntnClassEncodedJson &&
          rowNode.content.classEncodedJson != null) {
        VwFormDefinition formDefinition =
            VwFormDefinition.fromJson(rowNode.content.classEncodedJson!.data!);
        title = formDefinition.formName;

        date = VwDateUtil.indonesianShortFormatLocalTimeZone(
            formDefinition.timestamp != null
                ? formDefinition.timestamp!.updated
                : DateTime.now());
        cardTapper = InkWell(
          onTap: () async {
            print("form tapped");

            VwRowData formResponse =
                VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                    formDefinition: formDefinition,
                    ownerUserId: this
                        .appInstanceParam
                        .loginResponse!
                        .userInfo!
                        .user
                        .recordId);
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwFormPage(
                        appInstanceParam: this.appInstanceParam,
                        formDefinitionFolderNodeId:
                            AppConfig.formDefinitionFolderNodeId,
                        isMultipageSections: true,
                        formDefinition: formDefinition,
                        formResponse: formResponse,
                        refreshDataOnParentFunction:
                            this.refreshDataOnParentFunction,
                      )),
            );
            Navigator.pop(context);
          },
        );
      }
    } catch (error) {
      print("Error catched on VwFormSubmitRowViewer=" + error.toString());
    }
    VwCardParameter cardParameter = VwCardParameter(isShowSubtitle: false);
    VwCardParameterMaterial cardParameterMaterial = VwCardParameterMaterial(
      key: Key(this.rowNode.recordId),
        timestamp: this.rowNode.timestamp,
        appInstanceParam: this.appInstanceParam,
        cardParameter: cardParameter,
        title: title,
        dateTime: date,
        cardTapper: cardTapper,


    );

    return cardParameterMaterial;

    Widget returnValue = Text(rowNode.recordId);

    Map<String, HighlightedWord> words = {};

    if (this.highlightedText != null) {
      words = {
        this.highlightedText!: HighlightedWord(
          onTap: () {
            print("this.highlightedText");
          },
          textStyle: TextStyle(backgroundColor: Colors.yellow),
        ),
      };
    }

    var f = NumberFormat.simpleCurrency(locale: 'id_ID');

    try {
      if (rowNode.content != null &&
          rowNode.content.linkbasemodel != null &&
          rowNode.content.linkbasemodel!.rendered != null &&
          rowNode.content.linkbasemodel!.rendered!.className ==
              "VwFormDefinition") {
        VwFormDefinition formParam = VwFormDefinition.fromJson(
            rowNode.content.linkbasemodel!.rendered!.data!);

        returnValue = this.rowWidget(formParam, context);
      } else if (rowNode.nodeType == VwNode.ntnClassEncodedJson &&
          rowNode.content.classEncodedJson != null) {
        VwFormDefinition formParam =
            VwFormDefinition.fromJson(rowNode.content.classEncodedJson!.data!);
        returnValue = this.rowWidget(formParam, context);
      }
    } catch (error) {
      returnValue = Text(rowNode.recordId + ': Error=' + error.toString());
    }

    return returnValue;
  }

  Widget rowWidget(VwFormDefinition formParam, BuildContext context) {
    Widget returnValue = Text(rowNode.recordId);
    try {
      Widget captionRow = Expanded(
          flex: 5,
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  formParam.formName,
                  overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                formParam.timestamp == null
                    ? Container()
                    : Text(
                        (formParam.timestamp == null
                            ? "-"
                            : DateFormat('dd-MMM-yyyy HH:mm', 'id_ID').format(
                                formParam.timestamp!.updated
                                    .subtract(Duration(days: 90)))),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
              ])));

      Widget iconRow = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Icon(
          Icons.file_open_outlined,
          color: Colors.purple,
        ),
      );

      Widget row = Container(
          padding: EdgeInsets.all(10),
          child: Row(children: [iconRow, captionRow]));

      returnValue = InkWell(
          onTap: () async {
            print("form tapped");
            //formParam.response.recordId = Uuid().v4();

            VwRowData formResponse =
                VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                    formDefinition: formParam,
                    ownerUserId: this
                        .appInstanceParam
                        .loginResponse!
                        .userInfo!
                        .user
                        .recordId);
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwFormPage(
                        formDefinitionFolderNodeId:
                            AppConfig.formDefinitionFolderNodeId,
                        appInstanceParam: this.appInstanceParam,
                        isMultipageSections: true,
                        formDefinition: formParam,
                        formResponse: formResponse,
                        refreshDataOnParentFunction:
                            this.refreshDataOnParentFunction,
                      )),
            );
            Navigator.pop(context);
          },
          child: row);
    } catch (error) {
      returnValue = Text(rowNode.recordId + ': Error=' + error.toString());
    }

    return returnValue;
  }
}
