// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwfielduiparam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFieldUiParam _$VwFieldUiParamFromJson(Map<String, dynamic> json) =>
    VwFieldUiParam(
      uiTypeId: json['uiTypeId'] as String? ?? VwFieldUiParam.uitTextField,
      isReadOnly: json['isReadOnly'] as bool? ?? false,
      caption: json['caption'] as String?,
      hint: json['hint'] as String?,
      description: json['description'] as String?,
      maxLine: (json['maxLine'] as num?)?.toInt() ?? 1,
      minLine: (json['minLine'] as num?)?.toInt() ?? 1,
      parameter: json['parameter'] == null
          ? null
          : VwQueryResult.fromJson(json['parameter'] as Map<String, dynamic>),
      formDefinitionId: json['formDefinitionId'] as String?,
      formDefinition: json['formDefinition'] == null
          ? null
          : VwFormDefinition.fromJson(
              json['formDefinition'] as Map<String, dynamic>),
      collectionListViewDefinition: json['collectionListViewDefinition'] == null
          ? null
          : VwCollectionListViewDefinition.fromJson(
              json['collectionListViewDefinition'] as Map<String, dynamic>),
      formDefinitionFieldName: json['formDefinitionFieldName'] as String?,
      fieldNameInternalFieldRef: json['fieldNameInternalFieldRef'] as String?,
      localFieldRef: json['localFieldRef'] == null
          ? null
          : VwLocalFieldRef.fromJson(
              json['localFieldRef'] as Map<String, dynamic>),
      formDefinitionLocalFieldRef: json['formDefinitionLocalFieldRef'] == null
          ? null
          : VwLocalFieldRef.fromJson(
              json['formDefinitionLocalFieldRef'] as Map<String, dynamic>),
      fieldFileExtension: (json['fieldFileExtension'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      fieldFileTagDefinition: json['fieldFileTagDefinition'] == null
          ? null
          : VwFieldFileTagDefinition.fromJson(
              json['fieldFileTagDefinition'] as Map<String, dynamic>),
      refParentTagNodeId: json['refParentTagNodeId'] as String?,
      nodeContainerTagLinkNode: json['nodeContainerTagLinkNode'] == null
          ? null
          : VwLinkNode.fromJson(
              json['nodeContainerTagLinkNode'] as Map<String, dynamic>),
      refTagListFieldFileStorageFieldName:
          json['refTagListFieldFileStorageFieldName'] as String?,
      fieldDisplayFormat: json['fieldDisplayFormat'] == null
          ? const VwFieldDisplayFormat()
          : VwFieldDisplayFormat.fromJson(
              json['fieldDisplayFormat'] as Map<String, dynamic>),
      isCalculatedField: json['isCalculatedField'] as bool?,
      calculatedFormula: json['calculatedFormula'] as String?,
      maxChar: (json['maxChar'] as num?)?.toInt() ?? 1600,
      minChar: (json['minChar'] as num?)?.toInt() ?? 0,
      maxFileSizeInKB: (json['maxFileSizeInKB'] as num?)?.toInt() ?? 1024,
      maxFileCount: (json['maxFileCount'] as num?)?.toInt() ?? 7,
      regexErrorMessage: json['regexErrorMessage'] as String?,
      regexHintMessage: json['regexHintMessage'] as String?,
      regexValidationRule: json['regexValidationRule'] as String?,
      isRegexEnabled: json['isRegexEnabled'] as bool? ?? false,
      formulaCalculatedNumberField:
          json['formulaCalculatedNumberField'] as String?,
    );

Map<String, dynamic> _$VwFieldUiParamToJson(VwFieldUiParam instance) =>
    <String, dynamic>{
      'uiTypeId': instance.uiTypeId,
      'isReadOnly': instance.isReadOnly,
      'caption': instance.caption,
      'hint': instance.hint,
      'description': instance.description,
      'maxLine': instance.maxLine,
      'minLine': instance.minLine,
      'parameter': instance.parameter,
      'formDefinitionId': instance.formDefinitionId,
      'formDefinition': instance.formDefinition,
      'collectionListViewDefinition': instance.collectionListViewDefinition,
      'formDefinitionFieldName': instance.formDefinitionFieldName,
      'fieldNameInternalFieldRef': instance.fieldNameInternalFieldRef,
      'localFieldRef': instance.localFieldRef,
      'formDefinitionLocalFieldRef': instance.formDefinitionLocalFieldRef,
      'fieldFileExtension': instance.fieldFileExtension,
      'fieldFileTagDefinition': instance.fieldFileTagDefinition,
      'refParentTagNodeId': instance.refParentTagNodeId,
      'nodeContainerTagLinkNode': instance.nodeContainerTagLinkNode,
      'refTagListFieldFileStorageFieldName':
          instance.refTagListFieldFileStorageFieldName,
      'fieldDisplayFormat': instance.fieldDisplayFormat,
      'isCalculatedField': instance.isCalculatedField,
      'calculatedFormula': instance.calculatedFormula,
      'maxChar': instance.maxChar,
      'minChar': instance.minChar,
      'maxFileSizeInKB': instance.maxFileSizeInKB,
      'maxFileCount': instance.maxFileCount,
      'regexValidationRule': instance.regexValidationRule,
      'regexErrorMessage': instance.regexErrorMessage,
      'regexHintMessage': instance.regexHintMessage,
      'isRegexEnabled': instance.isRegexEnabled,
      'formulaCalculatedNumberField': instance.formulaCalculatedNumberField,
    };
