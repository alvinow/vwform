// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwformfieldvalidationresponsecomponent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFormFieldValidationResponseComponent
    _$VwFormFieldValidationResponseComponentFromJson(
            Map<String, dynamic> json) =>
        VwFormFieldValidationResponseComponent(
          fieldName: json['fieldName'] as String,
          validationTimestamp:
              DateTime.parse(json['validationTimestamp'] as String),
          isValidationPassed: json['isValidationPassed'] as bool,
          validationMethodCode: json['validationMethodCode'] as String,
          validationMethodName: json['validationMethodName'] as String,
          sufficeSuggestion: json['sufficeSuggestion'] as String,
          errorMessage: json['errorMessage'] as String?,
        );

Map<String, dynamic> _$VwFormFieldValidationResponseComponentToJson(
        VwFormFieldValidationResponseComponent instance) =>
    <String, dynamic>{
      'fieldName': instance.fieldName,
      'validationTimestamp': instance.validationTimestamp.toIso8601String(),
      'isValidationPassed': instance.isValidationPassed,
      'validationMethodCode': instance.validationMethodCode,
      'validationMethodName': instance.validationMethodName,
      'sufficeSuggestion': instance.sufficeSuggestion,
      'errorMessage': instance.errorMessage,
    };
