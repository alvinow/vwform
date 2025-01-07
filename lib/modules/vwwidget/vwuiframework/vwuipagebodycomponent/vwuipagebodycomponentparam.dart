import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipagebodycomponent/vwuipagebodycomponentdetailnodeparam.dart';
import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipagebodycomponent/vwuipagebodycomponentlistnodeparam.dart';

class VwUiPageBodyComponentParam {
  VwUiPageBodyComponentParam(
      {required this.caption,
      this.detailNode,
      this.listNode,
      this.faIconHexCode = "0xe4cb"});

  String caption;
  String? description;
  VwUiPageBodyComponentDetailNodeParam? detailNode;
  VwUiPageBodyComponentListNodeParam? listNode;
  String faIconHexCode;
}
