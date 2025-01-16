import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';

class VwSpecifiedFormSubmit extends StatefulWidget{

  VwSpecifiedFormSubmit({
    required this.appInstanceParam,
     this.formResponse,
    this.formDefinition,
    this.containerFolderNode,
    required this.containerFolderNodeId
});

  final VwAppInstanceParam appInstanceParam;
  final VwRowData? formResponse;
  final VwFormDefinition? formDefinition;
  final VwNode? containerFolderNode;
  final String containerFolderNodeId;

  VwSpecifiedFormSubmitState createState()=> VwSpecifiedFormSubmitState();
}

class VwSpecifiedFormSubmitState extends State<VwSpecifiedFormSubmit>{

  @override
  Widget build(BuildContext context) {
    /*
    Widget userInfoIcon=IconButton(onPressed: (){
      Navigator.push(
        context,
        MaterialTransparentRoute (
            builder: (context) => Container(
                color: Colors.black38,
                child: Container(
                    margin: EdgeInsets.fromLTRB(20, 100, 20, 200),
                    child: UserInfoPage(

                        appInstanceParam: this.widget.appInstanceParam)))),
      );
    }, icon: Icon(
      Icons.person_pin,
      size: 40,
    ));

    Widget createNewRecordButton=Container();

    if(widget.formDefinition!=null && widget.formResponse!=null)
      {
        createNewRecordButton= FloatingActionButton.extended(
          label: Text('Create New Record'), // <-- Text
          backgroundColor: Colors.black,
          icon: Icon( // <-- Icon
            Icons.create_new_folder_outlined,
            size: 24.0,
          ),
          onPressed: () async{
            String formDefinitionFolderNodeId= AppConfig.formDefinitionFolderNodeId;

            VwFormPage formPage= VwFormPage(
              enablePopContextAfterSucessfullySaved: true,
              appInstanceParam: VwAppInstanceParam(
                  loginResponse: widget.appInstanceParam.loginResponse, appBloc: widget.appInstanceParam.appBloc ),
              formDefinitionFolderNodeId: formDefinitionFolderNodeId,
              isMultipageSections: true,
              formDefinition: widget.formDefinition,
              formResponse: widget.formResponse,
              //refreshDataOnParentFunction:this.refreshDataOnParentFunction,
            );
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  formPage),
            );
          },
        );
      }
*/




    /*
   Widget noListPage= Scaffold(
      appBar: AppBar(
        title:  Text(widget.formDefinition.formName.toString()),
        actions: [userInfoIcon,SizedBox(width: 10,height: 10)],
      ),
      body: Column(children: <Widget>[
        //const Text('Align Button to the Bottom in Flutter'),
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: createNewRecordButton))
      ]),
    );*/

   Widget listViewPage=VwFormResponseUserPage(
     mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
     currentNode: widget.containerFolderNode,
     folderNodeId: widget.containerFolderNodeId,
       isRootFolder: true,
       appInstanceParam: widget.appInstanceParam);

   return listViewPage;

  }
}