import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';


class VwCaptionFieldWidget extends StatelessWidget {
  const VwCaptionFieldWidget(
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

    if(this.formField.fieldUiParam.caption!=null) {
      returnValue = Container(
          child: Text(this.formField.fieldUiParam.caption!, overflow: TextOverflow.ellipsis,
              maxLines: 10,
              style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14))
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
