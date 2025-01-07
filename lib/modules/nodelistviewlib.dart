import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwutil/modules/util/nodeutil.dart';


class NodeListViewLib {


  static Future<VwNodeRequestResponse> fetchRenderedNode(
      {
        required VwRowData apiCallParam,
        required String apiCallId,
      required PagingController<int, VwNode > pagingController,
      required int pageKey,
      required int pageSize,
      required String loginSessionId,
      VwNode? topRowNode,
      List<VwLinkNode>? selectedLinkNode
      }) async {
    VwNodeRequestResponse returnValue = VwNodeRequestResponse();
    try {
      VwFieldValue offset =
          VwFieldValue(fieldName: "offset", valueNumber: pageKey.toDouble());
      VwFieldValue limit =
          VwFieldValue(fieldName: "limit", valueNumber: pageSize.toDouble());

      if (apiCallParam.getFieldIndexByName("offset") == -1) {
        apiCallParam.fields!.add(offset);
      } else {
        apiCallParam.getFieldByName("offset")!.valueNumber = pageKey.toDouble();
      }

      if (apiCallParam.getFieldIndexByName("limit") == -1) {
        apiCallParam.fields!.add(limit);
      } else {
        apiCallParam.getFieldByName("limit")!.valueNumber = pageSize.toDouble();
      }


      returnValue = await RemoteApi.nodeRequestApiCall (apiCallId: apiCallId,
          apiCallParam: apiCallParam, loginSessionId: loginSessionId);

      if (returnValue.apiCallResponse != null) {
        if (returnValue.renderedNodePackage != null &&
            returnValue.renderedNodePackage!.renderedNodeList != null) {
          final isLastPage =
              returnValue.renderedNodePackage!.renderedNodeList!.length <
                  pageSize;

          List<VwNode> renderedNodeList=[];

          if(topRowNode!=null && pageKey==0) {
            renderedNodeList.add(topRowNode);
          }


          if(selectedLinkNode!=null)
            {
              try {
                for (int la = 0; la <
                    returnValue.renderedNodePackage!.renderedNodeList!
                        .length; la++) {
                  VwNode currentNode = returnValue.renderedNodePackage!
                      .renderedNodeList!.elementAt(la);
                  if (NodeUtil.isLinkNodeExistOnField(
                      field: selectedLinkNode, checking: currentNode) ==
                      false) {
                    renderedNodeList.add(currentNode);
                  }
                }
              }
              catch(error)
    {

    }
            }
          else{
            renderedNodeList.addAll(returnValue.renderedNodePackage!.renderedNodeList!);
          }

          if (isLastPage) {

            pagingController.appendLastPage(
              renderedNodeList
                );
          } else {




            final nextPageKey = pageKey +
                returnValue.renderedNodePackage!.renderedNodeList!.length;



            pagingController.appendPage(
                renderedNodeList,
                nextPageKey);
          }
        }
      } else {
        pagingController.itemList = [];
        pagingController.appendLastPage(<VwNode>[]);
      }
    } catch (error) {
      pagingController.error = error;
    }
    return returnValue;
  }
}
