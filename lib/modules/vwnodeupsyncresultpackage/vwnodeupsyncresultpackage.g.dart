// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwnodeupsyncresultpackage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwNodeUpsyncResultPackage _$VwNodeUpsyncResultPackageFromJson(
        Map<String, dynamic> json) =>
    VwNodeUpsyncResultPackage(
      nodeUpsyncResultList: (json['nodeUpsyncResultList'] as List<dynamic>)
          .map((e) => VwNodeUpsyncResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      apiCallResponse: json['apiCallResponse'] == null
          ? null
          : VwApiCallResponse.fromJson(
              json['apiCallResponse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VwNodeUpsyncResultPackageToJson(
        VwNodeUpsyncResultPackage instance) =>
    <String, dynamic>{
      'nodeUpsyncResultList': instance.nodeUpsyncResultList,
      'apiCallResponse': instance.apiCallResponse,
    };
