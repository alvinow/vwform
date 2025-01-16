import 'dart:math';


import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/appconfig.dart';


import 'dart:convert';

import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';




class VwDateTimeFieldWidget extends StatefulWidget{
  const VwDateTimeFieldWidget(
      {Key? key,
        required this.locale,
        required this.field,
        required this.formField,
        this.onValueChanged})
      : super(key: key);

  final String locale;
  final VwFieldValue field;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;

  VwDateTimeFieldWidgetState createState()=>VwDateTimeFieldWidgetState();

}

class VwDateTimeFieldWidgetState extends State<VwDateTimeFieldWidget> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }

 DateFormat _getDateFormat(DateTimeFieldPickerMode dateTimeFieldPickerMode){
    if(dateTimeFieldPickerMode==DateTimeFieldPickerMode.date)
      {
        return DateFormat("dd-MMM-yyyy", this.widget.locale);
      }
    else  if(dateTimeFieldPickerMode==DateTimeFieldPickerMode.time)
      {
        return DateFormat("hh:mm",this.widget.locale);
      }
    else
      {
        return DateFormat("dd-MMM-yyyy hh:mm",this.widget.locale);
      }

  }

  DateTimeFieldPickerMode _getDateTimeMode() {
    DateTimeFieldPickerMode returnValue = DateTimeFieldPickerMode.date;

    if (this.widget.formField.fieldUiParam.uiTypeId == 'dateField') {
      returnValue = DateTimeFieldPickerMode.date;
    } else if (this.widget.formField.fieldUiParam.uiTypeId == 'timeField') {
      returnValue = DateTimeFieldPickerMode.time;
    }


    return returnValue;
  }

  Widget? _getCaption(){
    Widget? returnValue=null;

    if(this.widget.formField.fieldUiParam.caption!=null)
    {
      returnValue=Text(this.widget.formField.fieldUiParam.caption!);
    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {

    Widget captionWidget = VwFieldWidget.getLabel(
        this.widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        this.widget.formField.fieldUiParam.isReadOnly);


    Widget dateFieldWidget= Container(
      key:this.widget.key,
        width: 200,
        height: 60,
        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
            key:this.widget.key,
            children: [
          Expanded(
              key:this.widget.key,
              child: DateTimeFormField (
                onChanged: (currentSelectedDate){},
                key:this.widget.key,

                enableFeedback: this.widget.formField.fieldUiParam.isReadOnly!=true,
                dateFormat: this._getDateFormat(this._getDateTimeMode()),
                style: TextStyle(fontSize: 17),
                //dateTextStyle: TextStyle(fontSize: 17),
                //use24hFormat: true,
                //initialDate: DateTime.now(),
                initialValue: this.widget.field.valueDateTime,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: const OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  //label:this._getCaption(),
                ),
                //mode : DateTimeFieldPickerMode.time,
                mode: this._getDateTimeMode(),

                onSaved: this._onFieldValueDateSelected,

                //onDateSelected: this._onFieldValueDateSelected,
              )),
          this.widget.field.valueDateTime == null || this.widget.formField.fieldUiParam.isReadOnly==true ? Container() : this._getDeleteBox()
        ]));

    return Column( key:this.widget.key,crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.start, children: [captionWidget,dateFieldWidget]);
  }


  Widget _getDeleteBox() {
    return Container(
        width: 20,
        child: InkWell(
          onTap: () {
            this._onFieldValueChanged(null);
          },
          child: Transform.rotate(
            angle: 45 * pi / 180,
            child: Icon(Icons.add),
          ),
        ));
  }

  void _onFieldValueDateSelected(DateTime? value) {
    this._onFieldValueChanged(value);
  }

  void _onFieldValueChanged(DateTime? value) {
    if (this.widget.onValueChanged != null) {

      if(this.widget.formField.fieldUiParam.uiTypeId==VwFieldUiParam .uitDateField)
      {
        this.widget.field.valueTypeId=VwFieldValue.vatDateOnly;
      }
      else if(this.widget.formField.fieldUiParam.uiTypeId==VwFieldUiParam.uitTimeField)
      {
        this.widget.field.valueTypeId=VwFieldValue.vatTimeOnly;
      }
      else if(this.widget.formField.fieldUiParam.uiTypeId==VwFieldUiParam.uitDateTimeField)
      {
        this.widget.field.valueTypeId=VwFieldValue.vatDateTime;
      }

      Map<String, dynamic> oldValueDyn = this.widget.field.toJson();
      String oldValueString = json.encode(oldValueDyn);
      VwFieldValue oldValue = VwFieldValue.fromJson(json.decode(oldValueString));

      this.widget.field.valueDateTime = value;
      this.widget.onValueChanged!(this.widget.field, oldValue, false);
    }
  }
}