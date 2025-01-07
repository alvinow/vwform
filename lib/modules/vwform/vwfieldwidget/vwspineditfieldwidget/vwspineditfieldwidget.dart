import 'package:flutter/cupertino.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'dart:convert';

import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';




class VwSpinEditFieldWidget extends StatelessWidget {
  const VwSpinEditFieldWidget(
      {Key? key,
      required this.field,
      required this.formField,
      this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final VwFormField formField;
  final VwFieldWidgetChanged ? onValueChanged;

  @override
  Widget build(BuildContext context) {
    double currentValue = 0;

    if (this.field.valueNumber != null) {
      currentValue = this.field.valueNumber!;
    }

    return CupertinoSpinBox(
        min: this.formField.fieldDefinition.fieldConstraint!.minValue==null?0:this.formField.fieldDefinition.fieldConstraint!.minValue!,
        max: this.formField.fieldDefinition.fieldConstraint!.maxValue==null?1000000000:this.formField.fieldDefinition.fieldConstraint!.maxValue!,
        value: currentValue,
        onChanged: _implementOnChanged);
  }

  void _implementOnChanged(double value) {
    if (this.onValueChanged != null) {
      Map<String, dynamic> oldValueDyn = this.field.toJson();
      String oldValueString = json.encode(oldValueDyn);
      VwFieldValue oldValue = VwFieldValue.fromJson(json.decode(oldValueString));

      this.field.valueNumber = value;

      this.onValueChanged!(this.field, oldValue, false);
    }
  }
}
