import 'package:matrixclient2base/modules/base/store/vwsyncresult/vwsyncresult.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vwnodeupsyncresult.g.dart';

@JsonSerializable()
class VwNodeUpsyncResult {
  VwNodeUpsyncResult({this.formValidationResponse, required this.syncResult, required this.nodeId,required this.isTokenValid});

  VwFormValidationResponse? formValidationResponse;
  VwSyncResult syncResult;
  String nodeId;
  bool isTokenValid;

  factory VwNodeUpsyncResult.fromJson(Map<String, dynamic> json) =>
      _$VwNodeUpsyncResultFromJson(json);
  Map<String, dynamic> toJson() => _$VwNodeUpsyncResultToJson(this);
}
