// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwdatasourcedefinition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwDataSourceDefinition _$VwDataSourceDefinitionFromJson(
        Map<String, dynamic> json) =>
    VwDataSourceDefinition(
      folderNodeId: json['folderNodeId'] as String?,
      folderNodeMode: json['folderNodeMode'] as String? ??
          VwDataSourceDefinition.folderNodeModeStatic,
      folderUpNodeRowDataSearchParameter:
          json['folderUpNodeRowDataSearchParameter'] == null
              ? null
              : VwUpNodeRowDataSearchParameter.fromJson(
                  json['folderUpNodeRowDataSearchParameter']
                      as Map<String, dynamic>),
      sortObject: json['sortObject'],
      disableRenderFormDefinition:
          json['disableRenderFormDefinition'] as bool? ?? false,
      collectionNameList: (json['collectionNameList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      syncMode: json['syncMode'] as String,
      nodeFilter: json['nodeFilter'] == null
          ? null
          : VwMongoDbFilterParameter.fromJson(
              json['nodeFilter'] as Map<String, dynamic>),
      fieldLocalFieldRefList: (json['fieldLocalFieldRefList'] as List<dynamic>?)
          ?.map((e) => VwFieldLocalFieldRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VwDataSourceDefinitionToJson(
        VwDataSourceDefinition instance) =>
    <String, dynamic>{
      'folderNodeId': instance.folderNodeId,
      'disableRenderFormDefinition': instance.disableRenderFormDefinition,
      'sortObject': instance.sortObject,
      'collectionNameList': instance.collectionNameList,
      'syncMode': instance.syncMode,
      'nodeFilter': instance.nodeFilter,
      'fieldLocalFieldRefList': instance.fieldLocalFieldRefList,
      'folderNodeMode': instance.folderNodeMode,
      'folderUpNodeRowDataSearchParameter':
          instance.folderUpNodeRowDataSearchParameter,
    };
