// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwfieldaccessusergroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFieldAccessUserGroup _$VwFieldAccessUserGroupFromJson(
        Map<String, dynamic> json) =>
    VwFieldAccessUserGroup(
      userGroupId: json['userGroupId'] as String,
      createAccess: json['createAccess'] as bool? ?? false,
      readAccess: json['readAccess'] as bool? ?? false,
      updateAccess: json['updateAccess'] as bool? ?? false,
    );

Map<String, dynamic> _$VwFieldAccessUserGroupToJson(
        VwFieldAccessUserGroup instance) =>
    <String, dynamic>{
      'userGroupId': instance.userGroupId,
      'createAccess': instance.createAccess,
      'readAccess': instance.readAccess,
      'updateAccess': instance.updateAccess,
    };
