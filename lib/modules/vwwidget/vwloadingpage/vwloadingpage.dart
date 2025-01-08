import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:vwform/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';

class VwLoadingPage extends StatelessWidget {
  const VwLoadingPage(
      {Key? key,
        this.title,
        this.icon,
        this.description,
        required this.initsplashscreenParam})
      : super(key: key);

  final String? title;
  final String? description;
  final VwRowData initsplashscreenParam;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {




    return Scaffold(
        body: FadeIn(
            child: Container(
                color: Colors.white,
                child: InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        VwCircularProgressIndicator(),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: FaIcon(
                                  FontAwesomeIcons.folderClosed,
                                  color: Colors.blue,
                                  size: 20,
                                )),*/
                            title != null
                                ? Text(
                              title!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            )
                                : Container(),
                          ],
                        ),
                        description!=null? Text(
                          description!,
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ):Container()
                      ],
                    )))));
  }
}
