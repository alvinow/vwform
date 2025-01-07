// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwfilefieldsettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFileFieldSettings _$VwFileFieldSettingsFromJson(Map<String, dynamic> json) =>
    VwFileFieldSettings(
      maxUploadFileSizeInMB: (json['maxUploadFileSizeInMB'] as num).toDouble(),
      uploadFileExtension: (json['uploadFileExtension'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      maxUploadFileCount: (json['maxUploadFileCount'] as num).toInt(),
    );

Map<String, dynamic> _$VwFileFieldSettingsToJson(
        VwFileFieldSettings instance) =>
    <String, dynamic>{
      'maxUploadFileSizeInMB': instance.maxUploadFileSizeInMB,
      'uploadFileExtension': instance.uploadFileExtension,
      'maxUploadFileCount': instance.maxUploadFileCount,
    };
