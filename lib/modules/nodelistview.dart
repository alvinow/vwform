import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/formdefinitionlib/formdefinitionlib.dart';
import 'package:vwform/modules/listviewtitlecolumn/listviewtitlecolumn.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwform/modules/vwmessenger/vwheadmessagemessenger.dart';
import 'package:vwform/modules/vwusernotificationpage/vwusernotificationpage.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:vwform/modules/vwwidget/userinfopage/tabuserinfopage.dart';
import 'package:vwform/modules/vwwidget/userinfopagepublic/userinfopagepublic.dart';
import 'package:vwform/modules/vwwidget/vwmobilescanner/vwmobilescanner.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/vwnodesubmitpage.dart';
import 'package:vwform/modules/waitdialogpage/waitdialogwidget.dart';
import 'package:vwform/modules/youtubeappdemo/youtubeappdemo.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/profilepictureutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'nodelistviewlib.dart';
import 'dart:convert';

typedef GetFloatingActionButtonFunction = Widget Function(
    {required BuildContext context,
    required VwAppInstanceParam appInstanceParam,
    SyncNodeToParentFunction? syncNodeToParentFunction,
    RefreshDataOnParentFunction? refreshDataOnParentFunction});





typedef ModifyParamFunction = void Function(VwRowData apiCallParam);





typedef PluginWidgetFunction = Widget Function(
    {required VwRowData? parameter,
    RefreshDataOnParentFunction? refreshDataOnParentFunction,
    CommandToParentFunction? commandToParentFunction});



typedef NodeListViewBuildFunction = Widget Function(
    Key, BuildContext, PagingController<int, VwNode>, VwNodeRequestResponse);

typedef BuildPreferredSizeWithContextFunction = PreferredSize Function(
    Key, BuildContext);



typedef SetStateFunction = void Function(BuildContext);

typedef BuildAppBarWithSearchFieldFunction = PreferredSize Function(
    GlobalKey<ScaffoldState>,
    BuildContext,
    PagingController,
    TextEditingController,
    FocusNode,
    SetStateFunction,
    VwRowData);

class NodeListView extends StatefulWidget {
  NodeListView(
      {super.key,
      this.isScrollable = true,
      required this.appInstanceParam,
      required this.apiCallParam,
      this.drawer,
      required this.nodeRowViewerFunction,
      this.apiCallId = "getNodes",
      this.showUserInfoIcon = false,
      this.showNotificationIcon = false,
      this.getFloatingActionButton,
      this.pageMode = NodeListView.pmFeed,
      this.autoFetch = true,
      this.showBackArrow = false,
      this.showSearchIcon = false,
      this.zeroDataCaption = "(No record)",
      this.searchCaption = "Search...",
      this.nodeFetchMode = NodeListView.nfmServer,
      this.syncLinkNodeListToParentFunction,
      this.fieldValue,
      this.topRowWidget,
      this.bottomRowWidget,
      this.excludedNodeFetch,
      this.showReloadButton = true,
      this.titleColumns,
      this.showLoginButton = true,
      this.showQrScannerWidgetOnSearchTextField = false,
      this.mainHeaderBackgroundColor = Colors.white,
      this.mainHeaderTitleTextColor = Colors.black,
      this.footer,
      this.enableScaffold = true,
      this.enableAppBar = true,
      this.mainLogoMode = NodeListView.mlmDisabled,
      this.mainLogoImageAsset = AppConfig.textLogoPath,
      this.mainLogoTextCaption = AppConfig.appTitle,
      this.showRootLogoPath = false,
      this.mainLogoAlignment = NodeListView.mlaLeft,
      this.toolbarHeight = 64,
      this.toolbarPadding = 10,
      this.appBarMenu,
      this.scrollDirection = Axis.vertical,
      this.rowUpperPadding = 66,
      this.boxTopRowWidgetMode = NodeListView.btrDisabled,
      this.hintSearchBox = "Cari...",
      this.bottomSideMode = NodeListView.bsmDisabled,
      this.parentArticleNode,
      this.reloadButtonSize = 25,
      this.footerWidgetParameter,
      this.showMessenger = false,
      this.isListReverse = false,
      this.margin = const EdgeInsets.fromLTRB(10, 65, 0, 5),
      this.backgroundColor = Colors.transparent,
      this.excludedRow = const []});

  static const String mlaLeft = "mlaLeft";
  static const String mlaCenter = "mlaCenter";
  static const String mlmDisabled = "mlmDisabled";
  static const String mlmText = "mlmText";
  static const String mlmLogo = "mlmLogo";

  static const String pmFeed = "pmFeed";
  static const String pmSearch = "pmSearch";

  static const String nfmServer = "nfmServer";
  static const String nfmParent = "nfmParent";

  static const String btrDisabled = "btrDisabled";
  static const String btrQuestionBox = "btrQuestionBox";
  static const String btrSearchNodeComment = "btrSearchNodeComment";
  static const String btrMediaViewer = "btrMediaViewer";

  static const String bsmDisabled = "bsmDisabled";
  static const String bsmCommentBox = "bsmCommentBox";
  static const String bsmVideoPointerBox = "bsmVideoPointer";

  final VwRowData? footerWidgetParameter;
  final bool isScrollable;
  final VwAppInstanceParam appInstanceParam;
  final bool showSearchIcon;
  final bool showBackArrow;
  final bool showNotificationIcon;
  final bool showUserInfoIcon;
  final String zeroDataCaption;
  final GetFloatingActionButtonFunction? getFloatingActionButton;
  final String apiCallId;
  final VwRowData apiCallParam;
  final BuildWidgetWithContextFunction? drawer;
  final NodeRowViewerFunction nodeRowViewerFunction;
  final String pageMode;
  final bool autoFetch;
  final String searchCaption;
  final String nodeFetchMode;
  final SyncLinkNodeListToParentFunction? syncLinkNodeListToParentFunction;
  final VwFieldValue? fieldValue;
  final Widget? topRowWidget;
  final Widget? bottomRowWidget;
  final List<VwLinkNode>? excludedNodeFetch;
  bool showReloadButton;
  final List<ListViewTitleColumn>? titleColumns;
  final bool showLoginButton;
  bool showQrScannerWidgetOnSearchTextField;
  final Color mainHeaderBackgroundColor;
  final Color mainHeaderTitleTextColor;
  final PluginWidgetFunction? footer;
  final bool enableScaffold;
  final String boxTopRowWidgetMode;
  final bool enableAppBar;
  final String mainLogoMode;
  final String? mainLogoTextCaption;
  final String mainLogoImageAsset;
  final bool showRootLogoPath;
  final String mainLogoAlignment;
  final double toolbarHeight;
  final double toolbarPadding;
  final Widget? appBarMenu;
  final Axis scrollDirection;
  final double rowUpperPadding;
  final String hintSearchBox;
  final String bottomSideMode;
  final VwNode? parentArticleNode;
  final List<String> excludedRow;
  final double reloadButtonSize;
  final bool showMessenger;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final bool isListReverse;

