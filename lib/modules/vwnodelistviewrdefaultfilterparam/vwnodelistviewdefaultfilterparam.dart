

import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';

class VwNodeListViewDefaultFilterParam{
  VwNodeListViewDefaultFilterParam({
    required this.nodeId,
    this.selectedLinkNodeList,
    this.collectionNameList,
    this.contentClassNameList,
    this.refContent,
    this.sort,
    this.depth=1,
    this.nodeType
});

  final int depth;
  final String nodeId;
  final List<String>? nodeType;
  final List<VwLinkNode>? selectedLinkNodeList;
  final List<String>? collectionNameList;
  final List<String>? contentClassNameList;
  final List<VwLinkNode>? refContent;
  final Map<String,dynamic>? sort;

}