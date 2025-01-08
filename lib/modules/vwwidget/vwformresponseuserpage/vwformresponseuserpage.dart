import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';

import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwdefaultrowviewer/vwdefaultrowviewer.dart';
import 'package:vwform/modules/vwwidget/vwformsubmitpage/vwformsubmitpage.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/vwnodesubmitpage.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:vwutil/modules/util/vwrowdatautil.dart';

class VwFormResponseUserPage extends StatefulWidget {
  VwFormResponseUserPage(
      {super.key,
      required this.appInstanceParam,
      this.folderNodeId = AppConfig.rootFolderNodeId,
      this.isRootFolder = true,
      this.currentNode,
      this.enableCreateRecord = true,
      this.showReloadButton = true,
      this.topRowWidget,
      this.bottomRowWidget,
      this.mainHeaderBackgroundColor = const Color.fromARGB(255, 200, 200, 200),
      this.mainHeaderTitleTextColor = Colors.black,
      this.footer,
      this.boxTopRowWidgetMode = NodeListView.btrDisabled,
      this.enableAppBar = true,
      this.enableScaffold = true,
      this.extendedApiCallParam,
      this.zeroDataCaption = "(No record)",
      this.showBackArrow = false,
      this.showUserInfoIcon = true,
      this.showLoginButton = true,
      this.mainLogoMode = NodeListView.mlmText,
      this.mainLogoImageAsset = AppConfig.textLogoPath,
      this.mainLogoTextCaption = AppConfig.appTitle,
      this.showSearchIcon = true,
      this.toolbarHeight = 64,
      this.toolbarPadding = 10,
      this.appBarMenu,
      this.scrollDirection = Axis.vertical,
      this.rowViewerBoxContraints,
      this.rowUpperPadding = 66,
      this.hintSearchBox = "Search...",
      this.bottomSideMode = NodeListView.bsmDisabled,
      this.parentArticleNode,
      this.commandToParentFunction,
      this.mainLogoAlignment = NodeListView.mlaLeft,
      this.formResponseIdList
      });

  final VwAppInstanceParam appInstanceParam;
  final bool isRootFolder;
  final List<String>? formResponseIdList;
  final String folderNodeId;
  final VwNode? currentNode;
  final bool? enableCreateRecord;
  final bool showReloadButton;
  final Widget? topRowWidget;
  final Widget? bottomRowWidget;
  final Color mainHeaderBackgroundColor;
  final Color mainHeaderTitleTextColor;
  final PluginWidgetFunction? footer;


  final bool enableAppBar;
  final bool enableScaffold;
  final VwRowData? extendedApiCallParam;
  final String zeroDataCaption;

  final bool showBackArrow;
  final bool showUserInfoIcon;
  final bool showLoginButton;
  final String mainLogoMode;
  final String? mainLogoTextCaption;
  final String mainLogoImageAsset;
  final bool showSearchIcon;
  final double toolbarHeight;
  final double toolbarPadding;
  final Widget? appBarMenu;
  final Axis scrollDirection;
  final BoxConstraints? rowViewerBoxContraints;
  final double rowUpperPadding;
  final String boxTopRowWidgetMode;
  final String hintSearchBox;
  final String bottomSideMode;
  final VwNode? parentArticleNode;
  final CommandToParentFunction? commandToParentFunction;
  final String mainLogoAlignment;

  _VwFormResponseUserPage createState() => _VwFormResponseUserPage();
}

