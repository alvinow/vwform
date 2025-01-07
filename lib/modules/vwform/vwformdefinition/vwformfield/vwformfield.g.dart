// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwformfield.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFormField _$VwFormFieldFromJson(Map<String, dynamic> json) => VwFormField(
      fieldDefinition: VwFieldDefinition.fromJson(
          json['fieldDefinition'] as Map<String, dynamic>),
      fieldUiParam:
          VwFieldUiParam.fromJson(json['fieldUiParam'] as Map<String, dynamic>),
      fieldAccess: json['fieldAccess'] == null
          ? null
          : VwFieldAccess.fromJson(json['fieldAccess'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VwFormFieldToJson(VwFormField instance) =>
    <String, dynamic>{
      'fieldUiParam': instance.fieldUiParam,
      'fieldAccess': instance.fieldAccess,
      'fieldDefinition': instance.fieldDefinition,
    };
