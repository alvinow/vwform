import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwwidget/vwsimpledropdown/vwsimpledropdown.dart';
import 'dart:convert';
import 'package:matrixclient/modules/vwwidget/vwsimpledropdown2/vwsimpledropdown2.dart';

class VwSimpleDropDownFieldWidget extends StatefulWidget {
  const VwSimpleDropDownFieldWidget(
      {Key? key,
      required this.field,
        this.readOnly=false,
      required this.formField,
      this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;

  @override
  _VwSimpleDropDownFieldWidgetState createState() =>
      _VwSimpleDropDownFieldWidgetState();
}

class _VwSimpleDropDownFieldWidgetState
    extends State<VwSimpleDropDownFieldWidget> {
  List<String> _buildChoices() {
    List<String> choices = <String>[];

    try {
      if (this.widget.formField.fieldUiParam.parameter != null) {
        for (int la = 0;
            la < this.widget.formField.fieldUiParam.parameter!.rows.length;
            la++) {
          VwRowData currentRow =
              this.widget.formField.fieldUiParam.parameter!.rows.elementAt(la);

          VwFieldValue? choiceValueField =
              currentRow.getFieldByName("choiceValue");
          if (choiceValueField != null &&
              choiceValueField.valueString != null) {
            choices.add(choiceValueField.valueString!);
          }
        }
      }
    } catch (error) {}

    return choices;
  }



  @override
  Widget build(BuildContext context) {
    List<String> choices = this._buildChoices();
    int initialChoice = _getSelectedIndex();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      VwFieldWidget.getLabel(widget.field,this.widget.formField, DefaultTextStyle.of(context).style,widget.readOnly),
      Container(
        width: 200,
          height:10,
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            VwSimpleDropdown2(
              isEnabledExpanded: false,
                hint: this.widget.formField.fieldUiParam.hint,
                caption: this.widget.formField.fieldUiParam.caption,
                choices: choices,
                initialChoice: initialChoice,
                callback: this._implementVwSimpleDropdownCallback)

          ]))
    ]);
  }

  int _getSelectedIndex() {
    int returnValue = -1;

    try {
      if (this.widget.formField.fieldUiParam.parameter != null) {
        for (int lrow = 0;
            lrow < this.widget.formField.fieldUiParam.parameter!.rows.length;
            lrow++) {
          VwRowData currentRow = this
              .widget
              .formField
              .fieldUiParam
              .parameter!
              .rows
              .elementAt(lrow);
          List<VwFieldValue> searchResult = currentRow.getFieldBySearchString(
              'choiceValue', this.widget.field.valueString!);

          if (searchResult.length > 0) {
            returnValue = lrow;
            break;
          }
        }
      }
    } catch (error) {}

    return returnValue;
  }

  void _implementVwSimpleDropdownCallback(
      int selectedIndex, String? selectedvalue) {
    Map<String, dynamic> oldValueDyn = this.widget.field.toJson();
    String oldValueString = json.encode(oldValueDyn);
    VwFieldValue oldValue = VwFieldValue.fromJson(json.decode(oldValueString));

    this.widget.field.valueString = selectedvalue;

    this.widget.onValueChanged!(this.widget.field, oldValue, false);

/*
    this.widget.field.fieldValue.setNewValue(selectedvalue);
    if (this.widget.fieldCallback != null) {
      this.widget.fieldCallback!(
          this.widget.field, this.widget.formFieldDef, true);
    } else {
      setState(() {});
    }

 */
  }
}
