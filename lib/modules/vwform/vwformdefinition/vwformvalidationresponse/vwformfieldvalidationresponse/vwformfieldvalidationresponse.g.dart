// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwformfieldvalidationresponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFormFieldValidationResponse _$VwFormFieldValidationResponseFromJson(
        Map<String, dynamic> json) =>
    VwFormFieldValidationResponse(
      formField:
          VwFormField.fromJson(json['formField'] as Map<String, dynamic>),
      fieldValue:
          VwFieldValue.fromJson(json['fieldValue'] as Map<String, dynamic>),
      validationReponses: (json['validationReponses'] as List<dynamic>)
          .map((e) => VwFormFieldValidationResponseComponent.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VwFormFieldValidationResponseToJson(
        VwFormFieldValidationResponse instance) =>
    <String, dynamic>{
      'formField': instance.formField,
      'fieldValue': instance.fieldValue,
      'validationReponses': instance.validationReponses,
    };
