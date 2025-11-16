import 'package:flutter/cupertino.dart';
import 'package:gstyle_datetime_picker/gstyle_datetime_picker.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';

class VwDatetimeFieldWidgetGstyle extends StatefulWidget {
  const VwDatetimeFieldWidgetGstyle(
      {Key? key,
        required this.fieldValue,
        this.readOnly = false,
        required this.formField,
        this.onValueChanged,
        required this.appInstanceParam,
        required this.getCurrentFormResponseFunction})
      : super(key: key);

  final VwFieldValue fieldValue;
  final bool readOnly;
  final VwAppInstanceParam appInstanceParam;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;

  _VwDatetimeFieldWidgetGstyleState createState() => _VwDatetimeFieldWidgetGstyleState();
}

class _VwDatetimeFieldWidgetGstyleState extends State<VwDatetimeFieldWidgetGstyle> {
  DateTime? currentDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //todo: extract into state current datetime
    this.implementInitValue();
  }

  dynamic _implementDateTimeChanged(DateTime selectedDateTime) {
    this.currentDateTime = selectedDateTime;
    this.widget.fieldValue.valueDateTime = this.currentDateTime;
  }

  void implementInitValue() {
    try {
      if (this.widget.fieldValue != null) {
        this.currentDateTime = this.widget.fieldValue!.valueDateTime;
      }
    } catch (error) {}
  }

  Widget _buildFieldCaption() {
    return VwFieldWidget.getLabel(widget.fieldValue, this.widget.formField,
        DefaultTextStyle.of(context).style, widget.readOnly);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this._buildFieldCaption(),
        GoogleStyleDateTimePicker(
            readOnly:widget.readOnly,
            locale: widget.appInstanceParam.baseAppConfig.generalConfig.locale,
            initialDateTime: this.currentDateTime,
            minDate: DateTime(1900),
            maxDate: DateTime(2050),
            onChanged: this._implementDateTimeChanged,
            onDateTimeSelected: this._implementDateTimeChanged)
      ],
    );
  }
}
