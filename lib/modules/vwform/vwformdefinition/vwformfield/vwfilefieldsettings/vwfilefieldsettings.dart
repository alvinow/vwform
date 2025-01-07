import 'package:json_annotation/json_annotation.dart';
part 'vwfilefieldsettings.g.dart';

@JsonSerializable()
class VwFileFieldSettings{
  VwFileFieldSettings({
    required this.maxUploadFileSizeInMB,
    required this.uploadFileExtension,
    required this.maxUploadFileCount
});

  static const String fileExtensionPdf = "pdf";
  static const String fileExtensionJpg = "jpg";
  static const String fileExtensionPng = "png";

  double maxUploadFileSizeInMB;
  List<String> uploadFileExtension;
  int maxUploadFileCount;

  factory VwFileFieldSettings.fromJson(Map<String, dynamic> json) =>
      _$VwFileFieldSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$VwFileFieldSettingsToJson(this);
}