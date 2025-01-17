import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/apivirtualnode/apivirtualnode.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/homepage/vwhomepage.dart';
import 'package:nodelistview/modules/reginfopage/reginfopage.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/loginpage/loginpage.dart';
import 'package:vwform/modules/mediaviewerpage/mediaviewerpage.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/publiclandingpage/publiclandingpage.dart';
import 'package:vwform/modules/splashscreens/mainsplash1/mainsplash1.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/vwloadingpage/vwloadingpage.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class PageCoordinator extends StatelessWidget {
  PageCoordinator(
      {super.key,
      this.goRouterState,
      this.url,
      required this.baseUrl,
      required this.locale,
      required this.baseAppConfig
      });

  final String? url;
  GoRouterState? goRouterState;
  final String baseUrl;
  final String locale;
  final BaseAppConfig baseAppConfig;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => PagecoordinatorBloc()
                ..add(BootstrapPagecoordinatorEvent(
                    goRouterState: goRouterState,
                    url: url,
                    timestamp: DateTime.now())))
        ],
        child: BodyPageCoordinator(
          locale: this.baseUrl,
          baseUrl: this.baseUrl,
          baseAppConfig: this.baseAppConfig,
        ));
  }
}

class BodyPageCoordinator extends StatelessWidget {
  const BodyPageCoordinator({required this.baseUrl, required this.locale,required this.baseAppConfig});

  final String baseUrl;
  final String locale;
  final BaseAppConfig baseAppConfig;

  void viewArticleBackFunction(
      VwAppInstanceParam appInstanceParam, BuildContext buildContext) {
    appInstanceParam.appBloc
        .add(PublicLandingPagecoordinatorEvent(timestamp: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagecoordinatorBloc, PagecoordinatorState>(
        builder: (context, state) {
      PagecoordinatorBloc bloc = context.read<PagecoordinatorBloc>();

      if (state is LoadingPagecoordinatorState) {
        String? caption = "Loading...";
        if (state.loadingParam.getFieldByName("caption") != null) {
          caption = state.loadingParam.getFieldByName("caption")!.valueString;
        }

        return VwLoadingPage(
            title: caption,
            initsplashscreenParam: VwRowData(
                timestamp: VwDateUtil.nowTimestamp(), recordId: Uuid().v4()));
      }
      if (state is HomePagecoordinatorState) {
        Key key = Key("HomePagecoordinatorState");

        VwAppInstanceParam appInstanceParam = VwAppInstanceParam(
          baseAppConfig: this.baseAppConfig,
            appBloc: bloc,
            loginResponse: state.loginResponse);

        return VwHomePage(key: key, appInstanceParam: appInstanceParam);
      }

      if (state is ViewArticleState) {
        return MediaViewerPage(
            autoplay: state.autoplay,
            mediaPointer: state.mediaPointer,
            backPageFunction: this.viewArticleBackFunction,
            mediaLinkNode: VwLinkNode(
                nodeId: state.articleId, nodeType: VwNode.ntnRowData),
            appInstanceParam: VwAppInstanceParam(
              baseAppConfig: this.baseAppConfig,
                appBloc: bloc,
                loginResponse: state.loginResponse));
      }

      if (state is InitsplashscreenPagecoordinatorState) {
        return MainSplash1(
          backgroundColor: baseAppConfig.baseThemeConfig.primaryColor,
          titleColor: Colors.white,
          showLogo: this.baseAppConfig.baseThemeConfig.showAppLogoOnInitSplashScreen,
          showTitle: this.baseAppConfig.baseThemeConfig.showAppTitleOnInitSplashScreen,
          logoAssetPath: this.baseAppConfig.generalConfig.mainLogoPath,
          title: this.baseAppConfig.generalConfig.appTitle,
          initsplashscreenParam: VwRowData(
              timestamp: VwDateUtil.nowTimestamp(), recordId: Uuid().v4()),
        );
      }

      if (state is RegInfoPagePagecoordinatorState) {
        return RegInfoPage(baseAppConfig: this.baseAppConfig, state: state);
      } else if (state is PublicLandingPagePagecoordinatorState) {
        if (true) {
          return VwPublicLandingPage(
              appInstanceParam: VwAppInstanceParam(
                baseAppConfig: this.baseAppConfig,
                  appBloc: bloc,
                  loginResponse: state.loginResponse),
              rootFolderNodeId: APIVirtualNode.exploreNodeFeed);
        }
      }

      if (state is LoginPagecoordinatorState) {
        return LoginPage(
          baseUrl: this.baseUrl,
          key: UniqueKey(),
          appInstanceParam: VwAppInstanceParam(
            baseAppConfig: this.baseAppConfig,
            appBloc: bloc,
          ),
          paramLoginPage: state.loginParam,
        );
      }

      if (state is BootupPagecoordinatorState) {
        return MainSplash1(
          logoAssetPath: this.baseAppConfig.generalConfig.mainLogoPath,
          title: "Memuat Aplikasi...",
          initsplashscreenParam: VwRowData(
              timestamp: VwDateUtil.nowTimestamp(), recordId: Uuid().v4()),
        );
      }
      if (state is NewFormRecordState) {
        if (state.loginResponse.userInfo != null) {
          state.loginResponse.userInfo!.user.mainRoleUserGroupId =
              this.baseAppConfig.generalConfig.specifiedFormSubmit;

          return VwHomePage(
              key: key,
              containerFolderNode: state.containerFolderNode,
              formResponse: state.formResponse,
              formDefinition: state.formDefinition,
              appInstanceParam: VwAppInstanceParam(
                baseAppConfig: this.baseAppConfig,
                loginResponse: state.loginResponse,
                appBloc: bloc,
              ));
        } else {
          return Text("Error: User is not logged in.");
        }
      }

      return MainSplash1(
        logoAssetPath: this.baseAppConfig.generalConfig.mainLogoPath,
        title: "Memuat Aplikasi...",
        initsplashscreenParam: VwRowData(
            timestamp: VwDateUtil.nowTimestamp(), recordId: Uuid().v4()),
      );
    });
  }
}
