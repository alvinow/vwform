import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/util/textfieldutil.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:matrixclient/modules/vwwidget/vwqrcodepage/vwqrcodepage.dart';
import 'dart:math' as math;

import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class VwTextFieldWidget extends StatefulWidget {
  const VwTextFieldWidget(
      {Key? key,
      required this.field,
      this.readOnly = false,
      required this.formField,
      this.onValueChanged,
      required this.getCurrentFormResponseFunction})
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;

  VwTextFieldWidgetState createState() => VwTextFieldWidgetState();
}

class VwTextFieldWidgetState extends State<VwTextFieldWidget> {
  late bool isTextObscured;
  late TextEditingController textEditingController;
  late Key textFormFieldKey;
  late bool doRefreshValue;

  @override
  void initState() {
    super.initState();
    this.textFormFieldKey = UniqueKey();
    this.initGenerateOtpCode();
    this.doRefreshValue=false;
    this.textEditingController = TextEditingController();
    this.refreshValue();
    this.isTextObscured = true;
  }

  void initGenerateOtpCode() {
    final bool generateOtpCode =
        (this.widget.formField.fieldDefinition.fieldName == "otpCode" &&
            this.widget.field.valueString == null &&
            this.widget.getCurrentFormResponseFunction().collectionName ==
                "onetimepasswordformdefinition");

    if (generateOtpCode == true) {
      VwFieldValue? otpStatusFieldValue = this
          .widget
          .getCurrentFormResponseFunction()
          .getFieldByName("otpStatus");
      this.widget.field.valueString = Uuid().v4();

      if (otpStatusFieldValue != null &&
          otpStatusFieldValue.valueString == null) {
        otpStatusFieldValue.valueString = "loginLinkActive";
      }
    }

    final bool generateTicketCode =
        (this.widget.formField.fieldDefinition.fieldName == "ticketCode" &&
            this.widget.field.valueString == null &&
            this.widget.getCurrentFormResponseFunction().collectionName ==
                "ticketshoweventformdefinition");

    if (generateTicketCode == true) {
      this.widget.field.valueString = Uuid().v4();
    }
  }

