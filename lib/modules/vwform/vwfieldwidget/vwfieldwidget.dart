import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwcalculatudnumberfieldwidget/vwcalculatednumberfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwcaptionfieldwidget/vwcaptionfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwcheckboxfieldwidget/vwcheckboxfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwchecklistfieldwidget/vwchecklistfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwchecklistlinknodefieldwidget/vwchecklistlinknodefieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwchecklistnodefieldwidget/vwchecklistnodefieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwdatetimefieldwidget/vwdatetimefieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwdropdownfieldwidget/vwdropdownfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwdropdownlinknodefieldwidget/vwdropdownlinknodewidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfilefieldwidget/vwfilefieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwformfieldwidget/vwformfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwformpagenodeviewerwidget/vwformpagenodeviewerwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwmultiplechoicefieldwidget/vwmultiplechoicefieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwnodelistviewfieldwidget/vwnodelistviewfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwsimpledropdownfieldwidget/vwsimpledropdownfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwspineditfieldwidget/vwspineditfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwtagchecklistfieldwidget/vwtagchecklistfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwtextfieldwidget/vwtextfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwtextwidget/vwtextwidget.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponse/vwformfieldvalidationresponse.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponsecomponent/vwformfieldvalidationresponsecomponent.dart';
import 'package:matrixclient/modules/vwformpage/vwoldformpage.dart';

typedef VwFieldWidgetChanged = void Function(VwFieldValue, VwFieldValue, bool);

class VwFieldWidget extends StatefulWidget {
  const VwFieldWidget(
      {super.key,
        required this.appInstanceParam,
      this.readOnly = false,
      required this.field,
      required this.formField,
      this.onValueChanged,
      this.formFieldValidationResponse,
      this.parentRef,
      required this.getCurrentFormResponseFunction,
      required this.getCurrentFormDefinitionFunction,
        this.enableAlwaysSetStateOnValueChanged=true

      });



  final VwAppInstanceParam appInstanceParam;
  final bool readOnly;
  final bool enableAlwaysSetStateOnValueChanged;
  final VwFieldValue field;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final VwFormFieldValidationResponse? formFieldValidationResponse;
  final VwLinkNode? parentRef;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;
  final GetCurrentFormDefinitionFunction getCurrentFormDefinitionFunction;

  _VwFieldWidgetState createState() => _VwFieldWidgetState();

  static Widget getLabel(VwFieldValue field, VwFormField formField,
      TextStyle defaultTextStyle, bool readOnly) {
    Widget returnValue = Container();

    String currentCaption = formField.fieldUiParam.caption == null
        ? field.fieldName
        : formField.fieldUiParam.caption!;

    TextSpan mandatoryFlag =
        TextSpan(text: "*", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red, fontSize: 16));

    List<InlineSpan> textSpanList = [];

    textSpanList.add(TextSpan(
        text: currentCaption,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.5),
            color: readOnly == true ? Colors.blueGrey : Colors.black)));

    if (formField.fieldDefinition.fieldConstraint!.isMandatory == true &&
        readOnly == false) {
      textSpanList.add(mandatoryFlag);
    }

    returnValue = Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
          fit: FlexFit.loose,
          child: Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
              child: RichText(
                overflow: TextOverflow.visible,
                text: TextSpan(
                  //style: DefaultTextStyle.of(context).style,
                  style: defaultTextStyle,
                  children: textSpanList,
                ),
              )))
    ]);

    return returnValue;
  }
}

