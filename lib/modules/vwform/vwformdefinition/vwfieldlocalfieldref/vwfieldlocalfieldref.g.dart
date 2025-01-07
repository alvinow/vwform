// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwfieldlocalfieldref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFieldLocalFieldRef _$VwFieldLocalFieldRefFromJson(
        Map<String, dynamic> json) =>
    VwFieldLocalFieldRef(
      fieldNameOnContentDataSource:
          json['fieldNameOnContentDataSource'] as String,
      localFieldRef: VwLocalFieldRef.fromJson(
          json['localFieldRef'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VwFieldLocalFieldRefToJson(
        VwFieldLocalFieldRef instance) =>
    <String, dynamic>{
      'fieldNameOnContentDataSource': instance.fieldNameOnContentDataSource,
      'localFieldRef': instance.localFieldRef,
    };
