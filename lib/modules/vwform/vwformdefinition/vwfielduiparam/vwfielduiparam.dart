import 'package:matrixclient/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwqueryresult/vwqueryresult.dart';

import 'package:matrixclient/modules/vwcollectionlistviewdefinition/vwcollectionlistviewdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfieldfiletagdefinition/vwfieldfiletagdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwlocalfieldref/vwlocalfieldref.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vwfielduiparam.g.dart';

@JsonSerializable()
class VwFieldUiParam{
  VwFieldUiParam({
    this.uiTypeId=VwFieldUiParam.uitTextField,
    this.isReadOnly=false,
    this.caption,
    this.hint,
    this.description,
    this.maxLine=1,
    this.minLine=1,
    this.parameter,
    this.formDefinitionId,
    this.formDefinition,
    this.collectionListViewDefinition,
    this.formDefinitionFieldName,
    this.fieldNameInternalFieldRef,
    this.localFieldRef,
    this.formDefinitionLocalFieldRef,
    this.fieldFileExtension,
    this.fieldFileTagDefinition,
    this.refParentTagNodeId,
    this.nodeContainerTagLinkNode,
    this.refTagListFieldFileStorageFieldName,
    this.fieldDisplayFormat=const VwFieldDisplayFormat(),
    this.isCalculatedField,
    this.calculatedFormula,
    this.maxChar=1600,
    this.minChar=0,
    this.maxFileSizeInKB=1024,
    this.maxFileCount=7,
    this.regexErrorMessage,
    this.regexHintMessage,
    this.regexValidationRule,
    this.isRegexEnabled=false,
    this.formulaCalculatedNumberField,

});

  String uiTypeId;
  bool isReadOnly;
  String? caption;
  String? hint;
  String? description;
  final int maxLine;
  final int minLine;
  VwQueryResult? parameter;
  String? formDefinitionId;
  VwFormDefinition? formDefinition;
  VwCollectionListViewDefinition? collectionListViewDefinition ;
  String? formDefinitionFieldName;
  String? fieldNameInternalFieldRef;
  VwLocalFieldRef? localFieldRef ;
  VwLocalFieldRef? formDefinitionLocalFieldRef;
  List<String>? fieldFileExtension;
  VwFieldFileTagDefinition? fieldFileTagDefinition;
  String? refParentTagNodeId;
  VwLinkNode? nodeContainerTagLinkNode;
  String? refTagListFieldFileStorageFieldName;
  VwFieldDisplayFormat ? fieldDisplayFormat;
  bool? isCalculatedField;
  String? calculatedFormula;
  int maxChar;
  int minChar;
  int maxFileSizeInKB;
  int maxFileCount;
  String? regexValidationRule;
  String? regexErrorMessage;
  String? regexHintMessage;
  bool isRegexEnabled;
  String? formulaCalculatedNumberField;


  static const String uitHidden = 'uitHidden';
  static const String uitCalculatedNumberField = 'uitCalculatedNumberField';
  static const String uitCaption = 'caption';
  static const String uitTextField= 'textField';
  static const String uitNumberTextField= 'uitNumberTextField';
  static const String uitStaticTextField= 'textStaticTextField';
  static const String uitTextpasswordField= 'textpasswordField';
  static const String uitSpinEditField= 'spinEditField';
  static const String uitFormPageNodeViewer = 'uitFormPageNodeViewer';
  static const String uitDateField= 'dateField';
  static const String uitTimeField= 'timeField';
  static const String uitDateTimeField= 'dateTimeField';
  static const String uitCheckboxField= 'checkboxField';
  static const String uitFileField= 'fileField';
  static const String uitLinkFormDefinitionField = 'uitLinkFormDefinitionField';
  static const String uitFormPageByLocalFieldSource = 'uitFormPageByLocalFieldSource';
  static const String uitFormPageByStaticFormDefinition = 'uitFormPageByStaticFormDefinition';
  static const String uitFormPageByLinkFormDefinition = 'uitFormPageByLinkFormDefinition';
  static const String uitChecklist='uitChecklist';
  static const String uitMultipleChoice='uitMultipleChoice';
  static const String uitDropdown='uitDropdown';
  static const String uitCheckListLinkNodeWidget = 'uitCheckListLinkNodeWidget';
  static const String uitCheckListNodeWidget = 'uitCheckListNodeWidget';
  static const String uitDropdownLinkNode = 'uitDropdownLinkNode';
  static const String uitDropdownLinkNodeByLocalFieldSource = 'uitDropdownLinkNodeByLocalFieldSource';
  static const String uitMultipleChoiceLinkNode = 'uitMultipleChoiceLinkNode';
  static const String uitTagChecklist = 'uitTagChecklist';
  static const String uitParentLinkNode = 'uitParentLinkNode';
  static const String dfmLocal = "dfmLocal";
  static const String dfmLinkFormDefinition = "dfmLinkFormDefinition";
  static const String uitNodeListView = 'uitNodeListView';

  factory VwFieldUiParam.fromJson(Map<String, dynamic> json) =>
      _$VwFieldUiParamFromJson(json);
  Map<String, dynamic> toJson() => _$VwFieldUiParamToJson(this);
}