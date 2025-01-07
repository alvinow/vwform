// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwstyleformparam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwStyleFormParam _$VwStyleFormParamFromJson(Map<String, dynamic> json) =>
    VwStyleFormParam(
      verticalSpacing: (json['verticalSpacing'] as num?)?.toDouble() ?? 15,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 13,
      baseColorHex: json['baseColorHex'] as String? ?? "#1d5885",
      windowColorHex: json['windowColorHex'] as String? ?? "#adb3b8",
      showFormTitle: json['showFormTitle'] as bool? ?? false,
      additionalParameters: (json['additionalParameters'] as List<dynamic>?)
          ?.map((e) => VwRowData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VwStyleFormParamToJson(VwStyleFormParam instance) =>
    <String, dynamic>{
      'verticalSpacing': instance.verticalSpacing,
      'fontSize': instance.fontSize,
      'baseColorHex': instance.baseColorHex,
      'windowColorHex': instance.windowColorHex,
      'showFormTitle': instance.showFormTitle,
      'additionalParameters': instance.additionalParameters,
    };
