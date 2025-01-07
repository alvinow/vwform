// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwfieldaccess.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFieldAccess _$VwFieldAccessFromJson(Map<String, dynamic> json) =>
    VwFieldAccess(
      enabled: json['enabled'] as bool,
      fieldAccessUserGroupList: (json['fieldAccessUserGroupList']
              as List<dynamic>)
          .map(
              (e) => VwFieldAccessUserGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VwFieldAccessToJson(VwFieldAccess instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'fieldAccessUserGroupList': instance.fieldAccessUserGroupList,
    };
