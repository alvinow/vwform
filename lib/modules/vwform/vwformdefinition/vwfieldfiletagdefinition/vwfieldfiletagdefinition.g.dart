// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwfieldfiletagdefinition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFieldFileTagDefinition _$VwFieldFileTagDefinitionFromJson(
        Map<String, dynamic> json) =>
    VwFieldFileTagDefinition(
      filePageTagFormDefinition: VwFormDefinition.fromJson(
          json['filePageTagFormDefinition'] as Map<String, dynamic>),
      tagFormDefinition: VwFormDefinition.fromJson(
          json['tagFormDefinition'] as Map<String, dynamic>),
      linkNodeListFieldName: json['linkNodeListFieldName'] as String,
    );

Map<String, dynamic> _$VwFieldFileTagDefinitionToJson(
        VwFieldFileTagDefinition instance) =>
    <String, dynamic>{
      'filePageTagFormDefinition': instance.filePageTagFormDefinition,
      'tagFormDefinition': instance.tagFormDefinition,
      'linkNodeListFieldName': instance.linkNodeListFieldName,
    };
