import 'package:http/http.dart' as _http;
import 'package:matrixclient/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:matrixclient/modules/vwgraphqlclient/modules/vwgraphqlquery/vwgraphqlquery.dart';

class VwGraphQlServerResponse {
  VwGraphQlServerResponse(
      {required this.graphQlQuery,
      this.httpResponse,
      this.graphQlQueryResponse});
  Map<String, dynamic>? graphQlQueryResponse;
  _http.Response? httpResponse;
  VwApiCallResponse? apiCallResponse;
  VwGraphQlQuery graphQlQuery;


}
