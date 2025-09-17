// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwcardparameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwCardParameter _$VwCardParameterFromJson(Map<String, dynamic> json) =>
    VwCardParameter(
      titleFieldName: json['titleFieldName'] as String? ?? "name",
      iconHexCode: json['iconHexCode'] as String? ?? "0xf81b",
      iconHexColor: json['iconHexColor'] as String? ?? "ff567189",
      iconFontFamily: json['iconFontFamily'] as String? ?? "MaterialIcons",
      subTitleFieldName: json['subTitleFieldName'] as String?,
      captionFieldName: json['captionFieldName'] as String? ?? "caption",
      descriptionFieldName: json['descriptionFieldName'] as String?,
      timestampFieldName: json['timestampFieldName'] as String?,
      cardStyle: json['cardStyle'] as String? ?? VwCardParameter.csTwoColumn,
      isShowDate: json['isShowDate'] as bool? ?? true,
      isShowSubtitle: json['isShowSubtitle'] as bool? ?? true,
      titleSubFieldName: json['titleSubFieldName'] as String?,
      subtitleSubFieldName: json['subtitleSubFieldName'] as String?,
      descriptionSubFieldName: json['descriptionSubFieldName'] as String?,
      descriptionPrefix: json['descriptionPrefix'] as String?,
      titlePrefix: json['titlePrefix'] as String?,
      subtitlePrefix: json['subtitlePrefix'] as String?,
      titleSufix: json['titleSufix'] as String?,
      subtitleSufix: json['subtitleSufix'] as String?,
      descriptionSufix: json['descriptionSufix'] as String?,
      dateFieldName: json['dateFieldName'] as String?,
      dateSubFieldName: json['dateSubFieldName'] as String?,
      titleDisplayFormat: json['titleDisplayFormat'] == null
          ? null
          : VwFieldDisplayFormat.fromJson(
              json['titleDisplayFormat'] as Map<String, dynamic>),
      subtitleDisplayFormat: json['subtitleDisplayFormat'] == null
          ? null
          : VwFieldDisplayFormat.fromJson(
              json['subtitleDisplayFormat'] as Map<String, dynamic>),
      descriptionDisplayFormat: json['descriptionDisplayFormat'] == null
          ? null
          : VwFieldDisplayFormat.fromJson(
              json['descriptionDisplayFormat'] as Map<String, dynamic>),
      dateDisplayFormat: json['dateDisplayFormat'] == null
          ? null
          : VwFieldDisplayFormat.fromJson(
              json['dateDisplayFormat'] as Map<String, dynamic>),
      medialinktitle: json['medialinktitle'] as String?,
      imagetitle: json['imagetitle'] as String?,
      imagecontent: json['imagecontent'] as String?,
      htmlcontent: json['htmlcontent'] as String?,
      articletype: json['articletype'] as String?,
      location: json['location'] as String?,
      maincategory: json['maincategory'] as String?,
      releaseStatus: json['releaseStatus'] as String?,
      fieldNameMode:
          json['fieldNameMode'] as String? ?? VwCardParameter.fnmStandard,
      isShowUpdaterInfo: json['isShowUpdaterInfo'] as bool? ?? false,
      datePosition: json['datePosition'] as String? ??
          VwCardParameter.dpDatePositionRight,
    );

Map<String, dynamic> _$VwCardParameterToJson(VwCardParameter instance) =>
    <String, dynamic>{
      'iconHexCode': instance.iconHexCode,
      'iconHexColor': instance.iconHexColor,
      'iconFontFamily': instance.iconFontFamily,
      'titleFieldName': instance.titleFieldName,
      'captionFieldName': instance.captionFieldName,
      'subTitleFieldName': instance.subTitleFieldName,
      'descriptionFieldName': instance.descriptionFieldName,
      'timestampFieldName': instance.timestampFieldName,
      'cardStyle': instance.cardStyle,
      'isShowDate': instance.isShowDate,
      'isShowSubtitle': instance.isShowSubtitle,
      'titleSubFieldName': instance.titleSubFieldName,
      'subtitleSubFieldName': instance.subtitleSubFieldName,
      'descriptionSubFieldName': instance.descriptionSubFieldName,
      'titlePrefix': instance.titlePrefix,
      'subtitlePrefix': instance.subtitlePrefix,
      'descriptionPrefix': instance.descriptionPrefix,
      'titleSufix': instance.titleSufix,
      'subtitleSufix': instance.subtitleSufix,
      'descriptionSufix': instance.descriptionSufix,
      'dateFieldName': instance.dateFieldName,
      'dateSubFieldName': instance.dateSubFieldName,
      'titleDisplayFormat': instance.titleDisplayFormat,
      'subtitleDisplayFormat': instance.subtitleDisplayFormat,
      'descriptionDisplayFormat': instance.descriptionDisplayFormat,
      'dateDisplayFormat': instance.dateDisplayFormat,
      'medialinktitle': instance.medialinktitle,
      'imagetitle': instance.imagetitle,
      'imagecontent': instance.imagecontent,
      'htmlcontent': instance.htmlcontent,
      'articletype': instance.articletype,
      'location': instance.location,
      'maincategory': instance.maincategory,
      'releaseStatus': instance.releaseStatus,
      'fieldNameMode': instance.fieldNameMode,
      'datePosition': instance.datePosition,
      'isShowUpdaterInfo': instance.isShowUpdaterInfo,
    };
