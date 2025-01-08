import 'package:http/http.dart' as _http;
import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwgraphqlquery/vwgraphqlquery.dart';


class VwGraphQlServerResponse {
  VwGraphQlServerResponse(
      {required this.graphQlQuery,
      this.httpResponse,
      this.graphQlQueryResponse});
  Map<String, dynamic>? graphQlQueryResponse;
  _http.Response? httpResponse;
  VwApiCallResponse ? apiCallResponse;
  VwGraphQlQuery graphQlQuery;


}
