import 'package:json_annotation/json_annotation.dart';
part 'vwdatasourcedefinition.g.dart';

@JsonSerializable()

class VwDataSourceDefinition {
  VwDataSourceDefinition(
      {this.folderNodeId,
        this.folderNodeMode=VwDataSourceDefinition.folderNodeModeStatic,
        this.folderUpNodeRowDataSearchParameter,
        this.sortObject,
        this.disableRenderFormDefinition=false,
        this.collectionNameList,
      required this.syncMode,
      this.nodeFilter,
      this.fieldLocalFieldRefList
      });

  final String? folderNodeId;
  final bool? disableRenderFormDefinition;
  final dynamic sortObject;
  final List<String>? collectionNameList;
  final String syncMode;
  final VwMongoDbFilterParameter? nodeFilter;
  final List<VwFieldLocalFieldRef>? fieldLocalFieldRefList;
  final String folderNodeMode;
  final VwUpNodeRowDataSearchParameter? folderUpNodeRowDataSearchParameter;

  static const String smParent = "smParent";
  static const String smServer = "smServer";
  static const String folderNodeModeStatic = "folderNodeModeStatic";
  static const String folderUpNodeRowDataSearch = "folderUpNodeRowDataSearch";

  factory VwDataSourceDefinition.fromJson(
      Map<String, dynamic> json) =>
      _$VwDataSourceDefinitionFromJson(json);
  Map<String, dynamic> toJson() =>
      _$VwDataSourceDefinitionToJson(this);
}
