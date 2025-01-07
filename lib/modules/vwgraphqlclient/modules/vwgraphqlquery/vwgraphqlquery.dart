import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
part 'vwgraphqlquery.g.dart';

@JsonSerializable()
class VwGraphQlQuery {
  VwGraphQlQuery(
      {required this.graphQlFunctionName,
      required this.apiCallId,
      this.loginSessionId = "<invalid_login_session_id>",
      required this.parameter});
  final String graphQlFunctionName;
  final String apiCallId;
  String loginSessionId;
  VwRowData parameter;


  String _getParametersInString() {
    String returnValue = "apiCallId:" + json.encode(this.apiCallId) + ",";

    returnValue = returnValue +
        "loginSessionId:" +
        json.encode(this.loginSessionId) +
        ",";


    String  parameterInVwRow=json.encode(json.encode(this.parameter));
    String? parameterinVwRowCompressed=RemoteApi.compressGzipOutputBase64(parameterInVwRow);


    returnValue = returnValue +
        "parameterInVwRow:" +json.encode(parameterinVwRowCompressed!)
        ;

    return returnValue;
  }

  Map<String, dynamic> getJSON() {
    String queryValue = "{" +
        this.graphQlFunctionName +
        "(" +
        this._getParametersInString() +
        ")}";

    Map<String, dynamic> query = {"query": queryValue};

    return query;
  }

  factory VwGraphQlQuery.fromJson(Map<String, dynamic> json) =>
      _$VwGraphQlQueryFromJson(json);
  Map<String, dynamic> toJson() => _$VwGraphQlQueryToJson(this);
}
