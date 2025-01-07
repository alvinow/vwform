import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient2base/modules/base/nodeexplorerdefinition/nodeexplorerdefinition.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
part 'vwjsonfieldnamecardparameter.g.dart';

@JsonSerializable()
class VwJsonFieldNameCardParameter {
  const VwJsonFieldNameCardParameter(
      {required this.functionName,
      this.nodeExplorerDefinition,
      this.memberList,
      this.staticText,
      this.fieldDisplayFormat});

  final String functionName;
  final NodeExplorerDefinition? nodeExplorerDefinition;
  final List<VwJsonFieldNameCardParameter>? memberList;
  final String? staticText;
  final VwFieldDisplayFormat? fieldDisplayFormat;

  static const String fnConcat = "fnConcat";
  static const String fnNodeExplorer = "fnNodeExplorer";
  static const String fnStatictext = "fnStatictext";

  factory VwJsonFieldNameCardParameter.fromJson(Map<String, dynamic> json) =>
      _$VwJsonFieldNameCardParameterFromJson(json);
  Map<String, dynamic> toJson() => _$VwJsonFieldNameCardParameterToJson(this);
}
