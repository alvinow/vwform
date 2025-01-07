import 'package:matrixclient/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodeupsyncresult/vwnodeupsyncresult.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient/modules/vwgraphqlclient/modules/vwpgraphqlserverresponse/vwgraphqlserverresponse.dart';

part 'vwnodeupsyncresultpackage.g.dart';

@JsonSerializable()
class VwNodeUpsyncResultPackage {

  VwNodeUpsyncResultPackage({required this.nodeUpsyncResultList,this.apiCallResponse});
  List<VwNodeUpsyncResult> nodeUpsyncResultList;
  VwApiCallResponse? apiCallResponse;

  factory VwNodeUpsyncResultPackage.fromJson(Map<String, dynamic> json) =>
      _$VwNodeUpsyncResultPackageFromJson(json);
  Map<String, dynamic> toJson() => _$VwNodeUpsyncResultPackageToJson(this);
}
