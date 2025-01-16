import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodeaccessrendered/vwnodeaccessrendered.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:matrixclient2base/modules/base/vwrenderednodepackage/vwrenderednodepackage.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwgraphqlquery/vwgraphqlquery.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwpgraphqlserverresponse/vwgraphqlserverresponse.dart';
import 'package:vwform/modules/vwgraphqlclient/vwgraphqlclient.dart';
import 'package:vwform/modules/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';



// ignore: avoid_classes_with_only_static_members
class RemoteApi {

  static Uint8List? decryptAes( String fileBase64,VwFileStorage fileStorage)
  {
    Uint8List? returnValue;
    try
        {
          final keyAES =
          Key.fromBase64(fileStorage.fileEncryption!.encryptionKey);
          final iv =
          IV.fromBase64(fileStorage.fileEncryption!.encryptionIV!);

          final encrypter = Encrypter(AES(keyAES, mode: AESMode.cbc));

          final String decryptedBase64 =encrypter.decrypt64(fileBase64, iv: iv);

          returnValue = base64Decode(decryptedBase64);
        }
        catch(error)
    {

    }
    return returnValue;
  }

  static Future<VwNodeRequestResponse> getListSpmNodeWithChildNode(
      {
        required String baseUrl,
        required String graphqlServerAddress,
        required VwRowData apiCallParam, required String loginSessionId}) async {
    VwNodeRequestResponse returnValue = VwNodeRequestResponse();
    try {
      List<VwNode> renderedNodeList = [];

      VwNodeRequestResponse nodeRequestResponse =
          await RemoteApi.nodeRequestApiCall(
            baseUrl: baseUrl,
            graphqlServerAddress: graphqlServerAddress,
              apiCallId: 'getSpmFeed',
              apiCallParam: apiCallParam,
              loginSessionId: loginSessionId);

      returnValue = nodeRequestResponse;

      //restucturing Node
      if (nodeRequestResponse.renderedNodePackage != null &&
          nodeRequestResponse.renderedNodePackage!.renderedNodeList != null) {
        List<VwNode> rawNodeList =
            nodeRequestResponse.renderedNodePackage!.renderedNodeList!;
        for (int la = 0; la < rawNodeList.length; la++) {
          VwNode currentRenderedNode = rawNodeList.elementAt(la);

          if (currentRenderedNode.nodeType == "ntnFolder" &&
              currentRenderedNode.content.classEncodedJson != null &&
              currentRenderedNode.content.classEncodedJson!.className ==
                  "spmInduk2021") {
            List<VwNode> childNodes = [];
            for (int lmember = 0; lmember < rawNodeList.length; lmember++) {
              VwNode currentMember = rawNodeList.elementAt(lmember);
              String className = currentMember.content.classEncodedJson == null
                  ? "<invalid_class_name>"
                  : currentMember.content.classEncodedJson!.className == null
                      ? "<invalid_class_name>"
                      : currentMember.content.classEncodedJson!.className;

              if (className == "VwFormResponse" || className == "spmMak2021") {
                childNodes.add(currentMember);
              }
            }

            if(currentRenderedNode.nodeAccessRendered==null)
              {
                currentRenderedNode.nodeAccessRendered=VwNodeAccessRendered(renderedDate: DateTime.now());
              }

            currentRenderedNode.nodeAccessRendered!.renderedChildNodes = childNodes;
            renderedNodeList.add(currentRenderedNode);
          }
        }

        nodeRequestResponse.renderedNodePackage!.renderedNodeList =
            renderedNodeList;
      }
      returnValue = nodeRequestResponse;
    } catch (error) {
      print("Error catched on getListSpmNodeWithChildNode=" + error.toString());
    }

    return returnValue;
  }

 static String? compressGzipOutputBase64(String text){
  try
      {
        String textBase64 = base64.encode(utf8.encode(text));

        Uint8List dataDecompressedUint8List= base64Decode(textBase64);


        List<int>? dataCompressedListInt= GZipEncoder().encode(List<int>.from(dataDecompressedUint8List),level:3);

        String dataCompressedBase64= base64Encode(dataCompressedListInt!);

        return dataCompressedBase64;



      }
      catch(error)
   {
    print("error catched on compressGzipOutputBase6: "+error.toString());
   }
   return null;
  }


