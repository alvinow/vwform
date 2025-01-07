import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formula_parser/formula_parser.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwutil/modules/util/nodeutil.dart';


class VwCalculatedNumberFieldWidget extends StatefulWidget {
  const VwCalculatedNumberFieldWidget(
      {Key? key,
      required this.field,
      this.readOnly = true,
      required this.formField,
      this.onValueChanged,
      required this.getCurrentFormResponseFunction})
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;

  VwCalculatedNumberFieldWidgetState createState() =>
      VwCalculatedNumberFieldWidgetState();
}

class VwCalculatedNumberFieldWidgetState
    extends State<VwCalculatedNumberFieldWidget> {
  late TextEditingController textEditingController;
  late Key textFormFieldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.textFormFieldKey = UniqueKey();
    this.initTextEditingController();
  }

  static int getParsedFieldCount() {
    int returnValue = 0;

    return returnValue;
  }

  static VwFieldValue? getParsedFieldValueByFieldFormula(
      {required Map<String, dynamic> fieldFormula,
      required VwRowData formResponse}) {
    VwFieldValue? returnValue;
    try {
      if (fieldFormula['fieldName'] != null) {
        if (fieldFormula['fieldName'] is List) {
          VwRowData currentFormResponse = formResponse;
          //VwFieldValue? currentFieldValue;
          for (int la = 0; la < fieldFormula['fieldName'].length; la++) {
            String fieldName = fieldFormula['fieldName'].elementAt(la);
            returnValue = currentFormResponse.getFieldByName(fieldName);

            if ((la + 1) < fieldFormula['fieldName'].length) {
              currentFormResponse =
                  NodeUtil.getNode(linkNode: returnValue!.valueLinkNode!)!
                      .content!
                      .rowData!;
            }
          }
        } else if (fieldFormula['fieldName'] is String) {
          returnValue = formResponse.getFieldByName(fieldFormula['fieldName']);
        }
      }
    } catch (error) {
      print("Error catched on " + error.toString());
    }

    return returnValue;
  }

  static double? getParsedNumberValue(
      {required String formula, required VwRowData formResponse}) {
    /*

    example parsed formula

    {fieldName:['unitPrice']}*{fieldName:['quantity']}



     */
    double? returnValue;
    try {
      String parseFormula = formula;
      int currentIndex = -1;
      Map<String, dynamic> formulaFieldValue = {};
      int beginCurrentObject = parseFormula.indexOf('{');
      int endCurrentObject = parseFormula.indexOf('}');
      while (parseFormula.indexOf('{') >= 0 &&
          parseFormula.indexOf('}') > parseFormula.indexOf('{')) {
        int beginCurrentObject = parseFormula.indexOf('{');
        int endCurrentObject = parseFormula.indexOf('}') + 1;

        String currentParseFieldFormula =
            parseFormula.substring(beginCurrentObject, endCurrentObject);
        Map<String, dynamic> currentParseFieldFieldFormulaObject =
            jsonDecode(currentParseFieldFormula);

        VwFieldValue? currentFieldValue = VwCalculatedNumberFieldWidgetState
            .getParsedFieldValueByFieldFormula(
                fieldFormula: currentParseFieldFieldFormulaObject,
                formResponse: formResponse);
        currentIndex++;
        String indexFieldName = '#a' + currentIndex.toString();
        parseFormula = parseFormula.replaceRange(
            beginCurrentObject, endCurrentObject, indexFieldName);

        if (currentFieldValue != null &&
            currentFieldValue.valueNumber != null) {
          formulaFieldValue[indexFieldName] = currentFieldValue!.valueNumber;
        }
      }

      FormulaParser formulaParser =
          FormulaParser(parseFormula, formulaFieldValue);

      if (formulaParser.error == false) {
        returnValue = formulaParser.parse['value'];
      }
    } catch (error) {
      print("Error catched on getParsedNumberValue: " + error.toString());
    }

    return returnValue;
  }

  double? getCalculatedNumberFieldValue() {
    double? returnValue;

    String? formula =
        this.widget.formField.fieldUiParam.formulaCalculatedNumberField;
    if (formula != null) {
      returnValue = VwCalculatedNumberFieldWidgetState.getParsedNumberValue(
          formula: formula,
          formResponse: this.widget.getCurrentFormResponseFunction());
    }

    return returnValue;
  }

  void initTextEditingController() {
    this.textEditingController = TextEditingController();
  }

  String getTextValue() {
    String returnValue = '0';

    try {
      NumberFormat formatter = NumberFormat.decimalPatternDigits(
          decimalDigits: this
              .widget
              .formField
              .fieldUiParam
              .fieldDisplayFormat!
              .numberTextInputFormatter!
              .decimalDigits!,
          locale:
              this.widget.formField.fieldUiParam.fieldDisplayFormat!.locale);

      returnValue = formatter.format(this.getCalculatedNumberFieldValue());
    } catch (error) {}

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    this.textEditingController.text = this.getTextValue();
    this.widget.field.valueNumber=getCalculatedNumberFieldValue();

    Widget captionWidget = VwFieldWidget.getLabel(
        widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        widget.readOnly);

    Widget textFormFieldWidget = TextFormField(
      readOnly: widget.readOnly,
      key: this.textFormFieldKey,
      controller: this.textEditingController,
    );

    Widget returnValue = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        captionWidget,
        SizedBox(
          height: 8,
        ),
        textFormFieldWidget,
      ],
    );

    return returnValue;
  }
}
