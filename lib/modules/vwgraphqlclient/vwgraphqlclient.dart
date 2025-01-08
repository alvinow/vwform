import 'dart:convert';
import 'package:http/http.dart' as _http;
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwgraphqlquery/vwgraphqlquery.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwpgraphqlserverresponse/vwgraphqlserverresponse.dart';
import 'package:vwutil/modules/util/vwmultipartrequest/vwmultipartrequest.dart';

class VwGraphQlClient {
  static Future<VwGraphQlServerResponse> httpPostGraphQl(
      {required String url,
      required VwGraphQlQuery graphQlQuery,
      int timeoutSecond = 20}) async {
    String currentUuid = Uuid().v4();
    //print("start Uploading "+currentUuid+": "+DateTime.now().toString());
    VwGraphQlServerResponse returnValue =
        VwGraphQlServerResponse(graphQlQuery: graphQlQuery);
    try {
      Map<String, String> httpHeaders = {
        "Content-Type": "application/json",
      };

      String multipartUrl = AppConfig.baseUrl + "/syncNodeContent";

      http.StreamedResponse? streamedResponse;
      //http.Response? apiHttpResponse;

     if (graphQlQuery.graphQlFunctionName == "apiCall") {

        streamedResponse = await VwMultipartRequest.multipartUpload(
            url: multipartUrl,
            bytes: utf8.encode(json.encode(graphQlQuery.toJson())),
            fileName: graphQlQuery.apiCallId);
        if (streamedResponse != null) {
          returnValue.httpResponse =
              await http.Response.fromStream(streamedResponse);

          Map<String, dynamic> graphQlQueryResponseRoot =
              json.decode(returnValue.httpResponse!.body);
          //returnValue.graphQlQueryResponse = graphQlQueryResponseRoot["data"];

          returnValue.apiCallResponse =
              VwApiCallResponse.fromJson(graphQlQueryResponseRoot);
        }
      } else {
        returnValue.httpResponse = await _http.Client()
            .post(Uri.parse(url),
                headers: httpHeaders, body: json.encode(graphQlQuery.getJSON()))
            .timeout(Duration(seconds: timeoutSecond));

        if (returnValue.httpResponse != null &&
            returnValue.httpResponse!.body != null) {
          Map<String, dynamic> graphQlQueryResponseRoot =
              json.decode(returnValue.httpResponse!.body);

          try {
            returnValue.graphQlQueryResponse = graphQlQueryResponseRoot["data"];
          } catch (error) {
            print("Error catched on VwGraphQlClient.httpPostGraphQl=" +
                error.toString());
          }

          try {
            String apiCallIdKey = returnValue.graphQlQuery.graphQlFunctionName;
            returnValue.apiCallResponse = VwApiCallResponse.fromJson(
                json.decode(returnValue.graphQlQueryResponse![apiCallIdKey]));
          } catch (error) {
            print("Error catched on VwGraphQlClient.httpPostGraphQl=" +
                error.toString());
          }
        }
      }

      if (returnValue.apiCallResponse != null &&
          returnValue.apiCallResponse!.valueResponseClassEncodedJson != null) {
        RemoteApi.decompressClassEncodedJson(
            returnValue.apiCallResponse!.valueResponseClassEncodedJson!);
      }
    } catch (error) {
      print(
          'Error Catched on VwMainServer.Future<http.Response?> httpPostGraphQl({required String url,required String httpPostBody}) : ' +
              error.toString());
    }
    //print("finished Uploading "+currentUuid+": "+DateTime.now().toString());
    return returnValue;
  }
}
