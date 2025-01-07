// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwformvalidationresponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFormValidationResponse _$VwFormValidationResponseFromJson(
        Map<String, dynamic> json) =>
    VwFormValidationResponse(
      formDefinition: json['formDefinition'] == null
          ? null
          : VwFormDefinition.fromJson(
              json['formDefinition'] as Map<String, dynamic>),
      formFieldValidationResponses: (json['formFieldValidationResponses']
              as List<dynamic>?)
          ?.map((e) =>
              VwFormFieldValidationResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFormResponseValid: json['isFormResponseValid'] as bool? ?? false,
      isTryValidated: json['isTryValidated'] as bool? ?? false,
      lastTryValidated: json['lastTryValidated'] == null
          ? null
          : DateTime.parse(json['lastTryValidated'] as String),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$VwFormValidationResponseToJson(
        VwFormValidationResponse instance) =>
    <String, dynamic>{
      'formDefinition': instance.formDefinition,
      'formFieldValidationResponses': instance.formFieldValidationResponses,
      'isTryValidated': instance.isTryValidated,
      'isFormResponseValid': instance.isFormResponseValid,
      'lastTryValidated': instance.lastTryValidated?.toIso8601String(),
      'errorMessage': instance.errorMessage,
    };
