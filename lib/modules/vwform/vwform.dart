import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwcontentcontext/vwcontentcontext.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponse/vwformfieldvalidationresponse.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponseutil.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';

typedef VwFormValueChanged = void Function(
    VwFieldValue, VwFieldValue, VwRowData, bool);

typedef GetCurrentFormResponseFunction = VwRowData Function();
typedef GetCurrentFormDefinitionFunction = VwFormDefinition Function();
typedef RefreshDataOnParentFunction = void Function();
typedef BuildWidgetWithContextFunction = Widget Function(
    GlobalKey<ScaffoldState>, BuildContext);

typedef SyncNodeToParentFunction = void Function(VwNode node);

typedef CommandToParentFunction = void Function(VwRowData callParameter);
typedef SyncLinkNodeListToParentFunction = void Function(
    List<VwLinkNode> linkNodeList);

typedef NodeRowViewerFunction = Widget Function(
    {required VwNode renderedNode,
    required BuildContext context,
    required int index,
    String? highlightedText,
    RefreshDataOnParentFunction? refreshDataOnParentFunction,
    Widget? topRowWidget,
    CommandToParentFunction ? commandToParentFunction});

class VwForm extends StatefulWidget {
  const VwForm(
      {required super.key,
        required this.appInstanceParam,
        required this.initFormResponse,
        required this.formDefinition,
        this.onFormValueChanged,
        this.boxDecoration,
        this.width = 300,
        this.sectionIndex,
        this.formValidationResponse,
        this.backGroundColor = Colors.grey,

        this.fieldBoxDecoration = const BoxDecoration(
          color: Colors.white,

        )});
  final VwAppInstanceParam appInstanceParam;
  final VwFormDefinition formDefinition;
  final VwRowData initFormResponse;
  final VwFormValueChanged? onFormValueChanged;
  final double width;
  final BoxDecoration? boxDecoration;

  final VwFormValidationResponse? formValidationResponse;
  final Color backGroundColor;

  final int? sectionIndex;

  final BoxDecoration fieldBoxDecoration;

  @override
  VwFormState createState() => VwFormState();
}

class VwFormState extends State<VwForm> {
  late VwRowData initFormResponse;

  VwRowData implementGetCurrentFormResponseFunction() {
    return this.initFormResponse;
  }

  VwFormDefinition implementGetCurrentFormDefinitionFunction() {
    return this.widget.formDefinition;
  }

  @override
  void initState() {
    super.initState();
    this.initFormResponse = widget.initFormResponse;
    if (widget.formDefinition.initialFormResponse != null) {
      VwFormState.prepareInitialValue(
          includedInFormDefinition: widget.formDefinition.initialFormResponse!,
          initFormResponse: this.initFormResponse);
    }
  }