class _VwFieldWidgetState extends State<VwFieldWidget> {
  late bool currentToggleSwitch;
  late Key fieldKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(this.widget.key==null)
      {
        this.fieldKey=Key(widget.formField.fieldDefinition.fieldName);
      }
    else{
      this.fieldKey=widget.key!;
    }
    this.currentToggleSwitch = false;
  }



  void _implementOnFieldvalueChanged(
      VwFieldValue newField, VwFieldValue oldField, bool doSetState) {
    if (this.widget.onValueChanged != null) {
      this.widget.onValueChanged!(newField, oldField, doSetState);
    }



    if (doSetState==true || this.widget.enableAlwaysSetStateOnValueChanged==true) {

      if(widget.onValueChanged!=null)
        {
          widget.onValueChanged!(newField,oldField,true);
        }
      else
        {
          setState(() {});
        }


    }
  }

  @override
  Widget build(BuildContext context) {

    if(this.widget.field==null) {
      //do nothing
    }
    else
    {
      this.widget.field.valueTypeId=this.widget.formField.fieldDefinition.valueTypeId;
    }

    Widget returnValue = VwTextFieldWidget(
        key: Key(this.widget.formField.fieldDefinition.fieldName),
        field: this.widget.field,
        readOnly: this.widget.readOnly,
        formField: this.widget.formField,
        getCurrentFormResponseFunction: this.widget
            .getCurrentFormResponseFunction,
        onValueChanged: this._implementOnFieldvalueChanged);

    try {
      if(this.widget.formField.fieldUiParam.uiTypeId == VwFieldUiParam.uitCalculatedNumberField)
        {
          returnValue = VwCalculatedNumberFieldWidget(
              key: Key(this.widget.formField.fieldDefinition.fieldName),
              field: this.widget.field,

              formField: this.widget.formField,
              getCurrentFormResponseFunction: this.widget
                  .getCurrentFormResponseFunction,
              onValueChanged: this._implementOnFieldvalueChanged);
        }
      else if(this.widget.formField.fieldUiParam.uiTypeId == VwFieldUiParam.uitFormPageNodeViewer)
        {
          returnValue =  VwFormPageNodeViewerWidget(

              readOnly: widget.readOnly,
              key: this.fieldKey,
              getFieldvalueCurrentResponseFunction: this.widget
                  .getCurrentFormResponseFunction,
              appInstanceParam: widget.appInstanceParam,
              field: this.widget.field,
              onValueChanged: this._implementOnFieldvalueChanged,
              formField: this.widget.formField);
        }

      else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitTagChecklist) {
        returnValue = VwTagCheckListFieldWidget(
          readOnly: this.widget.readOnly,
          key:Key(this.widget.formField.fieldDefinition.fieldName),
          formDefinition: this.widget.getCurrentFormDefinitionFunction(),
          getCurrentFormResponseFunction: this.widget
              .getCurrentFormResponseFunction,
          field: widget.field,
          formField: widget.formField,
          appInstanceParam: widget.appInstanceParam,
        );
      }

      else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitDropdownLinkNode ||
          this.widget.formField.fieldUiParam.uiTypeId ==
              VwFieldUiParam.uitDropdownLinkNodeByLocalFieldSource) {
        returnValue = VwDropDownLinkNodeFieldWidget(
            getFieldvalueCurrentResponseFunction: this.widget
                .getCurrentFormResponseFunction,
            appInstanceParam: widget.appInstanceParam,
            field: this.widget.field,
            readOnly: this.widget.readOnly,
            formField: this.widget.formField,
            onValueChanged: this._implementOnFieldvalueChanged);
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitDropdown) {
        if (this.widget.formField.fieldUiParam.parameter != null) {

          returnValue = VwDropdownFieldWidget(
              field: this.widget.field,
              readOnly: this.widget.readOnly,
              formField: this.widget.formField,
              onValueChanged: this._implementOnFieldvalueChanged);
        }
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitMultipleChoice) {
        if (this.widget.formField.fieldUiParam.parameter != null) {
          returnValue = VwMultipleChoiceFieldWidget(
              field: this.widget.field,
              readOnly: this.widget.readOnly,
              formField: this.widget.formField,
              onValueChanged: this._implementOnFieldvalueChanged);
        }
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitChecklist) {
        if (this.widget.formField.fieldUiParam.parameter != null) {
          returnValue = VwChecklistFieldWidget(
              key: this.fieldKey,
              field: this.widget.field,
              readOnly: this.widget.readOnly,
              formField: this.widget.formField,
              onValueChanged: this._implementOnFieldvalueChanged);
        }
      }
      else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitNodeListView) {
        if (this.widget.formField.fieldUiParam.collectionListViewDefinition !=
            null) {
          returnValue = VwNodeListViewFieldWidget(
            getCurrentFormDefinitionFunction: this.widget.getCurrentFormDefinitionFunction,
              getFieldvalueCurrentResponseFunction: this.widget
                  .getCurrentFormResponseFunction,
              field: widget.field,
              formField: widget.formField,
              appInstanceParam: widget.appInstanceParam,
              parentRef: this.widget.parentRef);
        }
      }

      else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitCheckListLinkNodeWidget) {
        if (this.widget.formField.fieldUiParam.collectionListViewDefinition !=
            null) {
          returnValue = VwCheckListLinkNodeFieldWidget(
              getFieldvalueCurrentResponseFunction: this.widget
                  .getCurrentFormResponseFunction,
              field: widget.field,
              formField: widget.formField,
              appInstanceParam: widget.appInstanceParam,
              parentRef: this.widget.parentRef);
        }
      }
      else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitCheckListNodeWidget) {
        if (this.widget.formField.fieldUiParam.collectionListViewDefinition !=
            null) {
          returnValue = VwCheckListNodeFieldWidget(
              getFieldvalueCurrentResponseFunction: this.widget
                  .getCurrentFormResponseFunction,
              field: widget.field,
              formField: widget.formField,
              appInstanceParam: widget.appInstanceParam,
              parentRef: this.widget.parentRef);
        }
      }
      else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitFormPageByLocalFieldSource &&
          (this.widget.field.valueTypeId == VwFieldValue.vatValueFormResponse || this.widget.field.valueTypeId == VwFieldValue.vatValueFormResponseCommentOnly )) {
        returnValue = VwFormFieldWidget(

            readOnly: widget.readOnly,
            key: this.fieldKey,
            getFieldvalueCurrentResponseFunction: this.widget
                .getCurrentFormResponseFunction,
            appInstanceParam: widget.appInstanceParam,
            field: this.widget.field,
            onValueChanged: this._implementOnFieldvalueChanged,
            formField: this.widget.formField);
        //returnValue=VwFormPage(isMultipageSections: true,isShowAppBar: false, loginResponse: widget.loginResponse!, formResponse: widget.field.valueRowData! , formDefinition: this.widget.formField.fieldUiParam.formDefinition!, parentBloc: widget.parentBloc, formDefinitionFolderNodeId: AppConfig.formDefinitionFolderNodeId);
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitFileField) {
        returnValue = VwFileFieldWidget(

          key: Key(widget.getCurrentFormResponseFunction().recordId+widget.field.fieldName),
            getCurrentFormResponseFunction: this.widget
                .getCurrentFormResponseFunction,
            getCurrentFormDefinitionFunction: this.widget.getCurrentFormDefinitionFunction,
            onValueChanged: _implementOnFieldvalueChanged,
            appInstanceParam: this.widget.appInstanceParam,
            readOnly: this.widget.readOnly,
            field: this.widget.field,
            formField: this.widget.formField);
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitCheckboxField) {
        returnValue = VwCheckboxFieldWidget(
            field: this.widget.field, formField: this.widget.formField);
      }  else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitStaticTextField) {
        returnValue = VwTextWidget(
          field: this.widget.field,
          formField: this.widget.formField,
        );
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitCaption) {
        returnValue = VwCaptionFieldWidget(
          field: this.widget.field,
          formField: this.widget.formField,
        );
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitSpinEditField) {
        returnValue = VwSpinEditFieldWidget(
            field: this.widget.field,
            formField: this.widget.formField,
            onValueChanged: this._implementOnFieldvalueChanged);
      } else if (this.widget.formField.fieldUiParam.uiTypeId ==
          VwFieldUiParam.uitDateField ||
          this.widget.formField.fieldUiParam.uiTypeId ==
              VwFieldUiParam.uitTimeField ||
          this.widget.formField.fieldUiParam.uiTypeId ==
              VwFieldUiParam.uitDateTimeField) {
        /*
        Widget toggleOff = VwDateTimeFieldWidget(
          key:Key(this.widget.formField.fieldDefinition.fieldName),
            field: this.widget.field,
            formField: this.widget.formField,
            onValueChanged: this._implementOnFieldvalueChanged);

        Widget toggleOn = Container(
            child: VwDateTimeFieldWidget(
                key:Key(this.widget.formField.fieldDefinition.fieldName),
                field: this.widget.field,
                formField: this.widget.formField,
                onValueChanged: this._implementOnFieldvalueChanged));

        if (this.currentToggleSwitch) {
          this.currentToggleSwitch = !this.currentToggleSwitch;
          returnValue = toggleOn;
        } else {
          this.currentToggleSwitch = !this.currentToggleSwitch;
          returnValue = toggleOff;
        }
*/

      }

      if (this.widget.formFieldValidationResponse != null &&
          this.widget.formFieldValidationResponse!.validationReponses.length >
              0) {
        List<String> errorList = [];
        for (int la = 0;
        la <
            this
                .widget
                .formFieldValidationResponse!
                .validationReponses
                .length;
        la++) {
          VwFormFieldValidationResponseComponent currentElement = this
              .widget
              .formFieldValidationResponse!
              .validationReponses
              .elementAt(la);

          if (currentElement.isValidationPassed == false) {
            errorList.add(currentElement.errorMessage == null
                ? currentElement.sufficeSuggestion
                : currentElement.errorMessage! +
                ": " +
                currentElement.sufficeSuggestion);
          }
        }

        List<Widget> errorWidgetList = [];
        //create widget
        for (int la = 0; la < errorList.length; la++) {
          String currentElement = errorList.elementAt(la);
          Widget errorWidget = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            Flexible(
                child: Text(
                  currentElement,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.red),
                ))
          ]);
          errorWidgetList.add(errorWidget);
        }

        Widget errorWidgetColumn = errorWidgetList.length == 0
            ? Container()
            : Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: errorWidgetList,
            ));

        returnValue = Container(
            key: Key(this.widget.formField.fieldDefinition.fieldName),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [returnValue, errorWidgetColumn],
            ));
      }
    }
    catch(error)
    {
      print("Error catched on VwFieldWidgetUtil.build="+error.toString());
    }
    return returnValue;
  }
}
