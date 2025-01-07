import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/formdefinitionlib/formdefinitionlib.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/rowdefinitionlib/rowdefinitionlib.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class LoginPage extends StatefulWidget {
  LoginPage(
      {super.key,
        required this.baseUrl,
      required this.appInstanceParam,
      required this.paramLoginPage});

  final VwRowData paramLoginPage;
  final VwAppInstanceParam appInstanceParam;
  final String baseUrl;

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late VwRowData currentVwRow;

  void _implementOnFormFieldValueChanged(
      VwFieldValue newValue,
      VwFieldValue oldValue,
      VwRowData currentFormResponse,
      bool isDoSetState) {}
  late Key formPageKey;
  late Key googleButtonKey;
  late Key signUpKey;

  @override
  void initState() {
    super.initState();
    this.signUpKey = UniqueKey();
    this.googleButtonKey = UniqueKey();
    this.formPageKey = UniqueKey();
    currentVwRow = this.widget.paramLoginPage;
  }

  static String getApplicationName(){
    String returnValue=AppConfig.appTitle;

    try {

      if(Uri.base.path=="/tinjut")
        {
          returnValue="SIM Tindak Lanjut Audit 2024";
        }
      else  if(Uri.base.path=="/edok")
        {
          returnValue="e-Dokumen 2023";
        }

      print("Uri Base Host: " + Uri.base.host);
      print("Uri Base Path" + Uri.base.path);
    }
    catch(error)
    {

    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    String appName = LoginPageState.getApplicationName();
    Widget titleCaption = Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: const FaIcon(
                  FontAwesomeIcons.folderClosed,
                  color: Colors.blue,
                  size: 26,
                )),*/
            Text(
              appName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            )
          ],
        ));

    Widget titleLogo = Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
          height: 125,
          child: ImageFade(
            syncDuration: Duration(seconds: 1),
            // here `bytes` is a Uint8List containing the bytes for the in-memory image
            //scale: 1,
            image: AssetImage(
              AppConfig.mainLogoPath,
            ),
          )),
    );

    Widget versionWidget = Text(
      'Ver. ' + AppConfig.appVersion,
      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
    );

    Widget title = Column(
      children: [
        titleLogo,
        titleCaption,
        versionWidget
      ],
    );

    Widget submitButton =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue),
          onPressed: () {
            String username =
                currentVwRow.getFieldByName('username')!.getValueAsString();
            String password =
                currentVwRow.getFieldByName('password')!.getValueAsString();

            VwRowData loginRow = RowDefinitionLib .convertRowDefinitionToRow(
                rowDefinition: RowDefinitionLib.getLoginRequestRowDefinition());

            VwFieldValue? usernameField = loginRow.getFieldByName('username');

            usernameField?.valueString = username;

            VwFieldValue? passwordField = loginRow.getFieldByName('password');
            passwordField?.valueString = password;

            this.widget.appInstanceParam.appBloc.add(
                AuthorizePagecoordinatorEvent(
                    timestamp: DateTime.now(), paramAuthorize: loginRow));
          },
          icon: const Icon(Icons.login),
          label: const Text('Log In'))
    ]);

    Widget signUpButton = ElevatedButton.icon(
      onPressed: () async {
        Widget userSignUpFormPage = VwFormPage(
            key: this.signUpKey,
            syncCaption: "Kirim",
            formName: "Daftar Akun",
            enableTitle: false,
            loadFormDefinitionFormServer: true,
            formResponse: VwRowData(recordId: Uuid().v4()),
            formDefinition: VwFormDefinition(
                loadDetailFromServer: false,
                formResponseSyncCollectionName: "userquorasignupformdefinition",
                sections: [],
                timestamp: VwDateUtil.nowTimestamp(),
                formName: "Daftar Akun",
                recordId: "userquorasignupformdefinition"),
            appInstanceParam: widget.appInstanceParam,
            formDefinitionFolderNodeId: "userquorasignupformdefinition");

        await showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            isDismissible: false,
            useSafeArea: true,
            context: context,
            builder: (context) => userSignUpFormPage);
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue, backgroundColor: Colors.white),
      label: const Text('Daftar/Sign In email OTP '),
      icon: const Icon(Icons.mail_outline_rounded),
    );

    //Widget googleSignInButton=Container( width:270,height:50,child:ButtonConfiguratorDemo(key:this.googleButtonKey, appInstanceParam: this.widget.appInstanceParam));

    Widget googleSignInButton = Container();

    BoxDecoration boxDecoration1 = BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(2))
        //borderRadius: BorderRadius.circular(10.0),
        );

    Widget loginForm = VwForm(
      baseUrl: this.widget.baseUrl,
        key: this.formPageKey,
        appInstanceParam: widget.appInstanceParam,
        boxDecoration: boxDecoration1,
        onFormValueChanged: _implementOnFormFieldValueChanged,
        backGroundColor: Colors.white,
        initFormResponse: currentVwRow,
        formDefinition: FormDefinitionLib.getLoginForm());

    //form =Text("Hello World!");

    Widget loginBox=Container(

      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      color: Colors.white,
      constraints: BoxConstraints(maxWidth: 350),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          title,

          loginForm,
          Container(
            child: submitButton,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
        ],
      ),
    );

    return Scaffold(
        backgroundColor: Colors.grey,
        key: this.widget.key,
        body:
        SingleChildScrollView(
          //physics: AlwaysScrollableScrollPhysics(),
          child:
          Center(child: Stack(alignment: Alignment.center, children: [loginBox],),)

        ),
    );
  }
}
