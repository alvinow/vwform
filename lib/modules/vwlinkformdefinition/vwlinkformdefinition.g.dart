// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwlinkformdefinition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwLinkFormDefinition _$VwLinkFormDefinitionFromJson(
        Map<String, dynamic> json) =>
    VwLinkFormDefinition(
      collectionName: json['collectionName'] as String,
      recordId: json['recordId'] as String,
      rendered: json['rendered'] == null
          ? null
          : VwClassEncodedJson.fromJson(
              json['rendered'] as Map<String, dynamic>),
      sync: json['sync'] == null
          ? null
          : VwClassEncodedJson.fromJson(json['sync'] as Map<String, dynamic>),
    )
      ..cache = json['cache'] == null
          ? null
          : VwClassEncodedJson.fromJson(json['cache'] as Map<String, dynamic>)
      ..renderedFormDefinition = json['renderedFormDefinition'] == null
          ? null
          : VwFormDefinition.fromJson(
              json['renderedFormDefinition'] as Map<String, dynamic>);

Map<String, dynamic> _$VwLinkFormDefinitionToJson(
        VwLinkFormDefinition instance) =>
    <String, dynamic>{
      'collectionName': instance.collectionName,
      'recordId': instance.recordId,
      'rendered': instance.rendered,
      'cache': instance.cache,
      'sync': instance.sync,
      'renderedFormDefinition': instance.renderedFormDefinition,
    };