  _NodeListViewState createState() => _NodeListViewState();
}

class _NodeListViewState extends State<NodeListView>
    with SingleTickerProviderStateMixin {
  late Key questiontBoxKey;
  late Key commentBoxKey;
  late Key listKey;
  int? lastRowIndex;

  late TextEditingController searchBoxtextEditingController;
  late FocusNode myFocusNode;
  late int _pageSize;
  late final PagingController<int, VwNode> _pagingController;
  late VwNodeRequestResponse currentNodeRequestResponse;
  late VwRowData currentApiCallParam;
  late bool enableFetch;

  late bool doRefresh;

  String? searchKeyword;

  late Key currentKey;
  late Key scannerKey;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late bool requestDownloadTicketShowEvent;
  late int displayedRecordCount;
  late ScrollController _scrollViewController;

  Widget getLoginButton() {
    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: () {
          this
              .widget
              .appInstanceParam
              .appBloc
              .add(LoginPagecoordinatorEvent(timestamp: DateTime.now()));
        },
        icon: Icon(
          Icons.person,
          size: this.widget.toolbarHeight - (2 * this.widget.toolbarPadding),
          color: widget.mainHeaderTitleTextColor,
        ));
  }

  @override
  void initState() {
    this.questiontBoxKey = UniqueKey();
    this.commentBoxKey = UniqueKey();
    this.listKey = UniqueKey();
    this._scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {}

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {}
    });

    this.displayedRecordCount = 0;
    this._pageSize = 20;
    try {
      if (this.widget.apiCallParam.getFieldByName("nodeId") != null &&
          this
                  .widget
                  .apiCallParam
                  .getFieldByName("nodeId")!
                  .valueString
                  .toString() ==
              "response_ticketshoweventformdefinition") {
        if (this.widget.appInstanceParam.loginResponse != null &&
            this.widget.appInstanceParam.loginResponse!.userInfo != null &&
            this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .userInfo!
                    .user
                    .mainRoleUserGroupId ==
                "adminticket") {
          this._pageSize = 2000;
        }

        this.widget.showQrScannerWidgetOnSearchTextField = true;
      }
    } catch (error) {}

    this.requestDownloadTicketShowEvent = false;
    doRefresh = false;
    currentKey = UniqueKey();
    scannerKey = UniqueKey();
    super.initState();
    enableFetch = widget.autoFetch;
    searchBoxtextEditingController = TextEditingController();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    currentApiCallParam = VwRowData.fromJson(
        json.decode(json.encode(widget.apiCallParam.toJson())));
    currentNodeRequestResponse = VwNodeRequestResponse();
    _pagingController = PagingController(firstPageKey: 0);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPageToServerWithControl(pageKey);
    });
  }

  void reloadData() {
    _pagingController.refresh();
  }

  Widget? getTopRowWidget() {
    Widget? returnValue = null;
    try {
      if (this.widget.topRowWidget != null) {
        returnValue = this.widget.topRowWidget;
      }

      if (this.widget.boxTopRowWidgetMode == NodeListView.btrMediaViewer) {
        try {
          if (widget.parentArticleNode != null) {
            if ((widget.parentArticleNode!.content.rowData!.collectionName ==
                        "standardarticleformdefinition" ||
                    widget.parentArticleNode!.content.rowData!.collectionName ==
                        "questionarticleformdefinition") &&
                widget.parentArticleNode!.content.rowData!
                        .getFieldByName("articletype")!
                        .valueString ==
                    "youtube") {
              String videoId = widget.parentArticleNode!.content.rowData!
                  .getFieldByName("medialinktitle")!
                  .valueString!;

              returnValue = Container(
                  height: 300,
                  width: 300,
                  child: YoutubeAppDemo(videoIds: [videoId]));
            }
          }
        } catch (error) {}
      }
    } catch (error) {}
    return returnValue;
  }

  void implementRefreshDataOnParentFunction(VwNode syncNode) {
    if (this.widget.fieldValue != null) {
      if (this.widget.fieldValue!.valueLinkNodeList == null) {
        this.widget.fieldValue!.valueLinkNodeList = [];
      }
      NodeUtil.injectNodeToLinkNodeList(
          syncNode, this.widget.fieldValue!.valueLinkNodeList!);
      _pagingController.refresh();
      if (this.widget.syncLinkNodeListToParentFunction != null) {
        this.widget.syncLinkNodeListToParentFunction!(
            this.widget.fieldValue!.valueLinkNodeList!);
      }
    }
  }

  void setStateOnParent(BuildContext context) {
    setState(() {});
  }

  Widget createTitleColumn({required List<ListViewTitleColumn> titleColumns}) {
    Widget returnValue = Container();

    try {
      List<Widget> columns = [];

      for (int la = 0; la < titleColumns.length; la++) {
        ListViewTitleColumn currentListViewTitleColumn =
            titleColumns.elementAt(la);

        Widget currentColumnWidget = Text(
          currentListViewTitleColumn.caption,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        );

        if (la == 0) {
          columns.add(Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  color: Colors.grey.shade200,
                  child: currentColumnWidget)));
        } else {
          columns.add(Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                  color: Colors.grey.shade200, child: currentColumnWidget)));
        }

        //columns.add(currentColumnWidget);
      }

      returnValue = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: columns,
      );
    } catch (error) {}
    return returnValue;
  }

  Widget reloadButton() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.refresh,
            size: this.widget.reloadButtonSize,
          ),
          onPressed: () {
            _pagingController.refresh();
          },
        ));
  }

  void _applyDoRefresh() {
    if (doRefresh == true || (currentKey == null)) {
      setState(() {
        doRefresh = false;
        currentKey = UniqueKey();
      });
    }
  }

  void _refreshData() {
    _pagingController.refresh();
  }

  Future<void> _fetchPageToServerWithControl(int pageKey) async {
    if (this.widget.nodeFetchMode == NodeListView.nfmServer) {
      if (enableFetch) {
        this._fetchPageToServer(pageKey);
      } else {
        _pagingController.appendLastPage(<VwNode>[]);
      }
    } else if (this.widget.nodeFetchMode == NodeListView.nfmParent) {
      if (this.widget.fieldValue != null &&
          this.widget.fieldValue!.valueLinkNodeList != null) {
        List<VwNode> currentNodeList = [];

        List<VwNode> parentLinkNodeList =
            NodeUtil.extractNodeListFromLinkNodeList(
                this.widget.fieldValue!.valueLinkNodeList);

        currentNodeList.addAll(parentLinkNodeList);
        _pagingController.appendLastPage(currentNodeList);
      } else {
        _pagingController.appendLastPage(<VwNode>[]);
      }
    }
  }

  VwNode getTopRowPaddingNode() {
    return VwNode(
        content: VwNodeContent(),
        displayName: "<invalid_display_name>",
        ownerUserId: "<invalid_user_id>",
        recordId: "<invalid_record_id>",
        nodeStatusId: VwNode.nsActive,
        nodeType: VwNode.ntnTopNodeInsert);
  }

  Future<void> _fetchPageToServer(int pageKey) async {
    this.displayedRecordCount = 0;
    VwNode? topRowPaddingNode;

    if (pageKey == 0 &&
        this.getTopRowWidget() != null &&
        this.widget.enableAppBar == true) {
      topRowPaddingNode = this.getTopRowPaddingNode();
    }

    VwFieldValue? searchKeywordFieldValue =
        currentApiCallParam.getFieldByName("searchKeyword");
    if (searchKeywordFieldValue == null) {
      searchKeywordFieldValue = VwFieldValue(
          fieldName: "searchKeyword",
          valueString: searchKeyword,
          valueTypeId: VwFieldValue.vatString);
      currentApiCallParam.fields!.add(searchKeywordFieldValue!);
    } else {
      searchKeywordFieldValue.valueString = searchKeyword;
    }

    VwNodeRequestResponse nodeRequestResponse =
        await NodeListViewLib.fetchRenderedNode(
            topRowNode: topRowPaddingNode,
            selectedLinkNode: this.widget.excludedNodeFetch != null
                ? this.widget.excludedNodeFetch
                : null,
            apiCallId: this.widget.apiCallId,
            apiCallParam: currentApiCallParam,
            pagingController: _pagingController,
            pageKey: pageKey,
            pageSize: _pageSize,
            loginSessionId: widget.appInstanceParam.loginResponse != null
                ? widget.appInstanceParam.loginResponse!.loginSessionId!
                : "<invalid_loginSessionId>");

    if (nodeRequestResponse.apiCallResponse != null &&
        nodeRequestResponse.apiCallResponse!.responseStatusCode == 401) {
      this
          .widget
          .appInstanceParam
          .appBloc
          .add(LogoutPagecoordinatorEvent(timestamp: DateTime.now()));
    }

    try {
      this.displayedRecordCount =
          nodeRequestResponse.renderedNodePackage!.renderedNodeList!.length;

      if (this.widget.apiCallParam.getFieldByName("nodeId") != null &&
          this.widget.apiCallParam.getFieldByName("nodeId")!.valueString ==
              "response_ticketshoweventformdefinition") {
        Fluttertoast.showToast(
            msg: this.displayedRecordCount.toString() + " record ditampilkan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
            webPosition: "center",
            fontSize: 16.0);
      }
    } catch (error) {}

    if (kIsWeb == true &&
        this.requestDownloadTicketShowEvent == true &&
        nodeRequestResponse.renderedNodePackage != null &&
        nodeRequestResponse.renderedNodePackage!.renderedNodeList != null) {
      this.requestDownloadTicketShowEvent = false;

      String returnedResponse = "";

      String returnedCSVResponse = "";

      for (int la = 0;
          la <
              nodeRequestResponse.renderedNodePackage!.renderedNodeList!.length;
          la++) {
        VwRowData ticketshowevent = nodeRequestResponse
            .renderedNodePackage!.renderedNodeList!
            .elementAt(la)
            .content!
            .rowData!;

        VwFieldValue? contactticketFieldValue =
            ticketshowevent.getFieldByName("contactticket");

        VwFieldValue? ticketcodeFieldValue =
            ticketshowevent.getFieldByName("ticketCode");

        VwFieldValue? gateEntryFieldValue =
            ticketshowevent.getFieldByName("gateEntry");

        String? nameContacticket = NodeUtil.getFieldValueFromLinkNodeRowData(
                fieldName: "name",
                linkNode: contactticketFieldValue!.valueLinkNode!)!
            .valueString;
        String? mobilephoneContacticket =
            NodeUtil.getFieldValueFromLinkNodeRowData(
                    fieldName: "mobilephone",
                    linkNode: contactticketFieldValue!.valueLinkNode!)!
                .valueString;

        String? circleContacticket;

        try {
          circleContacticket = NodeUtil.getFieldValueFromLinkNodeRowData(
                  fieldName: "circle",
                  linkNode: contactticketFieldValue!.valueLinkNode!)!
              .valueString;
        } catch (error) {}

        String urlTiket = Uri.encodeFull(AppConfig.baseUrl +
            "/?ticketCode=" +
            ticketcodeFieldValue!.valueString!);

        //String currentLink="Yth. \n"+nameContacticket!+"\n\n"+introText+" \n\n"+urlTiket;

        //returnedResponse=returnedResponse+"\n\n\n\n\n\n"+currentLink;

        String? gateEntry = gateEntryFieldValue == null
            ? "null"
            : gateEntryFieldValue!.valueString.toString();

        String currentCSVResponse = '"' +
            nameContacticket! +
            '","' +
            circleContacticket.toString() +
            '","' +
            mobilephoneContacticket! +
            '","' +
            urlTiket +
            '","' +
            gateEntry +
            '"\n';

        returnedCSVResponse = returnedCSVResponse + currentCSVResponse;
      }

      //returnedResponse=returnedResponse+"\n\n\n\n"+returnedCSVResponse;

      returnedResponse = returnedCSVResponse;

      String? filenameSearchKeyword = this.searchKeyword;

      if (filenameSearchKeyword == null) {
        filenameSearchKeyword = "";
      }

      await FileSaver.instance.saveFile(
          name: "ticket_" +
              filenameSearchKeyword! +
              "_" +
              DateTime.now().toIso8601String(),
          bytes: Uint8List.fromList(utf8.encode(returnedResponse)),
          ext: "csv",
          mimeType: MimeType.text);
    }

    currentNodeRequestResponse = nodeRequestResponse;
  }

  Widget _noItemsFound(BuildContext context) {
    Widget returnValue = Container();
    try {
      if (this.currentNodeRequestResponse.apiCallResponse != null) {
        returnValue = InkWell(
          onTap: () {
            _pagingController.refresh();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                this.widget.zeroDataCaption,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: widget.reloadButtonSize / 2),
              )),
              Icon(
                Icons.refresh,
                size: this.widget.reloadButtonSize,
              ),
            ],
          ),
        );
      } else if (enableFetch &&
          widget.nodeFetchMode == NodeListView.nfmServer) {
        returnValue = InkWell(
          onTap: () {
            _pagingController.refresh();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                "Error: Tidak Terhubung Dengan Server, \n (Klik untuk reload)",
                textAlign: TextAlign.center,
              )),
              Icon(
                Icons.refresh,
                size: widget.reloadButtonSize,
              ),
            ],
          ),
        );
      }
      else{
        return Center(
            child: Text(
              this.widget.zeroDataCaption,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: widget.reloadButtonSize / 2),
            ));
      }
    } catch (error) {}

    return returnValue;
  }

  List<Widget> createItemList() {
    List<Widget> returnValue = [];

    List<VwNode> parentNodeList = [];
    try {
      if (widget.nodeFetchMode == NodeListView.nfmParent) {
        if (widget.fieldValue != null) {
          parentNodeList =
              NodeUtil.getNodeListFromFieldValue(widget.fieldValue!);
        }
      } else {}

      for (int index = 0; index < parentNodeList.length; index++) {
        Widget returnRow = Container();

        Widget currentRowWidget = this.widget.nodeRowViewerFunction(
            topRowWidget: this.getTopRowWidget(),
            context: context,
            index: index,
            renderedNode: parentNodeList.elementAt(index),
            refreshDataOnParentFunction: _refreshData);

        if (index == parentNodeList.length - 1) {
          currentRowWidget = Column(
            children: [currentRowWidget, SizedBox(height: 60)],
          );
        }

        if (index == 0 && this.widget.titleColumns != null) {
          Widget titleColumnWidget =
          createTitleColumn(titleColumns: widget.titleColumns!);

          returnRow = Column(
            children: [
              titleColumnWidget,
              currentRowWidget,
            ],
          );
        } else {
          if (index == 0) {
            returnRow = Container(
                margin: EdgeInsets.fromLTRB(
                    0, this.widget.rowUpperPadding, 0, 0),
                child: currentRowWidget);
          } else {
            returnRow = currentRowWidget;
          }
        }
        returnValue.add(returnRow);
      }
    }
    catch(error)
    {

    }

    return returnValue;
  }

  Widget buildBodyLocalData(
      {required Key key,
      required BuildContext context,
      required PagingController<int, VwNode> pagingController,
      Widget? bottomRow}) {
    Widget returnValue=Container();
    try {

      List<Widget >listWidget= createItemList();

      if(listWidget.length>0)
        {
          Widget body= Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: listWidget ));
          returnValue=SingleChildScrollView(child: body);
        }
      else
        {
          returnValue=this._noItemsFound(context);
        }




    }
    catch(error)
    {

    }

    return returnValue;
  }

  Widget buildBody(
      {required Key key,
      required BuildContext context,
      required PagingController<int, VwNode> pagingController,
      Widget? bottomRow}) {
    Widget returnValue = Container();

    try {
      if (this.widget.nodeFetchMode == NodeListView.nfmServer) {
        returnValue = this.buildBodyRemoteData(
            key: key,
            context: context,
            pagingController: pagingController,
            bottomRow: bottomRow);
      } else {
        returnValue = this.buildBodyLocalData(
            key: key,
            context: context,
            pagingController: pagingController,
            bottomRow: bottomRow);
      }
    } catch (error) {}
    return returnValue;
  }

  bool isExcludedRow({required String nodeId}) {
    bool returnValue = false;
    try {
      for (int la = 0; la < widget.excludedRow.length; la++) {
        final String currentNodeId = widget.excludedRow.elementAt(la);
        if (currentNodeId == nodeId) {
          returnValue = true;
          break;
        }
      }
    } catch (error) {}

    return returnValue;
  }

  Widget buildBodyRemoteData(
      {required Key key,
      required BuildContext context,
      required PagingController<int, VwNode> pagingController,
      Widget? bottomRow}) {
    VwFieldValue? filterByUntuk =
        this.currentApiCallParam.getFieldByName("filterByUntuk");

    String? untukHighlightedText;
    if (this.widget.pageMode == NodeListView.pmSearch &&
        filterByUntuk != null &&
        filterByUntuk.valueString != null &&
        filterByUntuk.valueString != "") {
      untukHighlightedText = filterByUntuk.valueString!;
    }

    Widget pagedListView = PagedListView<int, VwNode>.separated(
      reverse: widget.isListReverse,
      shrinkWrap: widget.isScrollable != true,
      pagingController: _pagingController,
      scrollDirection: widget.scrollDirection,
      scrollController: this._scrollViewController,
      builderDelegate: PagedChildBuilderDelegate<VwNode>(
          noItemsFoundIndicatorBuilder: _noItemsFound,
          animateTransitions: true,
          itemBuilder: (context, item, index) {
            Widget returnValue=Container();


            Widget currentRowWidget = this.widget.nodeRowViewerFunction(
                topRowWidget: this.getTopRowWidget(),
                context: context,
                index: index,
                renderedNode: item,
                highlightedText: untukHighlightedText,
                refreshDataOnParentFunction: _refreshData);

            if (this.isExcludedRow(nodeId: item.recordId) == true) {
              currentRowWidget = Container();
            }

            if (index == 0 && this.widget.titleColumns != null) {
              Widget titleColumnWidget =
                  createTitleColumn(titleColumns: widget.titleColumns!);

              returnValue= Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  titleColumnWidget,
                  currentRowWidget,
                ],
              );

              ;
            } else {
              if (index == 0) {
                if (this.getIsShowAppBar() == true) {
                  returnValue= Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: currentRowWidget);
                } else {
                  returnValue= Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: currentRowWidget);
                }
              } else {
                returnValue= currentRowWidget;
              }
            }
            return Container( key:Key(item.recordId), child:returnValue);
          }),
      separatorBuilder: (context, index) => Container(),
    );

    if (widget.isScrollable == true) {
      return RefreshIndicator(
        key: key,
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: Scrollbar(
            thumbVisibility: true,
            controller: this._scrollViewController,
            child: pagedListView),
      );
    } else {
      return pagedListView;
    }
  }

  Widget buildColumnBody(PagingController pagingController) {
    List<Widget> recordList = [];
    if (pagingController.itemList != null) {
      for (int la = 0; la < pagingController.itemList!.length; la++) {
        int index = la;
        VwNode item = pagingController.itemList!.elementAt(index);
        Widget currentRowWidget = this.widget.nodeRowViewerFunction(
            topRowWidget: this.getTopRowWidget(),
            context: context,
            index: index,
            renderedNode: item,
            //highlightedText: untukHighlightedText,
            refreshDataOnParentFunction: _refreshData);

        if (this.isExcludedRow(nodeId: item.recordId) == true) {
          currentRowWidget = Container();
        }

        if (index == 0 && this.widget.titleColumns != null) {
          Widget titleColumnWidget =
              createTitleColumn(titleColumns: widget.titleColumns!);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              titleColumnWidget,
              currentRowWidget,
            ],
          );

          ;
        } else {
          if (index == 0) {
            if (this.getIsShowAppBar() == true) {
              return Container(
                  margin:
                      EdgeInsets.fromLTRB(0, this.widget.rowUpperPadding, 0, 0),
                  child: currentRowWidget);
            } else {
              return Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: currentRowWidget);
            }
          } else {
            return currentRowWidget;
          }
        }
      }
    }

    return Column(
      children: recordList,
    );
  }

  AppBar buildAppBar(
      Key key,
      BuildContext context,
      PagingController pagingController,
      TextEditingController textEditingController,
      FocusNode myFocusNode,
      SetStateFunction setStateFunction,
      VwRowData currentApiCallParam) {
    if (widget.pageMode == NodeListView.pmSearch &&
        this.widget.nodeFetchMode == NodeListView.nfmServer) {
      return this.buildAppBarSearchPage(
          key,
          context,
          pagingController,
          textEditingController,
          myFocusNode,
          setStateFunction,
          currentApiCallParam);
    } else {
      return this.buildDefaultAppBar(
          key,
          context,
          pagingController,
          textEditingController,
          myFocusNode,
          setStateFunction,
          currentApiCallParam);
    }
  }

  AppBar buildAppBarSearchPage(
      Key key,
      BuildContext context,
      PagingController pagingController,
      TextEditingController textEditingController,
      FocusNode myFocusNode,
      SetStateFunction setStateFunction,
      VwRowData currentApiCallParam) {
    Widget downloadTicketShowEventData = Container();

    try {
      if (this.widget.apiCallParam.getFieldByName("nodeId") != null &&
          this.widget.apiCallParam.getFieldByName("nodeId")!.valueString ==
              "response_ticketshoweventformdefinition") {
        if (this.widget.appInstanceParam.loginResponse != null &&
            this.widget.appInstanceParam.loginResponse!.userInfo != null &&
            this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .userInfo!
                    .user
                    .mainRoleUserGroupId ==
                "adminticket") {
          downloadTicketShowEventData = IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                this.requestDownloadTicketShowEvent = true;
                this.enableFetch = true;
                pagingController.refresh();
                setStateFunction(context);
              },
              icon: Icon(Icons.download ));
        } else {
          this.widget.showReloadButton = false;
        }
      }
    } catch (error) {
      print("Error catched on buildAppBarSearchPage: " + error.toString());
    }

    return AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: widget.mainHeaderTitleTextColor,
            )),
        actions: [
          downloadTicketShowEventData,
          textEditingController.value.text.length > 0
              ? InkWell(
                  onTap: () {
                    this.enableFetch = false;
                    currentNodeRequestResponse.apiCallResponse = null;
                    textEditingController.clear();
                    pagingController.itemList = <VwNode>[];
                    setStateFunction(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: widget.mainHeaderTitleTextColor,
                  ))
              : Container(),
          SizedBox(
            width: 20,
          )
        ],
        title: buildAppBarSearchField(
            key,
            context,
            pagingController,
            textEditingController,
            myFocusNode,
            setStateFunction,
            currentApiCallParam));
  }

  Widget getMainLogo({TextStyle? textStyle}) {
    Widget returnValue = Container();
    try {
      if (this.widget.mainLogoMode == NodeListView.mlmLogo) {
        returnValue = Container(
            alignment: Alignment.topLeft,
            child: Image.asset(this.widget.mainLogoImageAsset));
      } else if (this.widget.mainLogoMode == NodeListView.mlmText &&
          this.widget.mainLogoTextCaption != null) {
        TextStyle? defaultTextStyle = TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: widget.mainHeaderTitleTextColor);

        if (textStyle != null) {
          defaultTextStyle = textStyle;
        }

        returnValue =
            Expanded(child:Text( this.widget.mainLogoTextCaption!, maxLines: 1, overflow: TextOverflow.ellipsis, style: defaultTextStyle));
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getPrintWidget()
  {
    return InkWell(child: Icon(Icons.print),onTap: () async{
      try {
        if (this.currentNodeRequestResponse.renderedNodePackage != null
            &&
            this.currentNodeRequestResponse.renderedNodePackage!.rootNode !=
                null

        &&
            this.widget.appInstanceParam.loginResponse!=null
        &&
            this.widget.appInstanceParam.loginResponse!.loginSessionId!=null
        ) {
          if (this.currentNodeRequestResponse.renderedNodePackage!.rootNode!
              .nodeType == VwNode.ntnFolder ) {
            String nodeId = this.currentNodeRequestResponse.renderedNodePackage!.rootNode!.recordId;
            print("Printing " + nodeId);


            VwRowData apiCallParam=VwRowData(recordId: Uuid().v4(),fields: [VwFieldValue(fieldName: "nodeId",valueString: nodeId)]);

            Navigator.push(
              context,
              MaterialTransparentRoute (
                  builder: (context) => WaitDialogWidget() ),
            );

            VwApiCallResponse? apiCallResponse =
                await RemoteApi.requestApiCall (
                apiCallId: "printReport",
                apiCallParam: apiCallParam,
                loginSessionId: this.widget.appInstanceParam.loginResponse!.loginSessionId!);

            Navigator.of(context).pop();

            if(apiCallResponse!=null && apiCallResponse!.responseStatusCode==200)
              {
                if(apiCallResponse!.valueResponseClassEncodedJson!=null)
                  {
                    RemoteApi.decompressClassEncodedJson(apiCallResponse!.valueResponseClassEncodedJson!);

                   VwNode printedNode= VwNode.fromJson(apiCallResponse!.valueResponseClassEncodedJson!.data!);

                  Widget printedPage=  VwNodeSubmitPage( appInstanceParam: widget.appInstanceParam, node: printedNode,parentNodeId: printedNode!.parentNodeId!,);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => printedPage ),
                    );

                  }
              }


          }

        }
      }
      catch (error) {

      }
    }
      );


  }

  AppBar buildDefaultAppBar(
      Key key,
      BuildContext context,
      PagingController pagingController,
      TextEditingController textEditingController,
      FocusNode myFocusNode,
      SetStateFunction setStateFunction,
      VwRowData currentApiCallParam) {
    double fontSize = 16;

    if (widget.showBackArrow == true) {
      fontSize = 16;
    }

    TextStyle titleWidgetStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: widget.mainHeaderTitleTextColor);

    if (this.widget.showBackArrow == false) {
      titleWidgetStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: widget.mainHeaderTitleTextColor);
    }

    /*
    Widget? titleWidget = Text(
      widget.pageTitleCaption!,
      style: GoogleFonts.openSans(
          textStyle: titleWidgetStyle,
          fontSize: 16,
          fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    );*/
    Widget? centerTitleWidget = this.getMainLogo(textStyle: titleWidgetStyle

        /*TextStyle(

            textStyle: titleWidgetStyle,
            fontSize: 16,
            fontWeight: FontWeight.w600)*/
        );

    Widget? rootLogoPathWidget = Image.asset(
      AppConfig.rootLogoPath,
    );
