import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
part 'vwcardparameter.g.dart';


@JsonSerializable()
class VwCardParameter {
  const VwCardParameter(
      {this.titleFieldName="name",
      this.iconHexCode = "0xf81b",
      this.iconHexColor = "ff567189",
      this.iconFontFamily = "MaterialIcons",
      this.subTitleFieldName,
        this.captionFieldName="caption",
      this.descriptionFieldName,
      this.timestampFieldName,
      this.cardStyle = VwCardParameter.csTwoColumn,
      this.isShowDate = true,
      this.isShowSubtitle = true,
      this.titleSubFieldName,
      this.subtitleSubFieldName,
      this.descriptionSubFieldName,

      this.descriptionPrefix,
      this.titlePrefix,
      this.subtitlePrefix,
      this.titleSufix,
      this.subtitleSufix,
      this.descriptionSufix,
      this.dateFieldName,
      this.dateSubFieldName,
      this.titleDisplayFormat,
        this.subtitleDisplayFormat,
        this.descriptionDisplayFormat,
        this.dateDisplayFormat,
        this.medialinktitle,
        this.imagetitle,
        this.imagecontent,
        this.htmlcontent,
        this.articletype,
        this.location,
        this.maincategory,
        this.releaseStatus,
        this.fieldNameMode=VwCardParameter.fnmStandard,
        this.isShowUpdaterInfo=false,
        this.datePosition=VwCardParameter.dpDatePositionRight
      });

  final String iconHexCode;
  final String iconHexColor;
  final String iconFontFamily;
  final String titleFieldName;
  final String? captionFieldName;
  final String? subTitleFieldName;
  final String? descriptionFieldName;
  final String? timestampFieldName;
  final String cardStyle;
  final bool isShowDate;
  final bool isShowSubtitle;
  final String? titleSubFieldName;
  final String? subtitleSubFieldName;
  final String? descriptionSubFieldName;
  final String? titlePrefix;
  final String? subtitlePrefix;
  final String? descriptionPrefix;
  final String? titleSufix;
  final String? subtitleSufix;
  final String? descriptionSufix;
  final String? dateFieldName;
  final String? dateSubFieldName;
  final VwFieldDisplayFormat? titleDisplayFormat;
  final VwFieldDisplayFormat? subtitleDisplayFormat;
  final VwFieldDisplayFormat? descriptionDisplayFormat;
  final VwFieldDisplayFormat? dateDisplayFormat;
  final String? medialinktitle;
  final String? imagetitle;
  final String? imagecontent;
  final String? htmlcontent;
  final String? articletype;
  final String? location;
  final String? maincategory;
  final String? releaseStatus;
  final String fieldNameMode;
  final String? datePosition;
  final bool isShowUpdaterInfo;

  static const String csQuestion = "csQuestion";
  static const String csInstagram = "csInstagram";
  static const String csTwoColumn = "csTwoColumn";
  static const String csTwoColumnWithDescription = "csTwoColumnWithDescription";
  static const String csOneColumn = "csOneColumn";
  static const String csOneColumnWithDescription = "csOneColumnWithDescription";
  static const String fnmStandard="fnmStandard";
  static const String fnmJson="fnmJson";

  static  const String  dpDatePositionRight="dpRight";
  static  const String dpDatePositionTop="dpTop";
  static  const String dpDatePositionBottom="dpBottom";

  factory VwCardParameter.fromJson(Map<String, dynamic> json) =>
      _$VwCardParameterFromJson(json);
  Map<String, dynamic> toJson() => _$VwCardParameterToJson(this);
}
