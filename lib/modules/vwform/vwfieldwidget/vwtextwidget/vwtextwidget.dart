import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';

class VwTextWidget extends StatelessWidget {
  const VwTextWidget(
      {Key? key,
      required this.field,
      required this.formField,
      this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;

  TextInputType getKeyboardType() {
    TextInputType returnValue = TextInputType.text;

    return returnValue;
  }

  List<TextInputFormatter> getInputFormatters() {
    List<TextInputFormatter> returnValue = <TextInputFormatter>[];

    return returnValue;
  }

  String? getInitialValue() {
    String returnValue = this.field.getValueAsString();
    /*
    String? returnValue = this.field.valueString == null
        ? ''
        : this.field.valueString.toString();

     */

    return returnValue;
  }

  TextEditingController? getTextEditingController() {
    TextEditingController? returnValue;

    return returnValue;
  }

  bool _getIsObscureText() {
    return this.formField.fieldUiParam.uiTypeId == 'textpasswordField' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();


    /*
      returnValue = Container(
        color: Colors.green,
        child: Text(this.formField.caption,style: TextStyle(fontSize: 12),)
      );*/
    if (this.getInitialValue()!.length > 0) {
      returnValue = Container(
        child: TextFormField(
          minLines: 1,
          maxLines: 3,
          obscureText: this._getIsObscureText(),
          obscuringCharacter: '*',
          autocorrect: false,
          enableSuggestions: false,
          readOnly: true,
          onChanged: this._onTextFieldValueChanged,
          inputFormatters: this.getInputFormatters(),
          keyboardType: this.getKeyboardType(),
          controller: this.getTextEditingController(),
          initialValue: this.getInitialValue(),
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
          decoration: InputDecoration(
            //fillColor: Colors.grey[10],
            //filled: true,

            border: InputBorder.none,
            labelStyle: const TextStyle(color: Colors.red, fontSize: 16),
            contentPadding: const EdgeInsets.all(0),
            labelText: this.formField.fieldUiParam.caption,
            focusColor: Colors.orange,
            isDense: true,
          ),
        ),
      );
    }


    return returnValue;
  }

  void _onTextFieldValueChanged(String value) {
    if (this.onValueChanged != null) {
      VwFieldValue oldValue = VwFieldValue.clone(this.field);
      this.field.valueString = value;
      this.onValueChanged!(this.field, oldValue, false);
    }
  }
}
