
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfieldfiletagdefinition/vwfieldfiletagdefinition.dart';

class VwMultimediaViewerParam{
  VwMultimediaViewerParam({
    this.fieldFileTagDefinition,
    this.refTagLinkNodeList,
    this.readOnly=false
});

final VwFieldFileTagDefinition? fieldFileTagDefinition;
final List<VwLinkNode>? refTagLinkNodeList;
  final bool readOnly;

}