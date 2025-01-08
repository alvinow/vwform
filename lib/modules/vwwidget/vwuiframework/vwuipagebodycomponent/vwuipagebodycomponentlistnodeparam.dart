import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';

class VwUiPageBodyComponentListNodeParam{
  VwUiPageBodyComponentListNodeParam({
    required this.folderNodeId,
    this.staticFilter,
    this.listSearchFieldName,
    this.onClickRefPageRecordId
});


  String folderNodeId;
  VwRowData? staticFilter;
  List<String>? listSearchFieldName;
  String? onClickRefPageRecordId;
}