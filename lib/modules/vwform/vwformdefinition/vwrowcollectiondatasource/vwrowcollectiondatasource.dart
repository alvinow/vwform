import 'package:matrixclient/modules/base/vwdataformat/vwrowcollectiondefinition/vwrowcollectiondefinition.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdefinition/vwrowdefinition.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vwrowcollectiondatasource.g.dart';

@JsonSerializable()
class VwRowCollectionDataSource {
  VwRowCollectionDataSource(
      {required this.rowCollectionDefinitionId,
      this.renderedRowCollectionDefinition,
      this.renderedRowDefinition});

  String rowCollectionDefinitionId;
  VwRowCollectionDefinition? renderedRowCollectionDefinition;
  VwRowDefinition? renderedRowDefinition;

  factory VwRowCollectionDataSource.fromJson(Map<String, dynamic> json) =>
      _$VwRowCollectionDataSourceFromJson(json);
  Map<String, dynamic> toJson() => _$VwRowCollectionDataSourceToJson(this);
}
