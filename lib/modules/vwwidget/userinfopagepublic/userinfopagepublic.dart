import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/edokumen2022/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:matrixclient/modules/util/profilepictureutil.dart';

class UserInfoPagePublic extends StatefulWidget {
  UserInfoPagePublic({required this.appInstanceParam});

  final VwAppInstanceParam appInstanceParam;

  _UserInfoPagePublic createState() => _UserInfoPagePublic();
}

class _UserInfoPagePublic extends State<UserInfoPagePublic> {
  Widget getProfilePicture() {
    Widget returnValue = Container();
    try {
      returnValue =
          ProfilePictureUtil.getUserProfilePictureFromAppInstanceParam(
              appInstanceParam:this.widget.appInstanceParam,size: 160);
    } catch (error) {}
    return returnValue;
  }

  Widget getEmail() {
    Widget returnValue = Container();
    try {
      returnValue = Text(
          this.widget.appInstanceParam.loginResponse!.userInfo!.user.email,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,),);
    } catch (error) {}
    return returnValue;
  }

  Widget getDisplayName() {
    Widget returnValue = Container();
    try {
      returnValue = Text(this
          .widget
          .appInstanceParam
          .loginResponse!
          .userInfo!
          .user
          .displayname,style: TextStyle(fontSize: 30 , fontWeight: FontWeight.w700),);
    } catch (error) {}
    return returnValue;
  }

  Widget getLogoutButton(){
    Widget returnValue=Container();
    try
        {
          returnValue = TextButton.icon(
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

        }
        catch(error)
    {

    }
    return returnValue;
  }

  Widget getBody() {
    Widget returnValue = Container();
    try {
      returnValue=Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [this.getProfilePicture(),
              this.getDisplayName(),
              this.getEmail(),
              SizedBox(height: 30,),
              this.getLogoutButton()
            ],

          )

        ],
      );
    } catch (error) {}
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();
    try {
      returnValue=Scaffold(
        appBar: AppBar(

          title: Text("User Info",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),),

        ),
        body:SingleChildScrollView(child: this.getBody())
      );

    } catch (error) {}
    return returnValue;
  }
}