  static compressClassEncodedJson(VwClassEncodedJson input){
    try
    {
      if(input.data!=null )
      {


        String? dataText=json.encode(input.data);



        String? dataBase64 = base64.encode(utf8.encode(dataText));
        dataText=null;


        Uint8List? dataCompressedUint8List= base64Decode(dataBase64);
        dataBase64=null;




        //List<int> dataCompressedListInt=GZipCodec().encode(List<int>.from(dataCompressedUint8List));
        List<int>? dataCompressedListInt=GZipEncoder().encode(List<int>.from(dataCompressedUint8List),level:3);
        dataCompressedUint8List=null;

        String dataCompressedBase64= base64Encode(dataCompressedListInt!);
        dataCompressedListInt=[];




        input.dataCompressedBase64=dataCompressedBase64;
        input.isCompressed=true;
        input.compressionType=VwClassEncodedJson.cptGzip;
        input.data=null;


      }

    }
    catch(error)
    {

    }
  }

  static void decompressClassEncodedJson(VwClassEncodedJson input){
    try
        {
          if(input.isCompressed==true && input.dataCompressedBase64!=null )
            {


             Uint8List dataCompressedUint8List= base64Decode(input.dataCompressedBase64!);



             List<int> dataUncompressedListInt=GZipDecoder().decodeBytes(List<int>.from(dataCompressedUint8List));
             String dataUncompressedBase64= base64Encode(dataUncompressedListInt);



             String data = utf8.decode(base64.decode(dataUncompressedBase64));

             input.data=json.decode(data);
             input.dataCompressedBase64=null;
             input.isCompressed=false;
             input.compressionType=null;



            }

        }
        catch(error)
    {
      print("Error catched on decompress json="+error.toString());
    }
  }

  static Future<VwApiCallResponse?> requestApiCall(
      {
        required String baseUrl,
        required String graphqlServerAddress,  required String apiCallId, required VwRowData apiCallParam, required String loginSessionId}
      ) async{
    VwApiCallResponse? returnValue;
    try
        {
          VwGraphQlQuery graphQlQuery = VwGraphQlQuery(
              graphQlFunctionName: "apiCall",
              apiCallId: apiCallId,
              loginSessionId: loginSessionId,
              parameter: apiCallParam);

          VwGraphQlServerResponse graphQlServerResponse =
          await VwGraphQlClient.httpPostGraphQl(
            baseUrl: baseUrl,
              timeoutSecond: 20,
              url: graphqlServerAddress,
              graphQlQuery: graphQlQuery);

          if(graphQlServerResponse.apiCallResponse!=null &&
              graphQlServerResponse.apiCallResponse!.valueResponseClassEncodedJson!=null
          ) {
            RemoteApi.decompressClassEncodedJson(
                graphQlServerResponse.apiCallResponse!
                    .valueResponseClassEncodedJson!);
          }
          returnValue= graphQlServerResponse.apiCallResponse;

        }
        catch(error)
    {

    }
    return returnValue;

  }

  static Future<VwNodeUpsyncResultPackage> nodeUpsyncRequestApiCall(
      {required String baseUrl, required String graphqlServerAddress, required VwRowData apiCallParam, required String loginSessionId,required String apiCallId}) async {
    VwNodeUpsyncResultPackage returnValue =
        VwNodeUpsyncResultPackage(nodeUpsyncResultList: []);

    try {





      VwGraphQlQuery graphQlQuery = VwGraphQlQuery(
          graphQlFunctionName: "apiCall",
          apiCallId: apiCallId,
          loginSessionId: loginSessionId,
          parameter: apiCallParam);


      VwGraphQlServerResponse graphQlServerResponse =
          await VwGraphQlClient.httpPostGraphQl(
            baseUrl: baseUrl,
              timeoutSecond: 240,
              url: graphqlServerAddress,
              graphQlQuery: graphQlQuery);


      if (graphQlServerResponse.httpResponse != null &&
          graphQlServerResponse.httpResponse!.statusCode != null &&
          graphQlServerResponse.httpResponse!.statusCode == 200) {
        if (graphQlServerResponse.apiCallResponse!.valueResponseClassEncodedJson!.className =="VwNodeUpsyncResultPackage") {
          returnValue = VwNodeUpsyncResultPackage.fromJson(graphQlServerResponse.apiCallResponse!.valueResponseClassEncodedJson!.data!);
        }
      }
      returnValue.apiCallResponse = graphQlServerResponse.apiCallResponse;
    }
    catch (error) {
      print("Error catched on RemoteApi.nodeUpsyncRequestApiCall: " +error.toString());
    }

    return returnValue;
  }

