// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwmongodbfilterparameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwMongoDbFilterParameter _$VwMongoDbFilterParameterFromJson(
        Map<String, dynamic> json) =>
    VwMongoDbFilterParameter(
      sort: json['sort'] as Map<String, dynamic>?,
      filter: json['filter'] as Map<String, dynamic>?,
      projection: json['projection'] as Map<String, dynamic>?,
      collation: json['collation'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$VwMongoDbFilterParameterToJson(
        VwMongoDbFilterParameter instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'filter': instance.filter,
      'projection': instance.projection,
      'collation': instance.collation,
    };
