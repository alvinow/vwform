import 'package:json_annotation/json_annotation.dart';
part 'vwmongodbfilterparameter.g.dart';

@JsonSerializable()
class VwMongoDbFilterParameter{
  VwMongoDbFilterParameter({
   this.sort,
   this.filter,
   this.projection,
   this.collation
});

  Map<String,dynamic>? sort;
  Map<String,dynamic>? filter;
  Map<String,dynamic>? projection;
  Map<String,dynamic>? collation;

  factory VwMongoDbFilterParameter.fromJson(Map<String, dynamic> json) =>
      _$VwMongoDbFilterParameterFromJson(json);
  Map<String, dynamic> toJson() => _$VwMongoDbFilterParameterToJson(this);
}