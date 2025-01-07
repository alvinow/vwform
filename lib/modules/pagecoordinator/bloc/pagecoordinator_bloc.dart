import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:matrixclient2base/modules/base/vwauthutil/vwauthutil.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:matrixclient2base/modules/base/vwsharedpref/vwloginresponsesharedpref.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vwform/modules/deployedcollectionname.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwgraphqlquery/vwgraphqlquery.dart';
import 'package:vwform/modules/vwgraphqlclient/modules/vwpgraphqlserverresponse/vwgraphqlserverresponse.dart';
import 'package:vwform/modules/vwgraphqlclient/vwgraphqlclient.dart';
import 'package:vwform/modules/vwnodeupsyncresult/vwnodeupsyncresult.dart';
import 'package:vwform/modules/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';
import 'package:vwutil/modules/util/deviceinfoutil.dart';
import 'package:vwutil/modules/util/serversyncutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:web/web.dart';

part 'pagecoordinator_event.dart';
part 'pagecoordinator_state.dart';

class PagecoordinatorBloc
    extends Bloc<PagecoordinatorEvent, PagecoordinatorState> {
  List<VwRowData>? sinkRowDataList;
  VwAppInstanceParam? sinkAppInstanceParam;
  VwLoginResponse? currentLoginResponse;
  GoRouterState? goRouterState;

  bool? syncRowDataActive;

  PagecoordinatorBloc() : super(BootupPagecoordinatorState()) {
    sinkRowDataList = [];

    syncRowDataActive = false;
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (syncRowDataActive == false) {
        await this.executeSinkRowDataList();
      }
    });

    on<BootstrapPagecoordinatorEvent>(this._onBootstrapPagecoordinatorEvent);

    on<PublicLandingPagecoordinatorEvent>(
        this._PublicLandingPagecoordinatorEvent);

    on<CheckauthorizationPagecoordinatorEvent>(
        this._onCheckauthorizationPagecoordinatorEvent);

    on<LoginPagecoordinatorEvent>(this._LoginPagecoordinatorEvent);

    on<LogoutPagecoordinatorEvent>(this._LogoutPagecoordinatorEvent);

    on<AuthorizePagecoordinatorEvent>(this._AuthorizePagecoordinatorEvent);
  }

  void _LoginPagecoordinatorEvent(LoginPagecoordinatorEvent event,
      Emitter<PagecoordinatorState> emit) async {
    VwRowData param = new VwRowData(recordId: Uuid().v4(), fields: []);

    emit(LoginPagecoordinatorState(
      loginParam: param,
    ));
    return;
  }

  Future<void> executeSinkRowDataList() async {
    syncRowDataActive = true;
    try {
      while (this.sinkRowDataList!.length > 0) {
        VwRowData currentRowData = this.sinkRowDataList!.elementAt(0);
        VwNodeUpsyncResultPackage nodeUpsyncResultPackage =
            await ServerSyncUtil.syncNodeRowData(
                rowData: currentRowData,
                loginSessionId:
                sinkAppInstanceParam!.loginResponse!.loginSessionId!,
                ownerUserId:
                sinkAppInstanceParam!.loginResponse!.userInfo!.user.recordId);

        if (nodeUpsyncResultPackage.nodeUpsyncResultList.length > 0) {
          VwNodeUpsyncResult nodeUpsyncResult =
              nodeUpsyncResultPackage.nodeUpsyncResultList.elementAt(0);

          if (nodeUpsyncResult.syncResult.acknowledge == true) {
            this.sinkRowDataList!.removeAt(0);
          }
        }
      }
    } catch (error) {}
    syncRowDataActive = false;
  }

  void sinkSyncRowData(
      {required VwRowData rowData,
      required VwAppInstanceParam appInstanceParam}) async {
    try {
      this.sinkAppInstanceParam = appInstanceParam;
      this.sinkRowDataList!.add(rowData);
    } catch (error) {}
  }

  void _PublicLandingPagecoordinatorEvent(
      PublicLandingPagecoordinatorEvent event,
      Emitter<PagecoordinatorState> emit) async {
    VwLoginResponse? loginResponse =
        await VwAuthUtil.getSavedLoggedInLoginResponseInLocal();

    emit(PublicLandingPagePagecoordinatorState(
        loginResponse: loginResponse,
        standardArticleMaincategory: event.standardArticleMaincategory));
    return;
  }

  void _LogoutPagecoordinatorEvent(LogoutPagecoordinatorEvent event,
      Emitter<PagecoordinatorState> emit) async {
    await VwLoginResponseSharedPref.deleteLoginResponseInstance(
        VwAuthUtil.getClientUserLoggedInBoxName());

    emit(LoadingPagecoordinatorState(
        loadingParam: VwRowData(
            timestamp: VwDateUtil.nowTimestamp(),
            fields: [
              VwFieldValue(
                  fieldName: "caption", valueString: "Proses Logout...")
            ],
            recordId: Uuid().v4())));
    // await Future.delayed(Duration(seconds: 3));
    this.add(BootstrapPagecoordinatorEvent(timestamp: DateTime.now()));
  }

  void _AuthorizePagecoordinatorEvent(AuthorizePagecoordinatorEvent event,
      Emitter<PagecoordinatorState> emit) async {
    bool isAuthorized = false;

    emit(LoadingPagecoordinatorState(
        loadingParam: VwRowData(
            timestamp: VwDateUtil.nowTimestamp(), recordId: Uuid().v4())));
    try {
      String deviceId = await DeviceInfoutil.getDeviceId();

      VwFieldValue fieldValue =
          VwFieldValue(fieldName: 'clientDeviceId', valueString: deviceId);

      if (event.paramAuthorize.fields != null) {
        event.paramAuthorize.fields!.add(fieldValue);
      }

      VwGraphQlQuery graphQlQuery = VwGraphQlQuery(
          graphQlFunctionName: "apiCall",
          apiCallId: 'authUser',
          parameter: event.paramAuthorize);

      VwGraphQlServerResponse graphQlServerResponse =
          await VwGraphQlClient.httpPostGraphQl(
              timeoutSecond: 20,
              url: AppConfig.serverAddress,
              graphQlQuery: graphQlQuery);

      print("Api Call Response Status Code");
      if (graphQlServerResponse.apiCallResponse != null) {
        print(graphQlServerResponse.apiCallResponse!.responseStatusCode
            .toString());

        if (graphQlServerResponse.apiCallResponse!.responseType ==
            VwApiCallResponse.rtClassEncodedJson) {
          if (graphQlServerResponse
                  .apiCallResponse!.valueResponseClassEncodedJson!.className ==
              "VwLoginResponse") {
            try {
              VwLoginResponse loginResponse = VwLoginResponse.fromJson(
                  graphQlServerResponse
                      .apiCallResponse!.valueResponseClassEncodedJson!.data!);

              if (loginResponse.loginStatusCode == 21) {
                isAuthorized = true;
              }
            } catch (error) {
              print("Error catched on _AuthorizePagecoordinatorEvent: " +
                  error.toString());
            }
          }
        }
      }

      if (graphQlServerResponse.httpResponse == null) {
        event.paramAuthorize.fields!.add(VwFieldValue(
            fieldName: 'errorMessage',
            valueString: 'Tidak terhubung ke server'));
        emit(LoginPagecoordinatorState(loginParam: event.paramAuthorize));
        return;
      } else if (isAuthorized == true) {
        VwLoginResponse loginResponse = VwLoginResponse.fromJson(
            graphQlServerResponse
                .apiCallResponse!.valueResponseClassEncodedJson!.data!);

        bool syncVwDbClientResult =
            await VwLoginResponseSharedPref.syncLoginResponseInstance(
                VwAuthUtil.getClientUserLoggedInBoxName(), loginResponse);

        print("syncVwDbClientResult=" + syncVwDbClientResult.toString());

        emit(HomePagecoordinatorState(
            loginResponse: loginResponse,
            homeParam: VwRowData(
                timestamp: VwDateUtil.nowTimestamp(), recordId: Uuid().v4())));
      } else if (event.paramAuthorize.fields != null) {
        event.paramAuthorize.getFieldByName('errorMessage') == null
            ? event.paramAuthorize.fields!.add(VwFieldValue(
                fieldName: 'errorMessage',
                valueString: "Username and or password doesn't match"))
            : true;
        emit(LoginPagecoordinatorState(loginParam: event.paramAuthorize));
      }
      return;
    } catch (error) {
      print("Error catched on _AuthorizePagecoordinatorEvent: " +
          error.toString());
    }

    emit(LoginPagecoordinatorState(loginParam: event.paramAuthorize));
  }

  void _onBootstrapPagecoordinatorEvent(BootstrapPagecoordinatorEvent event,
      Emitter<PagecoordinatorState> emit) async {
    if(event.goRouterState!=null)
      {
        this.goRouterState=event.goRouterState;
      }

    String? authMode = "standard";
    String? appMode = "standard";



    //appMode="ticket99";

    if (AppConfig.showStartSplashScreen == true) {
      emit(InitsplashscreenPagecoordinatorState(
          initsplashscreenParam: VwRowData(
              timestamp: VwDateUtil.nowTimestamp(),
              recordId: Uuid().v4(),
              fields: <VwFieldValue>[
            VwFieldValue(
                fieldName: 'appVersionNumber',
                valueString: AppConfig.appVersion)
          ])));

      await Future.delayed(const Duration(seconds: 2), () {});
    }

    emit(LoadingPagecoordinatorState(
        loadingParam: VwRowData(
            timestamp: VwDateUtil.nowTimestamp(),
            recordId: Uuid().v4(),
            fields: <VwFieldValue>[])));

    //await Future.delayed(const Duration(seconds: 3), () {});

    VwLoginResponse? loginResponse;
    String? formDefinitionId;
    bool isAuthorized = false;
    const bool isWeb = kIsWeb;

    String? url;
    String? articleId;
    if(this.goRouterState!=null)
      {
        if(this.goRouterState!.pathParameters!=null
        && this.goRouterState!.pathParameters!["tiketId"]!=null
        )
          {
            appMode=="ticket99";
            String tiketId =this.goRouterState!.pathParameters!["tiketId"]!;

            print("tiketId="+tiketId);





                VwFieldValue regCodeFieldValue =
                VwFieldValue(fieldName: "regCode", valueString: tiketId);


                VwFieldValue nodeIdFieldValue = VwFieldValue(
                    fieldName: "nodeId",
                    valueString: "ed5beb58-0c27-4f2d-8c0e-6510dd238b78");

                VwRowData apiCallParameter = VwRowData(
                    recordId: Uuid().v4(), fields: [regCodeFieldValue, nodeIdFieldValue]);

                VwNodeRequestResponse nodeRequestResponse =
                await RemoteApi.nodeRequestApiCall(
                    apiCallId: 'getNodes',
                    apiCallParam: apiCallParameter,
                    loginSessionId: "<invalid_loginsession_id>");

                if (nodeRequestResponse.renderedNodePackage != null &&
                    nodeRequestResponse.renderedNodePackage!.renderedNodeList !=
                        null) {
                  if (nodeRequestResponse
                      .renderedNodePackage!.renderedNodeList!.length >
                      0) {
                    //valid ticket
                    VwNode regInfoNode = nodeRequestResponse
                        .renderedNodePackage!.renderedNodeList!
                        .elementAt(0);
                    emit(RegInfoPagePagecoordinatorState (
                        regCode: tiketId, regInfoNode: regInfoNode));
                    print("valid tiket");
                    return;
                  }
                }


          }

        print("invalid ticket");
        emit(RegInfoPagePagecoordinatorState (
            regCode: "<invalid_ticket_id>"));

        return;

      }

    /*

    else if (isWeb && event.url != null) {



      url = event.url!;

      print("url=" + url);

      if (url != null) {



        Uri uri = Uri.parse(url);

        String? regCode = uri.queryParameters["regCode"] != null
            ? uri.queryParameters["regCode"]
            : null;


        print(regCode.toString());




        String? loginSessionId = uri.queryParameters["loginSessionId"] != null
            ? uri.queryParameters["loginSessionId"]
            : null;

        articleId = uri.queryParameters["articleId"] != null
            ? uri.queryParameters["articleId"]
            : null;

        ticketCode = uri.queryParameters["ticketCode"] != null
            ? uri.queryParameters["ticketCode"]
            : ticketCode;

        authMode = uri.queryParameters["authMode"] != null
            ? uri.queryParameters["authMode"]
            : authMode;
        appMode = uri.queryParameters["appMode"] != null
            ? uri.queryParameters["appMode"]
            : appMode;
        formDefinitionId = uri.queryParameters["formDefinitionId"];

        String? otpCode = uri.queryParameters["otpCode"];

        print("authMode=" + authMode.toString());
        print("appMode=" + appMode.toString());
        print("formDefinitionId=" + formDefinitionId.toString());


        if(regCode!=null)
          {
            appMode="ticket99";
          }

        if(appMode=="ticket99")
          {
            if(regCode !=null)
            {
              appMode = "regInfo";

              VwFieldValue regCodeFieldValue =
              VwFieldValue(fieldName: "regCode", valueString: regCode);


              VwFieldValue nodeIdFieldValue = VwFieldValue(
                  fieldName: "nodeId",
                  valueString: "ed5beb58-0c27-4f2d-8c0e-6510dd238b78");

              VwRowData apiCallParameter = VwRowData(
                  recordId: Uuid().v4(), fields: [regCodeFieldValue, nodeIdFieldValue]);

              VwNodeRequestResponse nodeRequestResponse =
              await RemoteApi.nodeRequestApiCall(
                  apiCallId: 'getNodes',
                  apiCallParam: apiCallParameter,
                  loginSessionId: "<invalid_loginsession_id>");

              if (nodeRequestResponse.renderedNodePackage != null &&
                  nodeRequestResponse.renderedNodePackage!.renderedNodeList !=
                      null) {
                if (nodeRequestResponse
                    .renderedNodePackage!.renderedNodeList!.length >
                    0) {
                  //valid ticket
                  VwNode regInfoNode = nodeRequestResponse
                      .renderedNodePackage!.renderedNodeList!
                      .elementAt(0);
                  emit(RegInfoPagePagecoordinatorState (
                      regCode: regCode, regInfoNode: regInfoNode));
                  print("valid ticket");
                  return;
                } else {
                  //invalid ticket
                  print("invalid ticket");
                  emit(RegInfoPagePagecoordinatorState (
                      regCode: regCode));
                  print("invalid ticket");
                  return;
                }
              }

            }
            else{
              print("invalid ticket");
              emit(RegInfoPagePagecoordinatorState (
                  regCode: "<invalid_ticket_id>"));
              print("invalid ticket");
              return;
            }
          }

        else if (ticketCode != null) {
          //view ticket & RVSP status
          appMode = "ticketUserRvsp";

          //get ticket detail then show
          VwFieldValue ticketCodeString =
              VwFieldValue(fieldName: "ticketCode", valueString: ticketCode);

          VwFieldValue nodeIdString = VwFieldValue(
              fieldName: "nodeId",
              valueString: "3c1fb10f-4bb9-47cd-82ed-c09ddf497da5");

          VwRowData apiCallParameter = VwRowData(
              recordId: Uuid().v4(), fields: [ticketCodeString, nodeIdString]);

          VwNodeRequestResponse nodeRequestResponse =
              await RemoteApi.nodeRequestApiCall(
                  apiCallId: 'getNodes',
                  apiCallParam: apiCallParameter,
                  loginSessionId: "<invalid_loginsession_id>");

          if (nodeRequestResponse.renderedNodePackage != null &&
              nodeRequestResponse.renderedNodePackage!.renderedNodeList !=
                  null) {
            if (nodeRequestResponse
                    .renderedNodePackage!.renderedNodeList!.length >
                0) {
              //valid ticket
              VwNode ticketNode = nodeRequestResponse
                  .renderedNodePackage!.renderedNodeList!
                  .elementAt(0);
              emit(UserRvspTicketPagePagecoordinatorState(
                  ticketCode: ticketCode, ticketNode: ticketNode));
              print("valid ticket");
              return;
            } else {
              //invalid ticket
              print("invalid ticket");
              emit(UserRvspTicketPagePagecoordinatorState(
                  ticketCode: ticketCode));
              return;
            }
          }
        } else if (authMode == "otp" && otpCode != null) {
          VwFieldValue otpCodeString =
              VwFieldValue(fieldName: "otpCode", valueString: otpCode);

          VwRowData apiCallParameter =
              VwRowData(recordId: otpCode, fields: [otpCodeString]);

          VwGraphQlQuery graphQlQuery = VwGraphQlQuery(
              graphQlFunctionName: "apiCall",
              apiCallId: 'loginByOtpCode',
              parameter: apiCallParameter);

          VwGraphQlServerResponse graphQlServerResponse =
              await VwGraphQlClient.httpPostGraphQl(
                  timeoutSecond: 20,
                  url: AppConfig.serverAddress,
                  graphQlQuery: graphQlQuery);

          try {
            VwLoginResponse currentLoginResponse = VwLoginResponse.fromJson(
                graphQlServerResponse
                    .apiCallResponse!.valueResponseClassEncodedJson!.data!);

            print(
                "loginResponse=" + json.encode(currentLoginResponse.toJson()));
            if (currentLoginResponse.loginStatusCode == 21) {
              isAuthorized = true;
              loginResponse = currentLoginResponse;

              bool syncVwDbClientResult =
                  await VwLoginResponseSharedPref.syncLoginResponseInstance(
                      VwAuthUtil.getClientUserLoggedInBoxName(), loginResponse);
            }
          } catch (error) {}
        } else if (loginSessionId != null && authMode == "loginBySessionId") {
          VwFieldValue loginSessionIdString = VwFieldValue(
              fieldName: "loginSessionId", valueString: loginSessionId);

          VwRowData apiCallParameter = VwRowData(
              recordId: loginSessionId, fields: [loginSessionIdString]);

          VwGraphQlQuery graphQlQuery = VwGraphQlQuery(
              graphQlFunctionName: "apiCall",
              apiCallId: 'loginBySessionId',
              parameter: apiCallParameter);

          VwGraphQlServerResponse graphQlServerResponse =
              await VwGraphQlClient.httpPostGraphQl(
                  timeoutSecond: 20,
                  url: AppConfig.serverAddress,
                  graphQlQuery: graphQlQuery);

          try {
            VwLoginResponse currentLoginResponse = VwLoginResponse.fromJson(
                graphQlServerResponse
                    .apiCallResponse!.valueResponseClassEncodedJson!.data!);

            print(
                "loginResponse=" + json.encode(currentLoginResponse.toJson()));
            if (currentLoginResponse.loginStatusCode == 21) {
              isAuthorized = true;
              loginResponse = currentLoginResponse;
            }
          } catch (error) {}
        }
      }
    }
*/
    if(appMode=="standard")
      {

        if (isAuthorized == false &&
            loginResponse == null &&
            authMode == "standard") {
          loginResponse = await VwLoginResponseSharedPref.getLoginResponseInstance(
              VwAuthUtil.getClientUserLoggedInBoxName());
        }


        if (loginResponse != null) {
          try {
            print("on bootup login status code=" +
                loginResponse.loginStatusCode.toString());

            if (loginResponse.loginStatusCode == 21) {
              if (appMode == "newSpecifiedForm" && formDefinitionId != null) {
                VwRowData currentApiCallQueryFormDefinition = VwRowData(
                    timestamp: VwDateUtil.nowTimestamp(),
                    recordId: Uuid().v4(),
                    fields: <VwFieldValue>[
                      VwFieldValue(
                          fieldName: "nodeId",
                          valueString: "response_" +
                              DeployedCollectionName.vwFormDefinition),
                      VwFieldValue(fieldName: "depth", valueNumber: 1),
                      VwFieldValue(
                          fieldName: "sortObject",
                          valueTypeId: VwFieldValue.vatObject,
                          value: {"displayName": 1}),
                      VwFieldValue(
                          fieldName: "depth1FilterObject",
                          valueTypeId: VwFieldValue.vatObject,
                          value: {
                            "content.contentContext.className": "VwFormDefinition"
                          })
                    ]);

                VwNodeRequestResponse nodeRequestResponse =
                await RemoteApi.nodeRequestApiCall(
                    apiCallId: "getNodes",
                    apiCallParam: currentApiCallQueryFormDefinition,
                    loginSessionId: loginResponse.loginSessionId!);

                if (nodeRequestResponse.apiCallResponse != null) {
                  if (nodeRequestResponse.renderedNodePackage != null &&
                      nodeRequestResponse.renderedNodePackage!.renderedNodeList !=
                          null) {
                    for (int la = 0;
                    la <
                        nodeRequestResponse
                            .renderedNodePackage!.renderedNodeList!.length;
                    la++) {
                      VwNode currentNode = nodeRequestResponse
                          .renderedNodePackage!.renderedNodeList!
                          .elementAt(la);

                      if (currentNode.recordId == formDefinitionId) {
                        VwFormDefinition formDefinition = VwFormDefinition.fromJson(
                            currentNode.content.classEncodedJson!.data!);

                        VwRowData formResponse = VwFormDefinitionUtil
                            .createBlankRowDataFromFormDefinition(
                            formDefinition: formDefinition,
                            ownerUserId:
                            loginResponse!.userInfo!.user.recordId);

                        VwRowData currentApiCallContainerFormDefinition = VwRowData(
                            timestamp: VwDateUtil.nowTimestamp(),
                            recordId: Uuid().v4(),
                            fields: <VwFieldValue>[
                              VwFieldValue(
                                  fieldName: "nodeId",
                                  valueString:
                                  "response_" + formDefinition.recordId),
                              VwFieldValue(fieldName: "depth", valueNumber: 1),
                              VwFieldValue(
                                  fieldName: "sortObject",
                                  valueTypeId: VwFieldValue.vatObject,
                                  value: {"displayName": 1}),
                              VwFieldValue(
                                  fieldName: "depth1FilterObject",
                                  valueTypeId: VwFieldValue.vatObject,
                                  value: {"nodeType": "ntnFolder"})
                            ]);

                        VwNodeRequestResponse
                        nodeRequestResponseContainerFormDefinition =
                        await RemoteApi.nodeRequestApiCall(
                            apiCallId: "getNodes",
                            apiCallParam: currentApiCallContainerFormDefinition,
                            loginSessionId: loginResponse.loginSessionId!);

                        emit(NewFormRecordState(
                            containerFolderNode:
                            nodeRequestResponseContainerFormDefinition
                                .renderedNodePackage!.rootNode!,
                            loginResponse: loginResponse,
                            formDefinition: formDefinition,
                            formResponse: formResponse));
                        return;
                      }
                    }
                  }
                }
              } else {
                if (articleId != null) {
                  emit(ViewArticleState(
                    articleId: articleId,
                    autoplay: true,
                    loginResponse: loginResponse,
                  ));
                  return;
                } else {
                  emit(HomePagecoordinatorState(
                      loginResponse: loginResponse,
                      homeParam: VwRowData(
                          timestamp: VwDateUtil.nowTimestamp(),
                          recordId: Uuid().v4())));
                  return;
                }
              }
            }
          } catch (error) {
            print(error);
          }
        }
      }





    if (articleId != null) {
      emit(ViewArticleState(
        articleId: articleId,
        autoplay: true,
      ));
      return;
    }
    else
      {
        if(AppConfig.appId=="edokumen")
          {
            emit(LoginPagecoordinatorState(loginParam: VwRowData(fields: [], recordId: Uuid().v4())));
          }
        else
          {
            emit(PublicLandingPagePagecoordinatorState(
                loginResponse: loginResponse, standardArticleMaincategory: "beranda"));
            return;
          }

      }


  }



  void _onCheckauthorizationPagecoordinatorEvent(
      CheckauthorizationPagecoordinatorEvent event,
      Emitter<PagecoordinatorState> emit) async {
    bool isAuthorized = false;

    emit(LoadingPagecoordinatorState(
        loadingParam: VwRowData(
            timestamp: VwDateUtil.nowTimestamp(),
            recordId: Uuid().v4(),
            fields: <VwFieldValue>[])));

    VwLoginResponse? loginResponse =
        await VwAuthUtil.getSavedLoggedInLoginResponseInLocal();

    if (loginResponse != null) {
      try {
        emit(HomePagecoordinatorState(
            loginResponse: loginResponse,
            homeParam: VwRowData(
                timestamp: VwDateUtil.nowTimestamp(),
                recordId: Uuid().v4(),
                fields: <VwFieldValue>[])));
        return;
      } catch (error) {}
    } else {
      emit(PublicLandingPagePagecoordinatorState(
          standardArticleMaincategory: "beranda"));
      return;
    }
  }
}