/*
    Widget? logoWidget =
        this.widget.pageTitleCaption == null || widget.showAppTitle == false
            ? null
            : Row(children: [
                widget.showBackArrow == false && widget.showAppLogo
                    ? SizedBox(height: 35,child: Image.asset(
                  AppConfig.mainLogoPath,

                ),)
                    : Container(),

              ]);


     if (AppConfig.rootLogoPath.length>3 &&
        this.widget.apiCallParam.getFieldByName("nodeId") != null &&
        this
            .widget
            .apiCallParam
            .getFieldByName("nodeId")!
            .valueString
            .toString() ==
           APIVirtualNode.exploreNodeFeed) {
      logoWidget = SizedBox(height: 30, child:Image.asset(AppConfig.rootLogoPath));
    }*/

    List<Widget>? actionWidgetList = [];

    String? currentNodeId;

    try {
      currentNodeId =
          widget.apiCallParam.getFieldByName("nodeId")!.valueString!;
    } catch (error) {}

    bool showDownloadTicketShowEventData =
        this.widget.appInstanceParam.loginResponse != null &&
            this.widget.appInstanceParam.loginResponse!.userInfo != null &&
            this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .userInfo!
                    .user
                    .mainRoleUserGroupId ==
                "adminticket" &&
            (currentNodeId != null &&
                currentNodeId == "response_ticketshoweventformdefinition");

    if (showDownloadTicketShowEventData == true) {
      Widget downloadTicketShowEventData = IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            this.requestDownloadTicketShowEvent = true;
            this.enableFetch = true;
            pagingController.refresh();
            setStateFunction(context);
          },
          icon: Icon(Icons.download));

      actionWidgetList.add(downloadTicketShowEventData);
    }

    actionWidgetList.add(this.getPrintWidget());

    if (this.widget.showReloadButton == true) {
      actionWidgetList.add(this.reloadButton());
    }

    if (widget.showSearchIcon == true) {
      Widget searchIcon = Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Widget searchPage = NodeListView(
                appInstanceParam: this.widget.appInstanceParam,
                showUserInfoIcon: false,
                apiCallId: this.widget.apiCallId,
                autoFetch: false,
                apiCallParam: widget.apiCallParam,
                drawer: widget.drawer,
                nodeRowViewerFunction: widget.nodeRowViewerFunction,
                pageMode: NodeListView.pmSearch,
                showBackArrow: true,
              );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => searchPage),
              );
            },
            icon: Icon(
              Icons.search,
              size: 30,
              color: widget.mainHeaderTitleTextColor,
            ),
          ));
      actionWidgetList.add(searchIcon);
    }



    if (this.widget.showMessenger == true &&
        this.widget.appInstanceParam.loginResponse != null &&
        this.widget.appInstanceParam.loginResponse!.userInfo != null) {
      Widget messengerIconWidget = IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwHeadMessageMessenger(
                      appInstanceParam: widget.appInstanceParam)),
            );
          },
          icon: Icon(
            Icons.message_outlined,
            size: 30,
            color: widget.mainHeaderTitleTextColor,
          ));
      messengerIconWidget=Container();
      actionWidgetList.add(messengerIconWidget);
    }

    Widget loginButton = Container();
    if (this.widget.showLoginButton == true &&
        (this.widget.appInstanceParam.loginResponse == null ||
            (this.widget.appInstanceParam.loginResponse != null &&
                this.widget.appInstanceParam.loginResponse!.userInfo ==
                    null))) {
      loginButton = this.getLoginButton();

      /*
      actionWidgetList.add(SizedBox(
        width: 0,
      ));*/
      actionWidgetList.add(loginButton);

      actionWidgetList.add(SizedBox(
        width: 7,
      ));
    }

    if (widget.showNotificationIcon) {
      Widget notificationIcon = InkWell(
        key: Key("notificationIcon"),
        child: Icon(Icons.notifications),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwUserNotificationPage(
                        appInstanceParam: this.widget.appInstanceParam,
                      )));
        },
      );
      actionWidgetList.add(notificationIcon);
    }
    Widget userInfoIcon = Container();
    if (widget.showUserInfoIcon == true) {
      userInfoIcon = IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () {
            Navigator.push(
              context,
              MaterialTransparentRoute(
                  builder: (context) => Container(
                      color: Colors.black38,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: getUserInfoPageNodeListView()))),
            );
          },
          icon: ProfilePictureUtil.getUserProfilePictureFromAppInstanceParam(
              appInstanceParam: this.widget.appInstanceParam));

      actionWidgetList.add(userInfoIcon);
    }

    /*
    actionWidgetList.add(SizedBox(
      width: 4,
    ));*/

    Widget? backArrow = this.widget.showBackArrow == true
        ? InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: this.widget.mainHeaderTitleTextColor,
            ))
        : this.widget.showRootLogoPath == false
            ? null
            : Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: rootLogoPathWidget);

    // actionWidgetList.add(SizedBox(width: 10,));
    double appBarHeight= this.widget.toolbarHeight - (this.widget.toolbarPadding * 2);

    if(appBarHeight<0)
      {
        appBarHeight=40;
      }

    return AppBar(
      toolbarHeight: this.widget.toolbarHeight,
      backgroundColor: widget.mainHeaderBackgroundColor,
      automaticallyImplyLeading: false,
      centerTitle: this.widget.mainLogoAlignment == NodeListView.mlaCenter
          ? true
          : false,
      leading: backArrow != null
          ? FadeIn(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutBack,
              child: backArrow)
          : null,
      actions: actionWidgetList,
      title: Container(
          height:appBarHeight,
          child: Row(
            mainAxisAlignment: this.widget.appBarMenu != null
                ? MainAxisAlignment.spaceBetween
                : widget.mainLogoAlignment == NodeListView.mlaCenter
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              centerTitleWidget,
              /*FadeIn(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOutBack,
                  child: centerTitleWidget),*/

              this.widget.appBarMenu == null
                  ? Container()
                  : this.widget.appBarMenu!
            ],
          )),
    );
  }

  Widget buildAppBarSearchField(
      Key key,
      BuildContext context,
      PagingController pagingController,
      TextEditingController textEditingController,
      FocusNode focusNode,
      SetStateFunction setStateFunction,
      VwRowData currentApiCallParam) {
    Widget returnValue = Container();



    Widget qrScannerWidget = InkWell(
        onTap: () async {
          var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VwMobileScanner(key: this.scannerKey),
              ));

          if (res is String) {
            this.scannerKey = UniqueKey();

            if (res.startsWith("https://") == true) {
              Uri uri = Uri.parse(res);
              String? ticketCode = uri.queryParameters["ticketCode"] != null
                  ? uri.queryParameters["ticketCode"]
                  : null;

              if (ticketCode != null) {
                textEditingController.value =
                    TextEditingValue(text: ticketCode);
                searchKeyword = ticketCode;
              }
            } else {
              textEditingController.value = TextEditingValue(text: res);
              searchKeyword = res;
            }

            if (res != "") {
              print("submitted");
              FormDefinitionLib.cleanZeroLengthString(this.currentApiCallParam);
              this.enableFetch = true;

              pagingController.refresh();
            } else {
              print("no keyword");
            }
            setStateFunction(context);
          }

          setState(() {});
        },
        child: Icon(
          Icons.qr_code_scanner,
          size: 23,
        ));

    Widget textFieldWidget = TextField(
      maxLength: 64,
      maxLines: 1,

      controller: textEditingController,
      showCursor: true,
      cursorColor: Colors.black,
      //focusNode: this.searchFocusNode,
      style: TextStyle(color: Colors.black, fontSize: 18),
      onSubmitted: (String value) {
        searchKeyword = value;
        if (value != "") {
          FormDefinitionLib.cleanZeroLengthString(this.currentApiCallParam);
          this.enableFetch = true;
          pagingController.refresh();
          setStateFunction(context);
        } else {
          print("no keyword");
        }
      },
      decoration: InputDecoration(
        counterText: '',
        hintText: this.widget.hintSearchBox, //hint text
        isDense: true,
        //contentPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0),
        //border: InputBorder.none,
        //filled: true, //<-- SEE HERE
        //fillColor: Colors.white,
        prefixIcon: this.widget.showQrScannerWidgetOnSearchTextField == true
            ? qrScannerWidget
            : null,
        prefixIconColor: Colors.black,
        //hintStyle: TextStyle( color: Colors.white60),

        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );

    //returnValue=SizedBox(height: 35,child: returnValue,);

    returnValue = SizedBox(height: 35, child: textFieldWidget);

    return returnValue;
  }

  Future<bool> askCameraPermission() async {
    try {
      PermissionStatus status = await Permission.camera.request();
      if (status.isDenied == true) {
        await askCameraPermission();
      } else {
        return true;
      }
    } catch (error) {}
    return false;
  }

  void _implementOnFormFieldValueChanged(
      VwFieldValue newValue,
      VwFieldValue oldValue,
      VwRowData currentFormResponse,
      bool isDoSetState) {}

  bool getIsShowAppBar() {
    bool returnValue = false;
    try {
      if (this.widget.enableAppBar == false) {
        returnValue = false;
      } else if (this.widget.pageMode == NodeListView.pmSearch) {
        returnValue = true;
      } else {
        returnValue = (this.widget.mainLogoMode == NodeListView.mlmText ||
                this.widget.mainLogoMode == NodeListView.mlmLogo) ||
            (this.widget.showNotificationIcon == true ||
                this.widget.showUserInfoIcon == true ||
                this.widget.showSearchIcon == true ||
                this.widget.showBackArrow == true);
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getUserInfoPageNodeListView() {
    Widget returnValue = Container();
    try {
      if (this
              .widget
              .appInstanceParam
              .loginResponse!
              .userInfo!
              .user
              .mainRoleUserGroupId ==
          AppConfig.userQuoraMainRole) {
        returnValue =
            UserInfoPagePublic (appInstanceParam: this.widget.appInstanceParam);
      } else {
        returnValue =
            UserInfoPage(appInstanceParam: this.widget.appInstanceParam);
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getCommentBox(String targetNodeId) {
    return VwFormPage(
        enableScaffold: false,
        syncCaption: "Tambah",
        formName: "Komentar",
        enablePopContextAfterSucessfullySaved: false,
        refreshDataOnParentFunction: () {
          this._pagingController.refresh();
        },
        isShowAppBar: false,
        enableTitle: false,
        loadFormDefinitionFormServer: true,
        formResponse: VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "parentarticlenodeid", valueString: targetNodeId),
          VwFieldValue(fieldName: "comment"),
          VwFieldValue(
              fieldName: "attachment",
              valueTypeId: VwFieldValue.vatFieldFileStorage)
        ]),
        formDefinition: VwFormDefinition(
            loadDetailFromServer: false,
            formResponseSyncCollectionName: "submitcommentnodeformdefinition",
            sections: [],
            timestamp: VwDateUtil.nowTimestamp(),
            formName: "comment",
            recordId: "submitcommentnodeformdefinition"),
        appInstanceParam: widget.appInstanceParam,
        formDefinitionFolderNodeId: "commentnodeformdefinition");
  }

  Widget getVideoPointerBox(String targetNodeId) {
    return VwFormPage(
        enableScaffold: false,
        syncCaption: "Tambah",
        formName: "Janji",
        enablePopContextAfterSucessfullySaved: false,
        refreshDataOnParentFunction: () {
          this._pagingController.refresh();
        },
        isShowAppBar: false,
        enableTitle: false,
        loadFormDefinitionFormServer: true,
        formResponse: VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "parentarticlenodeid", valueString: targetNodeId),
          VwFieldValue(fieldName: "comment"),
          VwFieldValue(
              fieldName: "attachment",
              valueTypeId: VwFieldValue.vatFieldFileStorage)
        ]),
        formDefinition: VwFormDefinition(
            loadDetailFromServer: false,
            formResponseSyncCollectionName: "submitvideopointerformdefinition",
            sections: [],
            timestamp: VwDateUtil.nowTimestamp(),
            formName: "comment",
            recordId: "submitvideopointerformdefinition"),
        appInstanceParam: widget.appInstanceParam,
        formDefinitionFolderNodeId: "submitvideopointerformdefinition");
  }

  Widget getBottomSideWidget() {
    Widget returnValue = Container();
    try {
      if (this.widget.bottomSideMode == NodeListView.bsmCommentBox) {
        String targetNodeId = this
            .widget
            .apiCallParam
            .getFieldByName("parentarticlenodeid")!
            .valueString!;
        returnValue = this.getCommentBox(targetNodeId);
      } else if (this.widget.bottomSideMode ==
          NodeListView.bsmVideoPointerBox) {
        String targetNodeId = this
            .widget
            .apiCallParam
            .getFieldByName("parentarticlenodeid")!
            .valueString!;
        returnValue = this.getVideoPointerBox(targetNodeId);
      }
    } catch (error) {}
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();

    try {
      Widget? appBar = getIsShowAppBar() == false
          ? null
          : buildAppBar(
              currentKey,
              context,
              _pagingController,
              searchBoxtextEditingController,
              myFocusNode,
              setStateOnParent,
              currentApiCallParam);



     EdgeInsetsGeometry bodyMargin=EdgeInsets.all(5);

      if(appBar==null)
        {
         bodyMargin=EdgeInsets.fromLTRB(5, 5, 5, 5);
        }
      else if(widget.margin!=null){
        bodyMargin=widget.margin!;
    }


      Widget body = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double standarBottomAreaHeight = 200;
        double bottomAreaHeight = standarBottomAreaHeight;

        double? listWidgetHeight;

        if (constraints.maxHeight.isInfinite == true) {
        } else {
          listWidgetHeight = constraints.maxHeight;
        }
        Widget bodyWidget = Container(
            height: listWidgetHeight,
            child: buildBody(
                key: currentKey,
                context: context,
                pagingController: _pagingController,
                bottomRow: this.widget.bottomRowWidget));

        Widget returnValue = bodyWidget;

        if (this.widget.bottomSideMode == NodeListView.bsmCommentBox ||
            this.widget.bottomSideMode == NodeListView.bsmVideoPointerBox) {
          try {
            if (constraints.maxHeight < 200) {
              bottomAreaHeight = constraints.maxHeight * 0.2;
            }

            returnValue = Column(
              children: [
                Container(
                  key: listKey,
                  child: bodyWidget,
                  //constraints: BoxConstraints(maxHeight: constraints.maxHeight - bottomAreaHeight),
                ),
                Container(
                    key: commentBoxKey,
                    constraints: BoxConstraints(
                        minHeight: bottomAreaHeight,
                        maxHeight: bottomAreaHeight),
                    child: this.getBottomSideWidget())
              ],
            );
          } catch (error) {}
        }

        if (this.widget.bottomRowWidget != null) {
          returnValue = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [bodyWidget, widget.bottomRowWidget!],
          );
        }

        return returnValue;
      });

      if (this.widget.enableScaffold == true) {
        returnValue = Scaffold(
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: true,
            key: this.widget.key,
            floatingActionButton: widget.getFloatingActionButton == null
                ? null
                : widget.getFloatingActionButton!(
                    context: context,
                    appInstanceParam: widget.appInstanceParam,
                    syncNodeToParentFunction:
                        this.implementRefreshDataOnParentFunction,
                    refreshDataOnParentFunction: this._refreshData),
            drawer: widget.drawer == null
                ? null
                : widget.drawer!(this._globalKey, context),
            body: Stack(
              children: [
                Container(margin: bodyMargin, child: body),
                appBar == null
                    ? Container()
                    : Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: FadeIn(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeInOutBack,
                            child: appBar!),
                      ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.footer == null
                      ? Container()
                      : widget.footer!(
                          parameter: widget.footerWidgetParameter,
                          refreshDataOnParentFunction: this.reloadData),
                )
              ],
            ));
      } else {
        returnValue = Container(
            color: widget.backgroundColor,
            child: Stack(
              key: this.widget.key,
              children: [
                Container(margin: bodyMargin, child: body),
                appBar == null
                    ? Container()
                    : Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: FadeIn(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeInOutBack,
                            child: appBar!),
                      ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.footer == null
                      ? Container()
                      : widget.footer!(
                          parameter: this.widget.footerWidgetParameter,
                          refreshDataOnParentFunction: this.reloadData),
                ),
              ],
            ));
      }
    } catch (error) {
      print("Error catched on NodeListView: " + error.toString());
    }

    return returnValue;
  }
}
