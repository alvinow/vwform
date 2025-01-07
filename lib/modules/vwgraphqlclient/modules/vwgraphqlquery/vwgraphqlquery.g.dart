// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwgraphqlquery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwGraphQlQuery _$VwGraphQlQueryFromJson(Map<String, dynamic> json) =>
    VwGraphQlQuery(
      graphQlFunctionName: json['graphQlFunctionName'] as String,
      apiCallId: json['apiCallId'] as String,
      loginSessionId:
          json['loginSessionId'] as String? ?? "<invalid_login_session_id>",
      parameter: VwRowData.fromJson(json['parameter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VwGraphQlQueryToJson(VwGraphQlQuery instance) =>
    <String, dynamic>{
      'graphQlFunctionName': instance.graphQlFunctionName,
      'apiCallId': instance.apiCallId,
      'loginSessionId': instance.loginSessionId,
      'parameter': instance.parameter,
    };
