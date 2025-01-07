
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfieldfiletagdefinition/vwfieldfiletagdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
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