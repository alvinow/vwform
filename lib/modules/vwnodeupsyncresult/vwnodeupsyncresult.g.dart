// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwnodeupsyncresult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwNodeUpsyncResult _$VwNodeUpsyncResultFromJson(Map<String, dynamic> json) =>
    VwNodeUpsyncResult(
      formValidationResponse: json['formValidationResponse'] == null
          ? null
          : VwFormValidationResponse.fromJson(
              json['formValidationResponse'] as Map<String, dynamic>),
      syncResult:
          VwSyncResult.fromJson(json['syncResult'] as Map<String, dynamic>),
      nodeId: json['nodeId'] as String,
      isTokenValid: json['isTokenValid'] as bool,
    );

Map<String, dynamic> _$VwNodeUpsyncResultToJson(VwNodeUpsyncResult instance) =>
    <String, dynamic>{
      'formValidationResponse': instance.formValidationResponse,
      'syncResult': instance.syncResult,
      'nodeId': instance.nodeId,
      'isTokenValid': instance.isTokenValid,
    };
