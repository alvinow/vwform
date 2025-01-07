// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwjsonfieldnamecardparameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwJsonFieldNameCardParameter _$VwJsonFieldNameCardParameterFromJson(
        Map<String, dynamic> json) =>
    VwJsonFieldNameCardParameter(
      functionName: json['functionName'] as String,
      nodeExplorerDefinition: json['nodeExplorerDefinition'] == null
          ? null
          : NodeExplorerDefinition.fromJson(
              json['nodeExplorerDefinition'] as Map<String, dynamic>),
      memberList: (json['memberList'] as List<dynamic>?)
          ?.map((e) =>
              VwJsonFieldNameCardParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      staticText: json['staticText'] as String?,
      fieldDisplayFormat: json['fieldDisplayFormat'] == null
          ? null
          : VwFieldDisplayFormat.fromJson(
              json['fieldDisplayFormat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VwJsonFieldNameCardParameterToJson(
        VwJsonFieldNameCardParameter instance) =>
    <String, dynamic>{
      'functionName': instance.functionName,
      'nodeExplorerDefinition': instance.nodeExplorerDefinition,
      'memberList': instance.memberList,
      'staticText': instance.staticText,
      'fieldDisplayFormat': instance.fieldDisplayFormat,
    };
