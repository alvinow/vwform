import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';

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