class _VwFormResponseUserPage extends State<VwFormResponseUserPage>
    with SingleTickerProviderStateMixin {
  late Key _key;

  late SidebarXController sidebarXController;
  @override
  void initState() {
    this._key=Key(Uuid().v4());
    sidebarXController = SidebarXController(selectedIndex: 0, extended: true);
    this.stateKey =
        widget.key == null ? Key(Uuid().v4().toString()) : widget.key!;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  late Animation<double> _animation;
  late AnimationController _animationController;
  late Key stateKey;

  RefreshDataOnParentFunction? localRefreshDataOnParentFunction;

  void implementCommandToParentFunction(VwRowData callParameter) {
    try {
      if (this.widget.commandToParentFunction != null) {
        this.widget.commandToParentFunction!(callParameter);
      }
    } catch (error) {}
  }

  void implementRefreshDataOnParentFunction() {
    print("refresh data from isi form");


    setState(() {
      this.stateKey = Key(Uuid().v4());
    });
  }

  Widget nodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
    this.localRefreshDataOnParentFunction = refreshDataOnParentFunction;

    if (renderedNode.nodeType == VwNode.ntnTopNodeInsert) {
      if (topRowWidget != null) {
        return topRowWidget;
      } else {
        return Container();
      }
    }

    return VwDefaultRowViewer(
      key: Key(renderedNode.recordId),
      rowNode: renderedNode,
      appInstanceParam: this.widget.appInstanceParam,
      rowViewerBoxContraints: this.widget.rowViewerBoxContraints,
      highlightedText: highlightedText,
      refreshDataOnParentFunction: this.implementRefreshDataOnParentFunction,
      commandToParentFunction: this.widget.commandToParentFunction != null
          ? implementCommandToParentFunction
          : null,
    );
  }

  void modifyParamFunction(VwRowData apiCallParam) {}

  Widget _getCreateRecordFloatingActionButton(
      {required BuildContext context,
      required VwAppInstanceParam appInstanceParam,
      SyncNodeToParentFunction? syncNodeToParentFunction,
      RefreshDataOnParentFunction? refreshDataOnParentFunction}) {
    const widgetKey = "123456789";

    Widget buttonSubmitFormResponse= FloatingActionButton.small(
      heroTag: {"name":1},
        backgroundColor: Color.fromARGB(160, 10, 139, 245),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {

                  if(widget.currentNode!=null) {
                    return VwNodeSubmitPage(
                        parentNodeId: widget.currentNode!.recordId,
                        appInstanceParam: appInstanceParam,
                        refreshDataOnParentFunction: this
                            .implementRefreshDataOnParentFunction);
                  }
                  else{
                    //do nothing
                    print("error: node parent doesn't exist");
                  }
                  return VwFormSubmitPage(
                  parentNode: this.widget.currentNode,
                      key: Key(widgetKey),
                      defaultFormDefinitionIdList: this.widget.currentNode !=
                                  null &&
                              this
                                      .widget
                                      .currentNode!
                                      .defaultFormDefinitionIdList !=
                                  null
                          ? this.widget.currentNode!.defaultFormDefinitionIdList
                          : widget.formResponseIdList,
                      appInstanceParam: widget.appInstanceParam,
                      refreshDataOnParentFunction:
                          this.implementRefreshDataOnParentFunction,
                    );

                }),
          );

        });

    Widget buttonSubmitNode= FloatingActionButton.small(
        heroTag: {"name":2},
        backgroundColor: Color.fromARGB(160, 10, 139, 245),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VwNodeSubmitPage(
                  parentNodeId: this.widget.folderNodeId,
                  key: Key(widgetKey),
                  formDefinitionIdList: this.widget.currentNode !=
                      null &&
                      this
                          .widget
                          .currentNode!
                          .defaultFormDefinitionIdList !=
                          null
                      ? this.widget.currentNode!.defaultFormDefinitionIdList
                      : widget.formResponseIdList,
                  appInstanceParam: widget.appInstanceParam,
                  refreshDataOnParentFunction:
                  this.implementRefreshDataOnParentFunction,
                )),
          );

        });

    return buttonSubmitNode;
    return Column(

      children: [
      //buttonSubmitFormResponse,
      //SizedBox(height: 5,),
      buttonSubmitNode
    ],);

  }

  VwRowData apiCallParam() {
    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId", valueString: this.widget.folderNodeId),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          /*VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: { "nodeType": VwNode.ntnFolder }),*/
          VwFieldValue(
              fieldName: "sortObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {"displayName": 1}),
          VwFieldValue(
              fieldName: "disableUserGroupPOV",
              valueTypeId: VwFieldValue.vatBoolean,
              valueBoolean: true),
        ]);

    if (this.widget.extendedApiCallParam != null) {
      VwRowDataUtil.updateFields(
          current: returnValue, candidate: this.widget.extendedApiCallParam!);
    }

    return returnValue;
  }

  Widget customDrawer(GlobalKey<ScaffoldState> key, BuildContext context) {
    return SidebarX(
      controller: SidebarXController(selectedIndex: 0, extended: true),
      items: const [
        SidebarXItem(icon: Icons.home, label: 'Home'),
        SidebarXItem(icon: Icons.search, label: 'Search'),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget body = NodeListView(

      key: this.stateKey,
      drawer: this.customDrawer,
      showMessenger: true,
      mainLogoAlignment: this.widget.mainLogoAlignment,
      parentArticleNode: widget.parentArticleNode,
      hintSearchBox: this.widget.hintSearchBox,
      rowUpperPadding: this.widget.rowUpperPadding,
      scrollDirection: this.widget.scrollDirection,
      bottomRowWidget: this.widget.bottomRowWidget,
      appBarMenu: widget.appBarMenu,
      toolbarHeight: widget.toolbarHeight,
      toolbarPadding: widget.toolbarPadding,
      bottomSideMode: this.widget.bottomSideMode,
      enableScaffold: this.widget.enableScaffold,
      enableAppBar: this.widget.enableAppBar,
      boxTopRowWidgetMode: this.widget.boxTopRowWidgetMode,
      footer: widget.footer,
      mainHeaderBackgroundColor: widget.mainHeaderBackgroundColor,
      mainHeaderTitleTextColor: widget.mainHeaderTitleTextColor,
      mainLogoMode: widget.mainLogoMode,
      mainLogoTextCaption: widget.mainLogoTextCaption,
      mainLogoImageAsset: widget.mainLogoImageAsset,
      appInstanceParam: this.widget.appInstanceParam,
      topRowWidget: this.widget.topRowWidget,
      //key: this.stateKey,
      apiCallId: "getNodes",
      zeroDataCaption: this.widget.zeroDataCaption,
      showUserInfoIcon: this.widget.appInstanceParam.loginResponse != null &&
              this.widget.appInstanceParam.loginResponse!.userInfo != null &&
              widget.isRootFolder == true &&
              this.widget.showUserInfoIcon == true
          ? true
          : false,
      nodeRowViewerFunction: nodeRowViewer,
      apiCallParam: this.apiCallParam(),
      showLoginButton: this.widget.showLoginButton,
      showSearchIcon: widget.showSearchIcon,
      getFloatingActionButton: widget.enableCreateRecord == true
          ? this._getCreateRecordFloatingActionButton
          : null,
      showBackArrow: this.widget.isRootFolder == false ||
          this.widget.showBackArrow == true,
      showReloadButton: this.widget.showReloadButton,
    );
    return body;
  }
}
