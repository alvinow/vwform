import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';



class VwCheckboxFieldWidget extends StatefulWidget {
  const VwCheckboxFieldWidget(
      {Key? key,
        required this.field,
        required this.formField,
        this.readOnly=false,
        this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final VwFormField formField;
  final VwFieldWidgetChanged ? onValueChanged;
  final bool readOnly;

  _VwCheckboxFieldWidgetState createState() => _VwCheckboxFieldWidgetState();
}

class _VwCheckboxFieldWidgetState extends State<VwCheckboxFieldWidget> {


  @override
  void initState() {
    super.initState();


  }

  TextInputType getKeyboardType() {
    TextInputType returnValue = TextInputType.text;

    return returnValue;
  }

  List<TextInputFormatter> getInputFormatters() {
    List<TextInputFormatter> returnValue = <TextInputFormatter>[];

    return returnValue;
  }

  String? getInitialValue() {
    String? returnValue = this.widget.field.valueString == null
        ? ''
        : this.widget.field.valueString.toString();

    return returnValue;
  }

  TextEditingController? getTextEditingController() {
    TextEditingController? returnValue;

    return returnValue;
  }



  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {

    Widget returnValue = Container();
    Widget captionWidget= VwFieldWidget.getLabel(widget.field,this.widget.formField,DefaultTextStyle.of(context).style,widget.readOnly);





    returnValue =Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,  children: [ Checkbox(

      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: this.widget.field.valueBoolean==null? false:this.widget.field.valueBoolean,
      onChanged: (bool? value) {
        print(value.toString());
        setState(() {
          this._onCheckBoxFieldValueChanged(value!);
        });
      },
    ),Container(padding: EdgeInsets.fromLTRB(0, 0, 0, 8), child:captionWidget) ]);

    return returnValue;
  }

  Widget _getCaption(){
    Widget returnValue=Container();
    if(this.widget.formField.fieldUiParam.caption!=null) {
      returnValue=Text(this.widget.formField.fieldUiParam.caption!, style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
          color: Colors.black54,
          fontSize: 18));
    }
    return returnValue;
  }

  void _onCheckBoxFieldValueChanged(bool value) {
    VwFieldValue oldValue = VwFieldValue .clone(this.widget.field);
    this.widget.field.valueBoolean = value;
    if (this.widget.onValueChanged != null) {

      this.widget.onValueChanged!(this.widget.field, oldValue, false);
    }
  }
}
