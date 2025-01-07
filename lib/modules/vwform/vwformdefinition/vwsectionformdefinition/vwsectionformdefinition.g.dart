// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwsectionformdefinition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwSectionFormDefinition _$VwSectionFormDefinitionFromJson(
        Map<String, dynamic> json) =>
    VwSectionFormDefinition(
      name: json['name'] as String?,
      description: json['description'] as String?,
      formFields: (json['formFields'] as List<dynamic>)
          .map((e) => VwFormField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VwSectionFormDefinitionToJson(
        VwSectionFormDefinition instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'formFields': instance.formFields,
    };
