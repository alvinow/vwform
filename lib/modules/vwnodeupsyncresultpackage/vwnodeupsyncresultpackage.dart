import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwnodeupsyncresult/vwnodeupsyncresult.dart';

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
