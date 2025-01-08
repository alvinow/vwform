import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:matrixclient2base/appconfig.dart';

import 'dart:convert';

import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:vwform/modules/vwwidget/vwqrcodepage/vwqrcodepage.dart';


class UserInfoPage extends StatefulWidget {
  UserInfoPage({required this.appInstanceParam});

  final VwAppInstanceParam appInstanceParam;

  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();

    //String appRoleId='';
    String appRoleName =
        widget.appInstanceParam.loginResponse!.userInfo != null &&
                widget.appInstanceParam.loginResponse!.userInfo!.user
                        .mainRoleUserGroupId !=
                    null
            ? widget.appInstanceParam.loginResponse!.userInfo!.user
                .mainRoleUserGroupId
            : "<error>";

    String userName =
        this.widget.appInstanceParam.loginResponse!.userInfo!.user.username;

    String fullName =  this.widget.appInstanceParam.loginResponse!.userInfo!.user.displayname;

    String? organizationId = this
        .widget
        .appInstanceParam
        .loginResponse!
        .userInfo!
        .user
        .organizationId;

    /*
    String roleAppId = '';
    int permissionLevel = 99;
    String validFrom = '';
    String validUntil = '';

     */

    Widget loginSessionWidget = InkWell(
        onTap: () async {
          if (this.widget.appInstanceParam.loginResponse != null &&
              this.widget.appInstanceParam.loginResponse!.loginSessionId !=
                  null) {
            String loginBySessionIdUrl = AppConfig.baseUrl +
                "/?loginSessionId=" +
                this.widget.appInstanceParam.loginResponse!.loginSessionId! +
                "&authMode=loginBySessionId";
            //await Clipboard.setData(ClipboardData(text: loginBySessionIdUrl));

            await Navigator.push(
                context,
                MaterialTransparentRoute(
                    builder: (context) => VwQrCodePage(
                        title: "Login by SessionId",
                        data: loginBySessionIdUrl)));

            /*
          Fluttertoast.showToast(
              msg: "Copied to clipboard",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
              webPosition: "center",
              fontSize: 16.0);*/
          }
        },
        child: Icon(Icons.qr_code_2, size: 20));

    Widget iconUser = Icon(
      Icons.person_pin,
      size: 80,
    );

    Widget logoutButton = TextButton.icon(
        style: TextButton.styleFrom(backgroundColor: Colors.blue),
        label: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          this
              .widget
              .appInstanceParam
              .appBloc
              .add(LogoutPagecoordinatorEvent(timestamp: DateTime.now()));
          Navigator.of(context).pop(['Test', 'List']);
        },
        icon: Icon(
          Icons.logout,
          color: Colors.white,
        ));

    Widget titleWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppConfig.appTitle,
            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 3,
          ),
          Container(
              child: Text(
                "v." + AppConfig.appVersion,
                style: TextStyle(fontSize: 12),
              ))
        ]);

    Widget bodyWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        titleWidget,
        SizedBox(
          height: 18,
        ),
        iconUser,
        Text(
          userName,
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          fullName,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 3,
          width: 3,
        ),
        appRoleName == "instagramOperator"
            ? Container()
            : Text(
                "OrganizationId : " + organizationId.toString(),
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
        appRoleName == "instagramOperator"
            ? Container()
            : Text(
                "Role : " + appRoleName,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
        appRoleName == "instagramOperator" ? Container() : Container(),
        SizedBox(
          height: 20,
          width: 8,
        ),
        logoutButton,
        SizedBox(
          height: 20,
          width: 20,
        ),
      ],
    );

    returnValue = Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: AppBar(
            centerTitle: true,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
            automaticallyImplyLeading: false,
          )),
      body: SingleChildScrollView(
        child: Center(child: bodyWidget),
      ),
    );

    return returnValue;
  }
}
