import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/colurutil.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/util/vwrowdatautil.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';

class VwFormEditorPage extends StatefulWidget {
  final VwAppInstanceParam appInstanceParam;
  final VwRowData formResponse;
  final VwNode formDefinitionNode;
  final VwFormValidationResponse? formValidationResponse;
  final bool showBackArrow;
  final VwRowData? presetValues;
  final double formWidth;
  Color? backgroundColour;

  VwFormEditorPageState createState() => VwFormEditorPageState();

  VwFormEditorPage(
      {super.key,
      required this.appInstanceParam,
      this.formValidationResponse,
      required this.formResponse,
      required this.formDefinitionNode,
      this.showBackArrow = false,
      this.presetValues,
      this.formWidth = 600,
      this.backgroundColour
      }){
    if(this.backgroundColour==null)
    {
      backgroundColour= ColorUtil.parseColor("ffefebf7");
    }
  }
}

class VwFormEditorPageState extends State<VwFormEditorPage> {
  late VwRowData initialFormResponse;
  VwFormDefinition? formDefinition;

  void initFormDefinition() {
    try {
      this.formDefinition =
          NodeUtil.extractFormDefinitionFromNode(widget.formDefinitionNode);
    } catch (error) {}
  }

  void initFormResponse() {
    widget.formResponse.collectionName = this.formDefinition != null &&
            this.formDefinition!.formResponseSyncCollectionName == null
        ? this.formDefinition!.recordId
        : this.formDefinition!.formResponseSyncCollectionName!;
    widget.formResponse.formDefinitionId = this.formDefinition!.recordId;

    VwRowData? lTryInitFormResponse =
        VwRowDataUtil.copyRowDataInstance(widget.formResponse);

    if (lTryInitFormResponse == null) {
      initialFormResponse =
          VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
              formDefinition: this.formDefinition!,
              ownerUserId: widget
                  .appInstanceParam.loginResponse!.userInfo!.user.recordId);
    } else {
      initialFormResponse = lTryInitFormResponse;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.initFormDefinition();
    this.initFormResponse();

    if (this.widget.presetValues != null) {
      VwFormDefinition? formDefinition =
          NodeUtil.extractFormDefinitionFromNode(widget.formDefinitionNode);

      if (formDefinition != null) {
        VwRowDataUtil.applyPresetValue(
            targetFormResponse: widget.formResponse,
            presetValues: widget.presetValues!,
            formDefinition: formDefinition);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      //double formWidth = 600;

      double margin = 25;

      if (constraint.maxWidth > widget.formWidth) {
        margin = 0.5 * (constraint.maxWidth - widget.formWidth);
      }

      if (this.formDefinition != null) {
        return Scaffold(
            backgroundColor: widget.backgroundColour,
            key: widget.key,
            appBar: widget.showBackArrow == true
                ? AppBar(
                    title: Text(this.formDefinition!.formName),
                    automaticallyImplyLeading: true,
                    backgroundColor: Colors.white,
                  )
                : null,
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(margin, 0, margin, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 300),
                child: VwForm(
                    fieldBoxDecoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    backGroundColor: widget.backgroundColour!,
                    key: Key(widget.formResponse.recordId),
                    formValidationResponse: widget.formValidationResponse,
                    appInstanceParam: widget.appInstanceParam,
                    initFormResponse: widget.formResponse,
                    formDefinition: this.formDefinition!),
              ),
            ));
      } else {
        return Scaffold(
          key: widget.key,
          body: Text(
              "Error: Form Definition is not found. Please contact the Administrator"),
        );
      }
    });
  }
}
