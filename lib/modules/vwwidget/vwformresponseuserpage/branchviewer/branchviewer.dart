import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/branchviewer/childbranch.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/subbranchviewer/subbranchviewer.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwdefaultrowviewer/vwdefaultrowviewer.dart';
import 'package:vwform/modules/vwwidget/vwformsubmitpage/vwformsubmitpage.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/vwnodesubmitpage.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class BranchViewer extends StatefulWidget {
  BranchViewer(
      {required super.key,
      this.summaryId = "<none>",
      required this.parentNode,
      required this.childrenBranch,
      this.subBranch = const [],
      required this.parentWidget,
      required this.isExpanded,
      required this.appInstanceParam,
      this.leftMargin = 0,
      required this.localeId,
      this.commandToParentFunction,
      this.refreshDataOnParentFunction,
      this.isRoot = false,
      this.backgroundColor = Colors.white,
      this.actionMenuButton});

  final double leftMargin;
  final List<ChildBranch> childrenBranch;
  final List<ChildBranch> subBranch;
  final Widget parentWidget;
  final VwNode parentNode;
  final bool isRoot;
  final bool isExpanded;
  final String summaryId;
  final VwAppInstanceParam appInstanceParam;
  final String localeId;
  final CommandToParentFunction? commandToParentFunction;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final Widget? actionMenuButton;
  final Color backgroundColor;
  BranchviewerState createState() => BranchviewerState();
}

class BranchviewerState extends State<BranchViewer> {
  late bool currentExpandedState;
  late Key stateKey;
  late Key branch0Key;
  late Key branch1Key;

  @override
  void initState() {
    super.initState();
    this.branch0Key = Key(Uuid().v4());
    this.branch1Key = Key(Uuid().v4());
    currentExpandedState = widget.isExpanded;
    if (widget.key != null) {
      this.stateKey = widget.key!;
    } else {
      this.stateKey = Key(Uuid().v4());
    }
  }