  static void prepareInitialValue(
      {required VwRowData includedInFormDefinition,
        required VwRowData initFormResponse}) {
    /*
      static const String vatNull = 'vatNull';
  static const String vatString = 'vatString';
  static const String vatNumber = 'vatNumber';
  static const String vatDateTime = 'vatDateTime';
  static const String vatDateOnly = 'vatDateOnly';
  static const String vatTimeOnly = 'vatTimeOnly';
  static const String vatBoolean = 'vatBoolean';
  static const String vatObject = 'vatObject';
  static const String vatClassEncodedJson = 'vatClassEncodedJson';
  static const String vatFieldFileStorage = 'vatFieldFileStorage';
  static const String vatValueRowData = 'vatValueRowData';
  static const String vatValueRowDataList = 'vatValueRowDataList';
  static const String vatValueStringList = "vatValueStringList";
  static const String vatValueFieldValueList = "vatValueFieldValueList";
  static const String vatValueFormDefinition='vatValueFormDefinition';
  static const String vatValueLinkNode="vatValueLinkNode";
  static const String vatValueLinkNodeList="vatValueLinkNodeList";
     */
    try {
      if (initFormResponse.fields != null) {
        for (int la = 0; la < initFormResponse.fields!.length; la++) {
          try {
            VwFieldValue currentInitFormResponseFieldValue =
            initFormResponse.fields!.elementAt(la);

            String currentInitFormResponseFieldName =
                currentInitFormResponseFieldValue.fieldName;

            VwFieldValue? includedInFormDefinitionFieldValue =
            includedInFormDefinition
                .getFieldByName(currentInitFormResponseFieldName);

            if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatString &&
                currentInitFormResponseFieldValue.valueString == null) {
              currentInitFormResponseFieldValue.valueString =
                  includedInFormDefinitionFieldValue?.valueString;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatNumber &&
                currentInitFormResponseFieldValue.valueNumber == null) {
              currentInitFormResponseFieldValue.valueNumber =
                  includedInFormDefinitionFieldValue?.valueNumber;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatDateTime &&
                currentInitFormResponseFieldValue.valueDateTime == null) {
              currentInitFormResponseFieldValue.valueDateTime =
                  includedInFormDefinitionFieldValue?.valueDateTime;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatDateOnly &&
                currentInitFormResponseFieldValue.valueDateTime == null) {
              currentInitFormResponseFieldValue.valueDateTime =
                  includedInFormDefinitionFieldValue?.valueDateTime;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatTimeOnly &&
                currentInitFormResponseFieldValue.valueDateTime == null) {
              currentInitFormResponseFieldValue.valueDateTime =
                  includedInFormDefinitionFieldValue?.valueDateTime;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatBoolean &&
                currentInitFormResponseFieldValue.valueBoolean == null) {
              currentInitFormResponseFieldValue.valueBoolean =
                  includedInFormDefinitionFieldValue?.valueBoolean;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatObject &&
                currentInitFormResponseFieldValue.value == null) {
              currentInitFormResponseFieldValue.value =
                  includedInFormDefinitionFieldValue?.value;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatClassEncodedJson &&
                currentInitFormResponseFieldValue.valueClassEncodedJson ==
                    null) {
              currentInitFormResponseFieldValue.valueClassEncodedJson =
                  includedInFormDefinitionFieldValue?.valueClassEncodedJson;
            } else if (currentInitFormResponseFieldValue.valueTypeId ==
                VwFieldValue.vatFieldFileStorage &&
                currentInitFormResponseFieldValue.valueFieldFileStorage ==
                    null) {
              currentInitFormResponseFieldValue.valueFieldFileStorage =
                  includedInFormDefinitionFieldValue?.valueFieldFileStorage;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatValueRowData &&
                currentInitFormResponseFieldValue.valueRowData == null) {
              currentInitFormResponseFieldValue.valueRowData =
                  includedInFormDefinitionFieldValue?.valueRowData;
            } else if (currentInitFormResponseFieldValue.valueTypeId ==
                VwFieldValue.vatValueRowDataList &&
                currentInitFormResponseFieldValue.valueRowDataList == null) {
              currentInitFormResponseFieldValue.valueRowDataList =
                  includedInFormDefinitionFieldValue?.valueRowDataList;
            } else if (currentInitFormResponseFieldValue.valueTypeId == VwFieldValue.vatValueStringList &&
                currentInitFormResponseFieldValue.valueStringList == null) {
              currentInitFormResponseFieldValue.valueStringList =
                  includedInFormDefinitionFieldValue?.valueStringList;
            } else if (currentInitFormResponseFieldValue.valueTypeId ==
                VwFieldValue.vatValueFieldValueList &&
                currentInitFormResponseFieldValue.valueFieldValueList == null) {
              currentInitFormResponseFieldValue.valueFieldValueList =
                  includedInFormDefinitionFieldValue?.valueFieldValueList;
            }  else if (includedInFormDefinitionFieldValue != null) {
              if (currentInitFormResponseFieldValue.valueTypeId ==
                  VwFieldValue.vatValueLinkNode &&
                  currentInitFormResponseFieldValue.valueLinkNode == null) {
                currentInitFormResponseFieldValue.valueLinkNode =
                    includedInFormDefinitionFieldValue.valueLinkNode;
              } else if (currentInitFormResponseFieldValue.valueTypeId ==
                  VwFieldValue.vatValueLinkNodeList &&
                  currentInitFormResponseFieldValue.valueLinkNodeList == null) {
                currentInitFormResponseFieldValue.valueLinkNodeList =
                    includedInFormDefinitionFieldValue.valueLinkNodeList;
              }
            }
          } catch (error) {}
        }
      } else if (includedInFormDefinition.fields != null) {
        initFormResponse.fields = includedInFormDefinition.fields;
      }
    } catch (error) {
      print(
          "Error Catched on  VwForm.prepareInitialValue :" + error.toString());
    }
  }

  void _implementOnFieldWidgetChanged(
      VwFieldValue newField, VwFieldValue oldField, bool doSetState) {
    /*
    print("FieldName " +
        newField.fieldName +
        " is changed to: " +
        newField.getValueAsString() +
        " (originally: ${oldField.getValueAsString()} )");*/

    /*
    if (this.widget.onFormValueChanged != null) {
      this.widget.onFormValueChanged!(
          newField, oldField, currentFormResponse, false);
    }*/

    if (this.widget.onFormValueChanged != null) {
      this.widget.onFormValueChanged!(newField, oldField,
          this.implementGetCurrentFormResponseFunction(), false);
    }

    if (doSetState) {
      setState(() {});
    }
  }

  List<Widget> _buildSections() {
    List<Widget> sectionsWidget = <Widget>[];

    if (widget.sectionIndex != null) {
      sectionsWidget
          .add(this._buildSectionByIndex(sectionIndex: widget.sectionIndex!));
    } else {
      for (int la = 0; la < widget.formDefinition.sections.length; la++) {
        sectionsWidget.add(_buildSectionByIndex(sectionIndex: la));
      }
    }

    return sectionsWidget;
  }

  Widget _buildSectionByIndex({required int sectionIndex}) {
    Widget sectionWidget = Container();
    try {
      if (sectionIndex < widget.formDefinition.sections.length) {
        VwSectionFormDefinition sectionFormParam =
        this.widget.formDefinition.sections.elementAt(sectionIndex);

        List<Widget> rowsWidgets = <Widget>[];

        Widget sectionName = sectionFormParam.name == null
            ? Container()
            : Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  sectionFormParam.name!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );

        Widget? descriptionWidget = sectionFormParam.description == null
            ? Container()
            : Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  sectionFormParam.description!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );

        Widget sectionTitle = sectionFormParam.name == null
            ? Container()
            : Container(
            decoration: widget.fieldBoxDecoration,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [sectionName, descriptionWidget],
            ));

        rowsWidgets.add(sectionTitle);

        for (int ta = 0; ta < sectionFormParam.formFields.length; ta++) {
          List<Widget> fieldsWidgets = <Widget>[];

          VwFormField currentFormField =
          sectionFormParam.formFields.elementAt(ta);

          if (currentFormField.fieldUiParam.uiTypeId ==
              VwFieldUiParam.uitHidden) {
            //do nothing
          } else {
            Map<String, dynamic> currentFormFieldDyn =
            currentFormField.toJson();
            String currentFormFieldString = json.encode(currentFormFieldDyn);

            VwFormField newCurrentFormField =
            VwFormField.fromJson(json.decode(currentFormFieldString));

            //modding based on Form
            if (this.widget.formDefinition.isReadOnly == true) {
              newCurrentFormField.fieldUiParam.isReadOnly = true;
            }

            VwFieldValue? initialValue = this
                .widget
                .initFormResponse
                .getFieldByName(newCurrentFormField.fieldDefinition.fieldName);

            if (initialValue == null) {
              initialValue = VwFieldValue(
                  fieldName: newCurrentFormField.fieldDefinition.fieldName,
                  valueTypeId: newCurrentFormField.fieldDefinition.valueTypeId);
              if (this.initFormResponse.fields == null) {
                this.initFormResponse.fields = [];
              }
              this.initFormResponse.fields!.add(initialValue);
            }

            if (initialValue != null) {
              VwFormFieldValidationResponse? formFieldValidationResponse;
              if (this.widget.formValidationResponse != null) {
                formFieldValidationResponse = VwFormValidationResponseUtil
                    .getFormFieldValidationResponseByFieldName(
                    formValidationResponse:
                    this.widget.formValidationResponse!,
                    fieldName:
                    newCurrentFormField.fieldDefinition.fieldName);
              }

              if (this.initFormResponse.syncFormResponseList == null) {
                this.initFormResponse.syncFormResponseList = [];
              }
              initialValue.syncFormResponseList =
                  this.initFormResponse.syncFormResponseList;
              initialValue.renderedFormResponseList =
                  this.initFormResponse.renderedFormResponseList;

              Widget currentFieldWidget = Container(
                  decoration: widget.fieldBoxDecoration,
                  padding: EdgeInsets.fromLTRB(12, 0, 8, 10),
                  margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                  child: VwFieldWidget(
                    key: Key(newCurrentFormField.fieldDefinition.fieldName),
                    parentRef: this.initFormResponse.collectionName == null
                        ? null
                        : VwLinkNode(
                      nodeType: VwNode.ntnLinkRowCollection,
                      nodeId: this.initFormResponse.recordId,
                      contentContext: VwContentContext(
                          collectionName:
                          this.initFormResponse.collectionName!,
                          recordId: this.initFormResponse.recordId),
                    ),
                    appInstanceParam: this.widget.appInstanceParam,
                    readOnly: this.widget.formDefinition.isReadOnly,
                    formFieldValidationResponse: formFieldValidationResponse,
                    field: initialValue,
                    formField: newCurrentFormField,
                    onValueChanged: this._implementOnFieldWidgetChanged,
                    getCurrentFormResponseFunction:
                    this.implementGetCurrentFormResponseFunction,
                    getCurrentFormDefinitionFunction:
                    this.implementGetCurrentFormDefinitionFunction,
                  ));

              if (currentFormField.fieldUiParam.uiTypeId ==
                  VwFieldUiParam.uitFormPageByLinkFormDefinition ||
                  currentFormField.fieldUiParam.uiTypeId ==
                      VwFieldUiParam.uitFormPageByLocalFieldSource ||
                  currentFormField.fieldUiParam.uiTypeId ==
                      VwFieldUiParam.uitFormPageByStaticFormDefinition) {
                fieldsWidgets.add(Flexible(fit: FlexFit.loose, child: currentFieldWidget));
              } else {
                fieldsWidgets.add(
                    Flexible(fit: FlexFit.tight, child: currentFieldWidget));
              }

              Widget rowWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: fieldsWidgets);

              rowsWidgets.add(rowWidget);
            }
          }
        }

        //rowsWidgets.add(Container(height: 20));

        sectionWidget = Container(
            color: this.widget.backGroundColor,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowsWidgets));
      }
    } catch (error) {
      print("Error Catch when building SectionWidget: " + error.toString());
    }

    return sectionWidget;
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();

    List<Widget> formSections = this._buildSections();

    returnValue = Column(
      key: this.widget.key,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: formSections,
    );

    return returnValue;
  }
}