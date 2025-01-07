import 'package:flutter/cupertino.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';


class VwDateTimeFieldWidget2 extends StatefulWidget {
  const VwDateTimeFieldWidget2(
      {Key? key,
      required this.field,
      required this.formField,
      this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  VwDateTimeFieldWidget2State createState() => VwDateTimeFieldWidget2State();
}

class VwDateTimeFieldWidget2State extends State<VwDateTimeFieldWidget2> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
