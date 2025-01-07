// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwlocalfieldref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwLocalFieldRef _$VwLocalFieldRefFromJson(Map<String, dynamic> json) =>
    VwLocalFieldRef(
      localFieldName: json['localFieldName'] as String,
      internalFieldName: json['internalFieldName'] as String?,
      internalSubFieldName: json['internalSubFieldName'] as String?,
      fieldRefMode: json['fieldRefMode'] as String? ??
          VwLocalFieldRef.rfmInternalSubFieldValue,
      staticFilter: json['staticFilter'] == null
          ? null
          : VwRowData.fromJson(json['staticFilter'] as Map<String, dynamic>),
    )
      ..internalSub2FieldName = json['internalSub2FieldName'] as String?
      ..internalSub3FieldName = json['internalSub3FieldName'] as String?;

Map<String, dynamic> _$VwLocalFieldRefToJson(VwLocalFieldRef instance) =>
    <String, dynamic>{
      'localFieldName': instance.localFieldName,
      'internalFieldName': instance.internalFieldName,
      'internalSubFieldName': instance.internalSubFieldName,
      'internalSub2FieldName': instance.internalSub2FieldName,
      'internalSub3FieldName': instance.internalSub3FieldName,
      'fieldRefMode': instance.fieldRefMode,
      'staticFilter': instance.staticFilter,
    };
