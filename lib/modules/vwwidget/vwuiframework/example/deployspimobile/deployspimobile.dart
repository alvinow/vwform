import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuideploy/vwuideployparam.dart';
import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipage/vwuipageparam.dart';
import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipagebodycomponent/vwuipagebodycomponentlistnodeparam.dart';
import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipagebodycomponent/vwuipagebodycomponentparam.dart';

class DeploySpiMobile{

  VwUiDeployParam getDeployParam(){
    VwUiDeployParam returnValue;

    VwUiPageBodyComponentParam userNotificationPageBodyComponent=  VwUiPageBodyComponentParam(
        caption: "User Notification",
        listNode: VwUiPageBodyComponentListNodeParam( folderNodeId: AppConfig.spmFolderNodeId,listSearchFieldName: ["nospp","kdsatker"])
    );

    VwUiPageBodyComponentParam tabSPMPageBodyComponent=  VwUiPageBodyComponentParam(
      caption: "SPM",
      listNode: VwUiPageBodyComponentListNodeParam( folderNodeId: AppConfig.spmFolderNodeId,listSearchFieldName: ["nospp","kdsatker"])
    );

    VwUiPageBodyComponentParam formParamPageBodyComponent=  VwUiPageBodyComponentParam(
      caption: "Form",
        listNode: VwUiPageBodyComponentListNodeParam( folderNodeId: AppConfig.formDefinitionFolderNodeId,listSearchFieldName: ["formName","formDescription"])
    );

    VwUiPageBodyComponentParam formResponsePageBodyComponent=  VwUiPageBodyComponentParam(
        caption: "Form",
        listNode: VwUiPageBodyComponentListNodeParam( folderNodeId: AppConfig.formDefinitionFolderNodeId ,listSearchFieldName: ["formName","formDescription"])
    );

    VwUiPageParam bootPageparam= VwUiPageParam(recordId: "boot", tabPages: [tabSPMPageBodyComponent,formParamPageBodyComponent]);

    VwUiPageParam userNotificationPageparam= VwUiPageParam(recordId: "boot", tabPages: [userNotificationPageBodyComponent]);


    returnValue = VwUiDeployParam(uiPages: [

    ]);
    
    return returnValue;
  }
}