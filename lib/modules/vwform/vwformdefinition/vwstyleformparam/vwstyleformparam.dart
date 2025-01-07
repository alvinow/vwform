import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';



part 'vwstyleformparam.g.dart';

@JsonSerializable()
class VwStyleFormParam {
  final double verticalSpacing;
  final double fontSize;
  final String baseColorHex;
  final String windowColorHex;
  final bool showFormTitle;
  final List<VwRowData>? additionalParameters;

  const VwStyleFormParam(
      {this.verticalSpacing = 15,
      this.fontSize = 13,
      this.baseColorHex = "#1d5885",
      this.windowColorHex = "#adb3b8",
      this.showFormTitle = false,
      this.additionalParameters });

  factory VwStyleFormParam.fromJson(Map<String, dynamic> json) =>
      _$VwStyleFormParamFromJson(json);
  Map<String, dynamic> toJson() => _$VwStyleFormParamToJson(this);
}
