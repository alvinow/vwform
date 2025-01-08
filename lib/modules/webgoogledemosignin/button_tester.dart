// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/main.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwuser/vwuser.dart';
import 'package:matrixclient/modules/edokumen2022/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:matrixclient/modules/util/deviceinfoutil.dart';
import 'package:matrixclient/modules/vwgraphqlclient/modules/vwgraphqlquery/vwgraphqlquery.dart';
import 'package:matrixclient/modules/vwgraphqlclient/modules/vwpgraphqlserverresponse/vwgraphqlserverresponse.dart';
import 'package:matrixclient/modules/vwgraphqlclient/vwgraphqlclient.dart';
import 'package:uuid/uuid.dart';

import 'src/button_configuration_column.dart';

// The instance of the plugin is automatically created by Flutter before calling
// our main code, let's grab it directly from the Platform interface of the plugin.


/// The home widget of this app.
class ButtonConfiguratorDemo extends StatefulWidget {
  /// A const constructor for the Widget.
  const ButtonConfiguratorDemo({super.key,required this.appInstanceParam});

  final VwAppInstanceParam appInstanceParam;


  @override
  State createState() => _ButtonConfiguratorState();
}

class _ButtonConfiguratorState extends State<ButtonConfiguratorDemo> {
  GoogleSignInUserData? _userData; // sign-in information?
  GSIButtonConfiguration? _buttonConfiguration; // button configuration

  @override
  void initState() {
    super.initState();

    pluginGoogle.userDataEvents?.listen((GoogleSignInUserData? userData) async{

      try {
        if (userData != null) {
          print("user Data Not Null");
        }

        if (this.widget.appInstanceParam.loginResponse != null) {
          print("Login Response Value: " +
              jsonEncode(this.widget.appInstanceParam.loginResponse!.toJson()));
        }

        if (userData != null &&
            this.widget.appInstanceParam.loginResponse == null) {
          String deviceId = await DeviceInfoutil.getDeviceId();

          VwRowData parameter = VwRowData(recordId: Uuid().v4(), fields: [
            VwFieldValue(fieldName: "idToken", valueString: userData!.idToken),
            VwFieldValue(fieldName: "deviceClientId", valueString: deviceId),
            VwFieldValue(
                fieldName: "authType", valueString: VwUser.authTypeGoogle),
          ]);

          print("Authorizing idToken");

          AuthorizePagecoordinatorEvent event = AuthorizePagecoordinatorEvent(
              timestamp: DateTime.now(), paramAuthorize: parameter);

          this.widget.appInstanceParam.appBloc.add(event);
        }
        else {
          setState(() {
            _userData = userData;
          }


          );
        }
      }
      catch(error)
      {
        print("Error catched on Event Plugin Google: "+error.toString());
      }

    });

  }

  void _handleSignOut() {
    pluginGoogle.signOut();
    setState(() {
      // signOut does not broadcast through the userDataEvents, so we fake it.
      _userData = null;
    });
  }

  void _handleNewWebButtonConfiguration(GSIButtonConfiguration newConfig) {
    setState(() {
      _buttonConfiguration = newConfig;
    });
  }

  Widget _buildBody() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_userData == null)
                pluginGoogle.renderButton(configuration: _buttonConfiguration),
              if (_userData != null) ...<Widget>[
                Text('Hello, ${_userData!.displayName}!'),

                if (_userData!.photoUrl != null) ...<Widget>[
                Container(constraints: BoxConstraints(maxWidth: 20,maxHeight: 20), child:Image.network(_userData!.photoUrl!)),
                ],
                ElevatedButton(
                  onPressed: _handleSignOut,
                  child: const Text('SIGN OUT'),
                ),
              ]
            ],
          ),
        ),
        /*renderWebButtonConfiguration(
          _buttonConfiguration,
          onChange: _userData == null ? _handleNewWebButtonConfiguration : null,
        ),*/
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        );
  }
}

*/