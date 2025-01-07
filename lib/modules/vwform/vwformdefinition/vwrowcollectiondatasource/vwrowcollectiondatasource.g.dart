// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwrowcollectiondatasource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwRowCollectionDataSource _$VwRowCollectionDataSourceFromJson(
        Map<String, dynamic> json) =>
    VwRowCollectionDataSource(
      rowCollectionDefinitionId: json['rowCollectionDefinitionId'] as String,
      renderedRowCollectionDefinition:
          json['renderedRowCollectionDefinition'] == null
              ? null
              : VwRowCollectionDefinition.fromJson(
                  json['renderedRowCollectionDefinition']
                      as Map<String, dynamic>),
      renderedRowDefinition: json['renderedRowDefinition'] == null
          ? null
          : VwRowDefinition.fromJson(
              json['renderedRowDefinition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VwRowCollectionDataSourceToJson(
        VwRowCollectionDataSource instance) =>
    <String, dynamic>{
      'rowCollectionDefinitionId': instance.rowCollectionDefinitionId,
      'renderedRowCollectionDefinition':
          instance.renderedRowCollectionDefinition,
      'renderedRowDefinition': instance.renderedRowDefinition,
    };