  static VwRowData apiCallParam(ChildBranch childBranch) {
    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId", valueString: childBranch.branchNodeId),
          VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: childBranch.depth1FilterObject),
          VwFieldValue(
              fieldName: "depth",
              valueTypeId: VwFieldValue.vatNumber,
              valueNumber: childBranch.depth.toDouble())
        ]);

    return returnValue;
  }

  static Widget iconCircleRight() {
    return Transform.rotate(
        angle: 270 * pi / 180, child: Icon(Icons.expand_circle_down_rounded));
  }

  static Widget iconCircleDown() {
    return Transform.rotate(
        angle: 360 * pi / 180, child: Icon(Icons.expand_circle_down_rounded));
  }

  Widget buttonExpandBranchCurrentlyExpanded() {
    return InkWell(
      child: BranchviewerState.iconCircleDown(),
      onTap: () {
        setState(() {
          this.currentExpandedState = false;
        });
      },
    );
  }

  Widget buttonExpandBranchCurrentlyNotExpanded() {
    return InkWell(
      child: BranchviewerState.iconCircleRight(),
      onTap: () {
        setState(() {
          this.currentExpandedState = true;
        });
      },
    );
  }

  Widget nodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
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
      highlightedText: highlightedText,
      refreshDataOnParentFunction:
          this.widget.refreshDataOnParentFunction != null
              ? this.widget.refreshDataOnParentFunction
              : implementRefreshBranch,
      commandToParentFunction: commandToParentFunction == null
          ? implementReloadData
          : commandToParentFunction,
    );
  }

  void implementReloadData(VwRowData rowData) {
    /*
    setState(() {


    });

     */
  }

  void implementRefreshBranch() {
    try {
      if (this.widget.refreshDataOnParentFunction != null) {
        this.widget.refreshDataOnParentFunction!();
      }
    } catch (error) {}
  }

  static List<Widget> createBranchChildrenViewer() {
    List<Widget> returnValue = [];

    return returnValue;
  }

  void implementRefreshDataOnParentFunction() {
    print("refresh data from isi form");
    setState(() {
      this.stateKey = Key(Uuid().v4().toString());
    });
  }

  static Widget getCreateRecordButtonChildBranch({
    required ChildBranch childBranch,
    required BuildContext context,
    required VwAppInstanceParam appInstanceParam,
    SyncNodeToParentFunction? syncNodeToParentFunction,
    RefreshDataOnParentFunction? refreshDataOnParentFunction,
  }) {
    List<Widget> buttonList = [];

    for (int la = 0; la < childBranch.createRecordButtonList.length; la++) {
      CreateRecordButtonChildBranch currentButtonDef =
          childBranch.createRecordButtonList.elementAt(la);

      Widget currentButton =
          BranchviewerState.getCreateRecordFloatingActionButton(
              icon: Icon(
                currentButtonDef.icon,
                color: Colors.white,
                size: 18,
              ),
              parentNodeId: childBranch.branchNodeId,
              presetValues: currentButtonDef.newRecordPresetValues,
              formDefinitionIdList: [
                currentButtonDef.createRecordFormDefinitionId.toString()
              ],
              refreshDataOnParentFunction: refreshDataOnParentFunction,
              context: context,
              appInstanceParam: appInstanceParam,
              title: currentButtonDef.title);

      buttonList.add(Container(
          constraints: BoxConstraints(maxWidth: 300), child: currentButton));
    }

    Widget returnValue = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buttonList,
    );

    return returnValue;
  }

  static Widget getCreateRecordFloatingActionButton(
      {required List<String> formDefinitionIdList,
      required String parentNodeId,
      required BuildContext context,
      required String title,
      required Widget icon,
      required VwAppInstanceParam appInstanceParam,
      SyncNodeToParentFunction? syncNodeToParentFunction,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      VwRowData? presetValues}) {
    const widgetKey = "123456789";

    Color backgroundColor = Color.fromRGBO(90, 171, 232, 1);

    Widget addNewRecordButton = Tooltip(
        message: 'Tambah Record Baru "' + title + '"',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(2),
          child: Icon(
            Icons.add,
            color: backgroundColor,
            size: 14,
          ),
        ));

    return Container(
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      color: backgroundColor,
      child: Row(children: [
        icon,
        SizedBox(
          width: 3,
        ),
        Text(title,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12, color: Colors.white)),
        SizedBox(
          width: 6,
        ),
        InkWell(
            onTap: () {
              VwNodeSubmitPage nodeSubmitPage = VwNodeSubmitPage(
                  presetValues: presetValues,
                  key: Key(widgetKey),
                  formDefinitionIdList: formDefinitionIdList,
                  parentNodeId: parentNodeId,
                  appInstanceParam: appInstanceParam,
                  refreshDataOnParentFunction: refreshDataOnParentFunction);

              /*
              VwFormSubmitPage formSubmitPage = VwFormSubmitPage(
                lockPresetValue: true,
                presetValues: presetValues,
                key: Key(widgetKey),
                defaultFormDefinitionIdList: formDefinitionIdList,
                appInstanceParam: appInstanceParam,
                refreshDataOnParentFunction: refreshDataOnParentFunction,
              );*/

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nodeSubmitPage),
              );
            },
            child: addNewRecordButton)
      ]),
    );


  }

  static Widget createStatusColumnHeader(
      {VwRowData? parentCurrentRowData,
      required String currentSummaryId,
      required String currentLocaleId}) {
    try {
      Widget summaryRow = Container();

      VwFieldValue jumlahtemuan = VwFieldValue(
          fieldName: "jumlahtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      VwFieldValue nilaitemuan = VwFieldValue(
          fieldName: "nilaitemuan", valueTypeId: VwFieldValue.vatNumber);

      VwFieldValue jumlahsubtemuan = VwFieldValue(
          fieldName: "jumlahsubtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      VwFieldValue nilaisubtemuan = VwFieldValue(
          fieldName: "nilaisubtemuan", valueTypeId: VwFieldValue.vatNumber);

      VwFieldValue jumlahrekomendasi = VwFieldValue(
          fieldName: "jumlahtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      ;
      VwFieldValue nilairekomendasi = VwFieldValue(
          fieldName: "nilaitemuan", valueTypeId: VwFieldValue.vatNumber);

      VwFieldValue jumlahsudahsesuai = VwFieldValue(
          fieldName: "jumlahtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      ;
      VwFieldValue nilaisudahsesuai = VwFieldValue(
          fieldName: "nilaitemuan", valueTypeId: VwFieldValue.vatNumber);

      VwFieldValue jumlahdalamproses = VwFieldValue(
          fieldName: "jumlahtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      ;
      VwFieldValue nilaidalamproses = VwFieldValue(
          fieldName: "nilaitemuan", valueTypeId: VwFieldValue.vatNumber);

      VwFieldValue jumlahbelumtinjut = VwFieldValue(
          fieldName: "jumlahtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      ;
      VwFieldValue nilaibelumtinjut = VwFieldValue(
          fieldName: "nilaitemuan", valueTypeId: VwFieldValue.vatNumber);

      VwFieldValue jumlahtidakdapat = VwFieldValue(
          fieldName: "jumlahtemuan",
          valueTypeId: VwFieldValue.vatNumber,
          valueNumber: 0);
      ;
      VwFieldValue nilaitidakdapat = VwFieldValue(
          fieldName: "nilaitemuan", valueTypeId: VwFieldValue.vatNumber);

      String? summaryRecordId;

      if (parentCurrentRowData!.attachments != null &&
          parentCurrentRowData!.attachments!.length > 0) {
        try {
          for (int la = 0;
              la < parentCurrentRowData!.attachments!.length;
              la++) {
            VwNodeContent? nodeContent =
                parentCurrentRowData!.attachments!.elementAtOrNull(la);

            summaryRecordId = nodeContent!.rowData!.recordId;

            if (nodeContent != null && nodeContent.tag == "#summarytemuan") {
              jumlahtemuan = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahtemuan", defaultValue: jumlahtemuan)!;

              nilaitemuan = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilaitemuan", defaultValue: nilaitemuan)!;

              jumlahsubtemuan = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahsubtemuan",
                      defaultValue: jumlahtemuan)!;

              nilaisubtemuan = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilaisubtemuan", defaultValue: nilaitemuan)!;

              jumlahrekomendasi = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahrekomendasi",
                      defaultValue: jumlahrekomendasi)!;
              nilairekomendasi = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilairekomendasi",
                      defaultValue: nilairekomendasi)!;

              jumlahsudahsesuai = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahsudahsesuai",
                      defaultValue: jumlahsudahsesuai)!;
              nilaisudahsesuai = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilaisudahsesuai",
                      defaultValue: nilaisudahsesuai)!;

              jumlahdalamproses = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahdalamproses",
                      defaultValue: jumlahdalamproses)!;
              nilaidalamproses = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilaidalamproses",
                      defaultValue: nilaidalamproses)!;

              jumlahbelumtinjut = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahbelumtinjut",
                      defaultValue: jumlahbelumtinjut)!;
              nilaibelumtinjut = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilaibelumtinjut",
                      defaultValue: nilaibelumtinjut)!;

              jumlahtidakdapat = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "jumlahtidakdapat",
                      defaultValue: jumlahtidakdapat)!;
              nilaitidakdapat = nodeContent!.rowData!
                  .getFieldByNameOrDefaultFieldValue(
                      fieldName: "nilaitidakdapat",
                      defaultValue: nilaitidakdapat)!;
            }
            break;
          }
        } catch (error) {}
      }

      if (currentSummaryId == "temuanlhp") {
        summaryRow = Row(
          children: [
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaitemuan,
                    jumlah: jumlahtemuan,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Temuan")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaisubtemuan,
                    jumlah: jumlahsubtemuan,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Sub Temuan")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilairekomendasi,
                    jumlah: jumlahrekomendasi,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Rekomendasi")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaisudahsesuai,
                    jumlah: jumlahsudahsesuai,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Sudah Sesuai")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaidalamproses,
                    jumlah: jumlahdalamproses,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Dalam Proses")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaibelumtinjut,
                    jumlah: jumlahbelumtinjut,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Belum Tinjut")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaitidakdapat,
                    jumlah: jumlahtidakdapat,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Tidak Dapat")),
          ],
        );
      } else if (currentSummaryId == "subtemuanlhp") {
        summaryRow = Row(
          children: [
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaisubtemuan,
                    jumlah: jumlahsubtemuan,
                    color: Color(0xc6f6fc),
                    localeId: currentLocaleId,
                    title: "Sub Temuan")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilairekomendasi,
                    jumlah: jumlahrekomendasi,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Rekomendasi")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaisudahsesuai,
                    jumlah: jumlahsudahsesuai,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Sudah Sesuai")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaidalamproses,
                    jumlah: jumlahdalamproses,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Dalam Proses")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaibelumtinjut,
                    jumlah: jumlahbelumtinjut,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Belum Tinjut")),
            Flexible(
                child: BranchviewerState.createCellStatusColumnHeaderTemuan(
                    nilai: nilaitidakdapat,
                    jumlah: jumlahtidakdapat,
                    color: Colors.lightBlue,
                    localeId: currentLocaleId,
                    title: "Tidak Dapat")),
          ],
        );
      } else if (currentSummaryId == "rekomendasitemuanlhp" ||
          currentSummaryId == "rekomendasisubtemuanlhp") {
        if (parentCurrentRowData != null) {
          VwFieldValue? statusRekomendasiTindakLanjutFieldValue =
              parentCurrentRowData!
                  .getFieldByName("statusrekomendasitindaklanjut");


          VwFieldValue? formnilairekomendasiFieldValue=parentCurrentRowData!.getFieldByName("formnilairekomendasi");

          VwFieldValue nilaiRekomendasiTindakLanjutFieldValue=VwFieldValue(fieldName: "nilairupiah",valueTypeId: VwFieldValue.vatNumber);

          if(formnilairekomendasiFieldValue!=null && formnilairekomendasiFieldValue.valueFormResponse!=null && formnilairekomendasiFieldValue.valueFormResponse!.getFieldByName("nilairupiah")!=null) {
            nilaiRekomendasiTindakLanjutFieldValue = formnilairekomendasiFieldValue.valueFormResponse!.getFieldByName("nilairupiah")!;
          }

          VwFieldValue nilaiRekomendasiSudahSesuai = new VwFieldValue(
              fieldName: "name1", valueTypeId: VwFieldValue.vatNumber);

          VwFieldValue nilaiRekomendasiDalamProses = new VwFieldValue(
              fieldName: "name1", valueTypeId: VwFieldValue.vatNumber);
          ;

          VwFieldValue nilaiRekomendasiBelumTinjut = new VwFieldValue(
              fieldName: "name1", valueTypeId: VwFieldValue.vatNumber);
          ;

          VwFieldValue nilaiRekomendasiTidakDapat = new VwFieldValue(
              fieldName: "name1", valueTypeId: VwFieldValue.vatNumber);
          ;

          VwFieldValue statusRekomendasi = VwFieldValue(
            fieldName: "nama",
          );

          if (statusRekomendasiTindakLanjutFieldValue != null &&
              statusRekomendasiTindakLanjutFieldValue.valueLinkNode != null) {
            VwNode? statusRekomendasiNode = NodeUtil.extractNodeFromLinkNode(
                statusRekomendasiTindakLanjutFieldValue.valueLinkNode!);

            if (statusRekomendasiTindakLanjutFieldValue != null &&
                statusRekomendasiTindakLanjutFieldValue!.valueLinkNode !=
                    null) {
              VwNode? rekomendasiFieldValue = NodeUtil.extractNodeFromLinkNode(
                  statusRekomendasiTindakLanjutFieldValue!.valueLinkNode!);
              if (rekomendasiFieldValue != null) {
                statusRekomendasi = rekomendasiFieldValue.content.rowData!
                    .getFieldByName("nama")!;
              }
            }

            String kodeStatusRekomendasi = statusRekomendasiNode!
                .content.rowData!
                .getFieldByName("kode")!
                .valueString
                .toString();

            if(nilaiRekomendasiTindakLanjutFieldValue!=null) {
              if (kodeStatusRekomendasi == "1") {
                nilaiRekomendasiBelumTinjut.valueNumber =
                    nilaiRekomendasiTindakLanjutFieldValue!.valueNumber;
              } else if (kodeStatusRekomendasi == "2") {
                nilaiRekomendasiDalamProses.valueNumber =
                    nilaiRekomendasiTindakLanjutFieldValue!.valueNumber;
              } else if (kodeStatusRekomendasi == "3") {
                nilaiRekomendasiSudahSesuai.valueNumber =
                    nilaiRekomendasiTindakLanjutFieldValue!.valueNumber;
              } else if (kodeStatusRekomendasi == "4") {
                nilaiRekomendasiTidakDapat.valueNumber =
                    nilaiRekomendasiTindakLanjutFieldValue!.valueNumber;
              }
            }
          }

          summaryRow = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child:
                      BranchviewerState.createCellStatusColumnHeaderRekomendasi(
                          fieldValue: statusRekomendasi,
                          textALign: TextAlign.start,
                          color: Colors.red,
                          localeId: currentLocaleId,
                          title: "Status")),
              Flexible(
                  child:
                      BranchviewerState.createCellStatusColumnHeaderRekomendasi(
                          fieldValue: nilaiRekomendasiTindakLanjutFieldValue!,
                          color: Colors.lightBlue,
                          localeId: currentLocaleId,
                          title: "Rekomendasi")),
              Flexible(
                  child:
                      BranchviewerState.createCellStatusColumnHeaderRekomendasi(
                          fieldValue: nilaiRekomendasiSudahSesuai,
                          color: Colors.lightBlue,
                          localeId: currentLocaleId,
                          title: "Sudah Sesuai")),
              Flexible(
                  child:
                      BranchviewerState.createCellStatusColumnHeaderRekomendasi(
                          fieldValue: nilaiRekomendasiDalamProses,
                          color: Colors.lightBlue,
                          localeId: currentLocaleId,
                          title: "Dalam Proses")),
              Flexible(
                  child:
                      BranchviewerState.createCellStatusColumnHeaderRekomendasi(
                          fieldValue: nilaiRekomendasiBelumTinjut,
                          color: Colors.lightBlue,
                          localeId: currentLocaleId,
                          title: "Belum Tinjut")),
              Flexible(
                  child:
                      BranchviewerState.createCellStatusColumnHeaderRekomendasi(
                          fieldValue: nilaiRekomendasiTidakDapat,
                          color: Colors.lightBlue,
                          localeId: currentLocaleId,
                          title: "Tidak Dapat")),
            ],
          );
        }
        // summaryRow=Container(color: Colors.blueGrey, width: 100,height:100 );
      }
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(width: 900, child: summaryRow));
    } catch (error) {
      print("Error catched on Widget createStatusColumnHeader() : " +
          error.toString());
    }
    return Container();
  }

  static Widget createContainerCell(Widget child) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        border: Border.all(
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }

  static Widget createCellStatusColumnHeaderTemuan(
      {required VwFieldValue jumlah,
      required VwFieldValue nilai,
      required Color color,
      required String localeId,
      required String title}) {
    NumberFormat formatCurrency =
        NumberFormat.simpleCurrency(locale: localeId, decimalDigits: 0);

    String nilaiString = "";

    String jumlahString = "";

    if (nilai.valueNumber != null && nilai.valueNumber! > 0) {
      nilaiString = formatCurrency.format(nilai.valueNumber);
    }

    if (jumlah.valueNumber != null && jumlah.valueNumber! > 0) {
      jumlahString = jumlah.valueNumber!.toString();
    }

    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            BranchviewerState.createContainerCell(
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11),
              )
            ])),
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Expanded(
                      flex: 10,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          border: Border.all(
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "jmlh.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 9),
                              )
                            ]),
                      )),
                  Expanded(
                      flex: 40,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          border: Border.all(
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("nilai",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 9)),
                              SizedBox(
                                width: 3,
                              ),
                            ]),
                      )),
                ])),
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              jumlahString,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 11),
                            )
                          ]),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(nilaiString, style: TextStyle(fontSize: 11)),
                            SizedBox(
                              width: 3,
                            ),
                          ]),
                    ),
                  ),
                ]))
          ],
        ));
  }

  static Widget createCellStatusColumnHeaderRekomendasi(
      {required VwFieldValue fieldValue,
      TextAlign textALign = TextAlign.end,
      required Color color,
      required String localeId,
      required String title}) {
    try {
      NumberFormat formatCurrency =
          NumberFormat.simpleCurrency(locale: localeId, decimalDigits: 0);

      String nilaiString = fieldValue.getValueAsString();

      if (fieldValue.valueTypeId == VwFieldValue.vatNumber &&
          fieldValue.valueNumber != null) {
        nilaiString = formatCurrency.format(fieldValue.valueNumber);
      }
      return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BranchviewerState.createContainerCell(
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                    child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9),
                ))
              ])),
              Container(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  flex: 40,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Text(nilaiString,
                        textAlign: textALign, style: TextStyle(fontSize: 9)),
                  ),
                ),
              ]))
            ],
          ));
    } catch (error) {
      print(
          "Error catched on Widget createCellStatusColumnHeaderRekomendasi: " +
              error.toString());
    }
    return Container(child: Text("Failed to Render"));
  }

  Widget twoChildBranch(
      {required BuildContext context, required Widget parentRow}) {
    return Container(
        color: this.widget.backgroundColor,
        key: this.widget.key,
        //margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          key: this.stateKey,
          children: [
            Container(child: parentRow),
            Container(
                margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: SubBranchViewer(
                    key: this.branch0Key,
                    commandToParentFunction: widget.commandToParentFunction,
                    refreshBranch: this.implementRefreshBranch,
                    parentNode: widget.parentNode,
                    childBranch: widget.childrenBranch.elementAt(0),
                    appInstanceParam: widget.appInstanceParam,
                    summaryId: widget.summaryId,
                    localeId: widget.localeId)),
            Container(
                margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: SubBranchViewer(
                    key: this.branch1Key,
                    commandToParentFunction: widget.commandToParentFunction,
                    refreshBranch: this.implementRefreshBranch,
                    parentNode: widget.parentNode,
                    childBranch: widget.childrenBranch.elementAt(1),
                    appInstanceParam: widget.appInstanceParam,
                    summaryId: widget.summaryId,
                    localeId: widget.localeId)),
          ],
        ));
  }

  Widget oneChildBranch(
      {required BuildContext context, required Widget parentRow}) {
    widget.childrenBranch.elementAt(0).isInitiallyExpanded = true;
    widget.childrenBranch.elementAt(0).hideExpandedButton = true;
    return Container(
        color: this.widget.backgroundColor,
        key: this.widget.key,
        //margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          key: this.stateKey,
          children: [
            Container(child: parentRow),
            Container(
                margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: SubBranchViewer(
                    key: this.branch0Key,
                    commandToParentFunction: widget.commandToParentFunction,
                    refreshBranch: this.implementRefreshBranch,
                    parentNode: widget.parentNode,
                    childBranch: widget.childrenBranch.elementAt(0),
                    appInstanceParam: widget.appInstanceParam,
                    summaryId: widget.summaryId,
                    localeId: widget.localeId)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      double width = 500;
      bool isShowSummary = this.widget.summaryId == "temuanlhp" ||
          this.widget.summaryId == "subtemuanlhp" ||
          this.widget.summaryId == "rekomendasitemuanlhp" ||
          this.widget.summaryId == "rekomendasisubtemuanlhp";
      ;
      if (constraint.hasInfiniteWidth == false) {
        width = constraint.maxWidth - 48;
      }

      bool isLandscapeMode = true;

      double recordWidth = isShowSummary == true ? width * 0.35 : width;

      if (width < 500) {
        isLandscapeMode = false;
      }

      if (isLandscapeMode == false) {
        recordWidth = width;
      }

      //double leftMargin = 10;

      double summaryWidthPortrait =
          isShowSummary == true && isLandscapeMode == false ? (width * 0.9) : 0;
      double summaryWidthLandscape =
          isShowSummary == true && isLandscapeMode == true ? (width * 0.62) : 0;

      if (currentExpandedState == true) {
        Widget parentRow = Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //this.widget.isRoot==true?SizedBox(width: 10,):Container(),
              Container(

                  //color: Colors.red,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [buttonExpandBranchCurrentlyExpanded()])),
              Column(children: [
                Container(width: recordWidth, child: widget.parentWidget),
                Container(
                    margin: EdgeInsets.fromLTRB(
                        0,
                        summaryWidthPortrait > 0 ? 10 : 0,
                        0,
                        summaryWidthPortrait > 0 ? 30 : 0),
                    width: summaryWidthPortrait,
                    height: summaryWidthPortrait == 0 ? 0 : null,
                    child: createStatusColumnHeader(
                        parentCurrentRowData: widget.parentNode.content.rowData,
                        currentSummaryId: widget.summaryId,
                        currentLocaleId: widget.localeId))
              ]),
              Container(
                margin: EdgeInsets.fromLTRB(0, 3, 0, 10),
                width: summaryWidthLandscape,
                child: createStatusColumnHeader(
                    parentCurrentRowData: widget.parentNode.content.rowData,
                    currentSummaryId: widget.summaryId,
                    currentLocaleId: widget.localeId),
              ),
              this.widget.actionMenuButton == null
                  ? Container()
                  : this.widget.actionMenuButton!
            ]);

        /*
        Widget branch0NodeListViewWidget = NodeListView(
            mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
            key: this.branch0Key,
            zeroDataCaption: "0 record",
            reloadButtonSize: 18,
            enableAppBar: false,
            isScrollable: false,
            enableScaffold: false,
            appInstanceParam: widget.appInstanceParam,
            apiCallParam: BranchviewerState.apiCallParam(
                widget.childrenBranch.elementAt(0)),
            nodeRowViewerFunction: nodeRowViewer);

        Widget branch1NodeListViewWidget = Container();

        if (widget.childrenBranch.length > 1) {
          branch1NodeListViewWidget = NodeListView(
              mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
              key: this.branch0Key,
              reloadButtonSize: 18,
              zeroDataCaption: "0 record",
              isScrollable: false,
              enableScaffold: false,
              appInstanceParam: widget.appInstanceParam,
              apiCallParam: BranchviewerState.apiCallParam(
                  widget.childrenBranch.elementAt(1)),
              nodeRowViewerFunction: nodeRowViewer);
        }
*/
        //return branchWidget;
        if (widget.childrenBranch.length > 1) {
          return this.twoChildBranch(context: context, parentRow: parentRow);
        } else {
          return this.oneChildBranch(context: context, parentRow: parentRow);
        }
      } else {
        return Container(
            color: this.widget.backgroundColor,
            key: this.widget.key,
            child: Row(
                key: this.stateKey,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        buttonExpandBranchCurrentlyNotExpanded()
                      ])),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: recordWidth, child: widget.parentWidget),
                        isLandscapeMode == true
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(30,
                                    summaryWidthPortrait > 0 ? 10 : 0, 0, 10),
                                width: summaryWidthPortrait,
                                child: createStatusColumnHeader(
                                    parentCurrentRowData:
                                        widget.parentNode.content.rowData,
                                    currentSummaryId: widget.summaryId,
                                    currentLocaleId: widget.localeId))
                      ]),
                  isLandscapeMode == false
                      ? Container()
                      : Container(
                          margin: EdgeInsets.fromLTRB(0, 3, 0, 10),
                          width: summaryWidthLandscape,
                          child: createStatusColumnHeader(
                              parentCurrentRowData:
                                  widget.parentNode.content.rowData,
                              currentSummaryId: widget.summaryId,
                              currentLocaleId: widget.localeId),
                        ),
                  this.widget.actionMenuButton == null
                      ? Container()
                      : this.widget.actionMenuButton!
                ]));
      }
    });
  }
}