  static Widget ticketCodeViewer(
      {required VwRowData ticketshowevent, required BuildContext context}) {
    String? nameContactticket;
    //String? circleContactTicket;
    //String? addressline1;
    //String? addressline2;
    try {
      VwFieldValue? contactticketFieldValue =
          ticketshowevent.getFieldByName("contactticket");

      VwFieldValue? ticketcodeFieldValue =
          ticketshowevent.getFieldByName("ticketCode");

      nameContactticket = NodeUtil.getFieldValueFromLinkNodeRowData(
              fieldName: "name",
              linkNode: contactticketFieldValue!.valueLinkNode!)!
          .valueString;

      //addressline1=NodeUtil.getFieldValueFromLinkNodeRowData(fieldName: "addressline1", linkNode: contactticketFieldValue!.valueLinkNode!)!.valueString;

      //addressline2=NodeUtil.getFieldValueFromLinkNodeRowData(fieldName: "addressline2", linkNode: contactticketFieldValue!.valueLinkNode!)!.valueString;

      String data = Uri.encodeFull(AppConfig.baseUrl +
          "/?ticketCode=" +
          ticketcodeFieldValue!.valueString! +
          '&nama=' +
          nameContactticket!);

      return InkWell(
          onTap: () async {
            if (ticketcodeFieldValue!.valueString != null) {
              await Navigator.push(
                  context,
                  MaterialTransparentRoute(
                      builder: (context) => VwQrCodePage(
                          title: nameContactticket.toString(), data: data)));
            }
          },
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 200.0,
          ));
    } catch (error) {}
    return Text("Invalid Ticket");
  }

  Widget qrCodeViewer() {
    String? username;
    try {
      VwFieldValue? userFieldValue =
          widget.getCurrentFormResponseFunction().getFieldByName("user");
      VwNode? userNode =
          NodeUtil.getNode(linkNode: userFieldValue!.valueLinkNode!);
      username =
          userNode!.content.classEncodedJson!.data!["username"].toString();
    } catch (error) {}
    String data = AppConfig.baseUrl +
        "/?otpCode=" +
        this.textEditingController.value.text! +
        "&authMode=otp";

    return InkWell(
        onTap: () async {
          if (this.textEditingController.value.text != null) {
            String data = AppConfig.baseUrl +
                "/?otpCode=" +
                this.textEditingController.value.text! +
                "&authMode=otp";

            await Navigator.push(
                context,
                MaterialTransparentRoute(
                    builder: (context) => VwQrCodePage(
                        title: username.toString() + " Login by OTP",
                        data: data)));
          }
        },
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          size: 200.0,
        ));
  }

  Widget qrCodeLoginByOtpButton() {
    Widget returnValue = InkWell(
      child: Row(children: [
        Text("Tampilkan QrCode "),
        Icon(
          Icons.qr_code_2,
          size: 40,
        )
      ]),
      onTap: () async {
        if (this.textEditingController.value.text != null) {
          String data = AppConfig.baseUrl +
              "/?otpCode=" +
              this.textEditingController.value.text! +
              "&authMode=otp";

          await Navigator.push(
              context,
              MaterialTransparentRoute(
                  builder: (context) =>
                      VwQrCodePage(title: "Login by OTP", data: data)));
        }
      },
    );
    return returnValue;
  }

  void refreshByFieldValue() {
    if (this.widget.formField.fieldUiParam.uiTypeId ==
            VwFieldUiParam.uitNumberTextField &&
        this.widget.field.valueNumber != null) {
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

      formatter.maximumIntegerDigits=25;
      String currentValue = formatter.format(this.widget.field.valueNumber);

      textEditingController.text = currentValue;
    } else if (this.widget.field.valueString != null) {
      textEditingController.text = this.widget.field.valueString!;
    }
  }

  void refreshValue() {
    if (this.widget.formField.fieldUiParam.uiTypeId ==
            VwFieldUiParam.uitNumberTextField &&
        this.widget.field.valueNumber != null) {
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

      formatter.maximumIntegerDigits=25;
      String currentValue = formatter.format(this.widget.field.valueNumber);

      textEditingController.text = currentValue;
    } else if ((this.widget.formField.fieldUiParam.uiTypeId ==
                VwFieldUiParam.uitDateTimeField ||
            this.widget.formField.fieldUiParam.uiTypeId ==
                VwFieldUiParam.uitDateField ||
            this.widget.formField.fieldUiParam.uiTypeId ==
                VwFieldUiParam.uitTimeField) &&
        this.widget.field.valueDateTime != null) {
      String? currentValueString;

      if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitDateTimeField) {
        currentValueString = VwDateUtil.indonesianFormatLocalTimeZone(
            this.widget.field.valueDateTime!);
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitDateField) {
        currentValueString = VwDateUtil.indonesianFormatLocalTimeZone_DateOnly(
            this.widget.field.valueDateTime!);
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitTimeField) {
        currentValueString = VwDateUtil.indonesianFormatLocalTimeZone_TimeOnly(
            this.widget.field.valueDateTime!);
      }

      textEditingController.text = currentValueString.toString();
    } else if (this.widget.field.valueString != null) {
      textEditingController.text = this.widget.field.valueString!;
    }
  }

  bool getIsReadOnly() {
    bool returnValue = true;
    try {
      returnValue = this.widget.formField.fieldUiParam.isReadOnly ||
          this.widget.readOnly ||
          this.widget.formField.fieldDefinition.valueTypeId ==
              VwFieldValue.vatDateTime ||
          this.widget.formField.fieldDefinition.valueTypeId ==
              VwFieldValue.vatDateOnly ||
          this.widget.formField.fieldDefinition.valueTypeId ==
              VwFieldValue.vatTimeOnly;
    } catch (returnValue) {}

    return returnValue;
  }

  TextInputType getKeyboardType() {
    TextInputType returnValue = TextInputType.text;

    if (this.widget.formField.fieldUiParam.uiTypeId ==
        VwFieldUiParam.uitNumberTextField) {
      returnValue = TextInputType.numberWithOptions(decimal: true);
    } else {
      if (widget.formField.fieldUiParam.maxLine! > 1) {
        returnValue = TextInputType.multiline;
      }
    }

    return returnValue;
  }

  List<TextInputFormatter> getInputFormatters() {
    List<TextInputFormatter> returnValue = <TextInputFormatter>[];

    if (this.widget.formField.fieldUiParam.uiTypeId ==
        VwFieldUiParam.uitNumberTextField) {
      returnValue.add(TextFieldUtil.createNumberTextInputFormatter(this
          .widget
          .formField
          .fieldUiParam
          .fieldDisplayFormat!
          .numberTextInputFormatter!));
    }

    return returnValue;
  }

  bool _getIsObscureText() {
    return this.widget.formField.fieldUiParam.uiTypeId == 'textpasswordField'
        ? this.isTextObscured
        : false;
  }



  void _onDateValueChanged(DateTime? newDateTime) {
    if (this.widget.onValueChanged != null) {
      VwFieldValue oldValue = VwFieldValue.clone(this.widget.field);

      this.widget.field.valueDateTime = newDateTime;

      this.widget.onValueChanged!(this.widget.field, oldValue, true);
    }
  }

  void _onTextFieldValueChanged(String value) {
    if (this.widget.onValueChanged != null) {
      VwFieldValue oldValue = VwFieldValue.clone(this.widget.field);
      if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitNumberTextField) {
        try {
          final deFormat = NumberFormat.decimalPattern(
              this.widget.formField.fieldUiParam.fieldDisplayFormat!.locale);

          this.widget.field.valueNumber = deFormat.parse(value).toDouble();
          //this.widget.field.valueNumber = NumberFormat(this.widget.formField.fieldUiParam.fieldDisplayFormat!.locale).parse(value).toDouble();
        } catch (error) {
          this.widget.field.valueNumber = null;
        }
      } else {
        this.widget.field.valueString = value;
      }
      this.widget.onValueChanged!(this.widget.field, oldValue, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();

    if(this.doRefreshValue==true)
      {
        this.doRefreshValue=false;
        this.refreshValue();
      }

    if (this.widget.formField.fieldUiParam.isCalculatedField == true) {
      //this.refreshByFieldValue();
    }
    final bool showQrCode =
    (this.widget.formField.fieldDefinition.fieldName == "otpCode" &&
        this.textEditingController.value.text != null &&
        this.textEditingController.value.text.length > 0 &&
        this.widget.getCurrentFormResponseFunction().formDefinitionId ==
            "onetimepasswordcmeditformdefinition");

    final bool showTicketCode =
    (this.widget.formField.fieldDefinition.fieldName == "ticketCode" &&
        this.textEditingController.value.text != null &&
        this.textEditingController.value.text.length > 0 &&
        this.widget.getCurrentFormResponseFunction().formDefinitionId ==
            "ticketshoweventformdefinition");

    Widget captionWidget = VwFieldWidget.getLabel(
        widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        widget.readOnly);

    int? maxLines = _getIsObscureText() == true
        ? 1
        : this.widget.formField.fieldUiParam.maxLine;
    int? minLines = widget.formField.fieldUiParam.minLine;

    if (minLines != null && maxLines != null && minLines < maxLines) {
      minLines = maxLines;
    }

    Widget textFormFieldWidget = TextFormField(
      onTap: () async {
        if (this.widget.formField.fieldUiParam.uiTypeId ==
            VwFieldUiParam.uitDateTimeField ||

            this.widget.formField.fieldUiParam.uiTypeId ==
                VwFieldUiParam.uitTimeField) {
          DateTime? newDateTime = await showOmniDateTimePicker(
            context: context,
            initialDate: this.widget.field.valueDateTime != null
                ? this.widget.field.valueDateTime!
                : DateTime.now(),
            firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
            lastDate: DateTime.now().add(
              const Duration(days: 3652),
            ),
            isForce2Digits: true,
            is24HourMode: true,
            isShowSeconds: false,
            minutesInterval: 5,
            secondsInterval: 1,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 650,
            ),
            transitionBuilder: (context, anim1, anim2, child) {
              return FadeTransition(
                opacity: anim1.drive(
                  Tween(
                    begin: 0,
                    end: 1,
                  ),
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            barrierDismissible: true,
          );

          if (newDateTime != null) {
            this.doRefreshValue=true;
            this._onDateValueChanged(newDateTime);
          }
        }
        else if( this.widget.formField.fieldUiParam.uiTypeId ==
            VwFieldUiParam.uitDateField)

        {

          List<DateTime?>? newDates = await showCalendarDatePicker2Dialog(
            context: context,
            config: CalendarDatePicker2WithActionButtonsConfig(

            ),
            dialogSize: const Size(325, 400),
            borderRadius: BorderRadius.circular(15),
            value: [this.widget.field.valueDateTime],
            dialogBackgroundColor: Colors.white,

          );

          if(newDates!=null && newDates.length>0)
            {
              DateTime? newDate=newDates.elementAt(0);

              if(newDate!=null)
                {
                  this.doRefreshValue=true;
                  this._onDateValueChanged(newDate);
                }
            }

        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: this.widget.formField.fieldUiParam.maxChar,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      validator: (value) {
        if (this.widget.formField.fieldUiParam.minChar > 0 && value != null) {
          return value!.length < this.widget.formField.fieldUiParam.minChar
              ? this.widget.formField.fieldUiParam.caption.toString() +
              ' minimal ' +
              this.widget.formField.fieldUiParam.minChar.toString() +
              " karakter"
              : null;
        } else {
          return null;
        }
      },
      autofocus: true,
      key: this.textFormFieldKey,
      textAlignVertical: TextAlignVertical.center,
      maxLines: maxLines,
      minLines: minLines,
      obscureText: this._getIsObscureText(),
      obscuringCharacter: '*',
      autocorrect: false,
      enableSuggestions: false,
      readOnly: this.getIsReadOnly(),
      onChanged: this._onTextFieldValueChanged,
      inputFormatters: this.getInputFormatters(),
      keyboardType: this.getKeyboardType(),
      controller: this.textEditingController,
      decoration: InputDecoration(
        fillColor: Colors.grey[10],
        //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        suffixIcon: this.widget.formField.fieldUiParam.uiTypeId ==
            VwFieldUiParam.uitTextpasswordField
            ? InkWell(
            onTap: () {
              this.isTextObscured = !this.isTextObscured;

              setState(() {});
            },
            child: Icon(
              Icons.remove_red_eye,
              size: 20,
              color:
              this.isTextObscured == true ? Colors.grey : Colors.blue,
            ))
            : null,
        filled: true,
        border: const UnderlineInputBorder(),
        focusColor: Colors.orange,
        isDense: true,
      ),
    );

    if (showTicketCode == true) {
      returnValue = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          captionWidget,
          SizedBox(
            height: 8,
          ),
          showTicketCode == true ? Container() : textFormFieldWidget,
          showTicketCode == true
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            VwTextFieldWidgetState.ticketCodeViewer(
                ticketshowevent:
                this.widget.getCurrentFormResponseFunction(),
                context: context)
          ])
              : Container()
        ],
      );
    } else {
      returnValue = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          captionWidget,
          SizedBox(
            height: 8,
          ),
          showQrCode == true ? Container() : textFormFieldWidget,
          showQrCode == true
              ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [this.qrCodeViewer()])
              : Container()
        ],
      );
    }

    return returnValue;
  }
}