  static VwRenderedNodePackage
  getVwRenderedNodePackageFromGraphQlServerResponse(
      VwGraphQlServerResponse graphQlServerResponse) {
    VwRenderedNodePackage returnValue = VwRenderedNodePackage(
        renderedNodeList: [],
        recordId: Uuid().v4(),
        timestamp: VwDataFormatTimestamp(
            created: DateTime.now(), updated: DateTime.now()));

    try {
      if (graphQlServerResponse.apiCallResponse != null) {
        print(graphQlServerResponse.apiCallResponse!.responseStatusCode
            .toString());

        if (graphQlServerResponse.apiCallResponse!.responseType ==
            VwApiCallResponse.rtClassEncodedJson) {
          if (graphQlServerResponse
              .apiCallResponse!.valueResponseClassEncodedJson!.className ==
              "VwRenderedNodePackage") {

            RemoteApi.decompressClassEncodedJson(graphQlServerResponse
                .apiCallResponse!.valueResponseClassEncodedJson!);

            returnValue = VwRenderedNodePackage.fromJson(graphQlServerResponse
                .apiCallResponse!.valueResponseClassEncodedJson!.data!);
          }
        }
      }
    } catch (error) {
      print(
          "Error catched on getVwRenderedNodePackageFromGraphQlServerResponse:" +
              error.toString());
    }
    return returnValue;
  }


  static Future<VwNodeRequestResponse> nodeRequestApiCall(
      {
        required String baseUrl,
        required String apiCallId,
        required String graphqlServerAddress,
      required VwRowData apiCallParam,
      required String loginSessionId}) async {
    VwNodeRequestResponse returnValue = VwNodeRequestResponse();
    try {
      VwGraphQlQuery graphQlQuery = VwGraphQlQuery(
          graphQlFunctionName: "apiCall",
          apiCallId: apiCallId,
          loginSessionId: loginSessionId,
          parameter: apiCallParam);

      VwGraphQlServerResponse graphQlServerResponse =await VwGraphQlClient.httpPostGraphQl(baseUrl: baseUrl, timeoutSecond: 60,url: graphqlServerAddress,graphQlQuery: graphQlQuery);

      if (graphQlServerResponse.httpResponse != null) {
        returnValue.httpResponse = graphQlServerResponse.httpResponse;
      }

      if (graphQlServerResponse.httpResponse != null &&
          graphQlServerResponse.httpResponse!.statusCode != null &&
          graphQlServerResponse.httpResponse!.statusCode == 200) {
        VwRenderedNodePackage renderedNodePackage =
            RemoteApi.getVwRenderedNodePackageFromGraphQlServerResponse(
                graphQlServerResponse);

        returnValue.apiCallResponse = graphQlServerResponse.apiCallResponse;
        returnValue.renderedNodePackage = renderedNodePackage;

        if (apiCallId == "getSpmFeed") {
          List<VwNode> renderedNodeList = [];
          if (returnValue.renderedNodePackage != null &&
              returnValue.renderedNodePackage!.renderedNodeList != null) {
            List<VwNode> rawNodeList =
                returnValue.renderedNodePackage!.renderedNodeList!;
            for (int la = 0; la < rawNodeList.length; la++) {
              VwNode currentRenderedNode = rawNodeList.elementAt(la);

              if (currentRenderedNode.nodeType == "ntnFolder" &&
                  currentRenderedNode.content.classEncodedJson != null &&
                  currentRenderedNode.content.classEncodedJson!.className ==
                      "spmInduk2021") {
                List<VwNode> childNodes = [];
                for (int lmember = 0; lmember < rawNodeList.length; lmember++) {
                  VwNode currentMember = rawNodeList.elementAt(lmember);
                  String className = currentMember.content.classEncodedJson ==
                          null
                      ? "<invalid_class_name>"
                      : currentMember.content.classEncodedJson!.className ==
                              null
                          ? "<invalid_class_name>"
                          : currentMember.content.classEncodedJson!.className;

                  if (className == "VwFormResponse" ||
                      className == "spmMak2021") {
                    childNodes.add(currentMember);
                  }
                }

                if(currentRenderedNode.nodeAccessRendered==null)
                  {
                    currentRenderedNode.nodeAccessRendered=VwNodeAccessRendered(renderedDate: DateTime.now());
                  }

                currentRenderedNode.nodeAccessRendered!.renderedChildNodes = childNodes;
                renderedNodeList.add(currentRenderedNode);
              }
            }

            returnValue.renderedNodePackage!.renderedNodeList =
                renderedNodeList;
          }
        }
      }
    } catch (error) {
      print(
          "Error catched on getListSpmNodeWithChildNode: " + error.toString());
    }
    return returnValue;
  }
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

// ignore: avoid_classes_with_only_static_members
class _ApiUrlBuilder {
  static const _baseUrl = 'https://www.breakingbadapi.com/api/';
  static const _charactersResource = 'characters/';

  static Uri characterList(
    int offset,
    int limit, {
    String? searchTerm,
  }) =>
      Uri.parse(
        '$_baseUrl$_charactersResource?'
        'offset=$offset'
        '&limit=$limit'
        '${_buildSearchTermQuery(searchTerm)}',
      );

  static String _buildSearchTermQuery(String? searchTerm) =>
      searchTerm != null && searchTerm.isNotEmpty
          ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
          : '';
}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}
