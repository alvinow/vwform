// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwcollectionlistviewdefinition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwCollectionListViewDefinition _$VwCollectionListViewDefinitionFromJson(
        Map<String, dynamic> json) =>
    VwCollectionListViewDefinition(
      title: json['title'] as String?,
      showSearchIcon: json['showSearchIcon'] as bool? ?? false,
      searchFormDefinition: json['searchFormDefinition'] == null
          ? null
          : VwFormDefinition.fromJson(
              json['searchFormDefinition'] as Map<String, dynamic>),
      cardParameter: VwCardParameter.fromJson(
          json['cardParameter'] as Map<String, dynamic>),
      showNotificationIcon: json['showNotificationIcon'] as bool? ?? false,
      showUserInfoIcon: json['showUserInfoIcon'] as bool? ?? false,
      detailLinkFormDefinition: json['detailLinkFormDefinition'] == null
          ? null
          : VwLinkNode.fromJson(
              json['detailLinkFormDefinition'] as Map<String, dynamic>),
      detailFormDefinition: json['detailFormDefinition'] == null
          ? null
          : VwFormDefinition.fromJson(
              json['detailFormDefinition'] as Map<String, dynamic>),
      detailFormDefinitionMode: json['detailFormDefinitionMode'] as String? ??
          VwFieldUiParam.dfmLinkFormDefinition,
      dataSource: VwDataSourceDefinition.fromJson(
          json['dataSource'] as Map<String, dynamic>),
      enableCreateRecord: json['enableCreateRecord'] as bool? ?? false,
      showBackArrow: json['showBackArrow'] as bool? ?? false,
      detailFormDefinitionId: json['detailFormDefinitionId'] as String?,
      staticRefLinkNodeList: (json['staticRefLinkNodeList'] as List<dynamic>?)
          ?.map((e) => VwLinkNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VwCollectionListViewDefinitionToJson(
        VwCollectionListViewDefinition instance) =>
    <String, dynamic>{
      'title': instance.title,
      'showSearchIcon': instance.showSearchIcon,
      'searchFormDefinition': instance.searchFormDefinition,
      'cardParameter': instance.cardParameter,
      'showNotificationIcon': instance.showNotificationIcon,
      'showUserInfoIcon': instance.showUserInfoIcon,
      'detailLinkFormDefinition': instance.detailLinkFormDefinition,
      'detailFormDefinition': instance.detailFormDefinition,
      'detailFormDefinitionMode': instance.detailFormDefinitionMode,
      'dataSource': instance.dataSource,
      'enableCreateRecord': instance.enableCreateRecord,
      'showBackArrow': instance.showBackArrow,
      'detailFormDefinitionId': instance.detailFormDefinitionId,
      'staticRefLinkNodeList': instance.staticRefLinkNodeList,
    };
