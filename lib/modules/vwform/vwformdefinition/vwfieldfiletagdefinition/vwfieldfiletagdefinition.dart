import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vwfieldfiletagdefinition.g.dart';

@JsonSerializable()
class VwFieldFileTagDefinition {
  VwFieldFileTagDefinition(
      {required this.filePageTagFormDefinition,
      required this.tagFormDefinition,
      required this.linkNodeListFieldName});

  VwFormDefinition filePageTagFormDefinition;
  VwFormDefinition tagFormDefinition;
  String linkNodeListFieldName;


  factory VwFieldFileTagDefinition.fromJson(Map<String, dynamic> json) =>
      _$VwFieldFileTagDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$VwFieldFileTagDefinitionToJson(this);
}
