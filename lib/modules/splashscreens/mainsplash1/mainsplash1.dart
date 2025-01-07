import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';

class MainSplash1 extends StatefulWidget{
  const MainSplash1(
      {Key? key,
        required this.logoAssetPath,
        required this.title,
        this.description,
        required this.initsplashscreenParam,
        this.showLogo=true,
        this.showTitle=true,
        this.backgroundColor=Colors.white,
        this.titleColor=Colors.black
      })
      : super(key: key);

  final String title;
  final String logoAssetPath;
  final String? description;
  final VwRowData initsplashscreenParam;
  final bool showLogo;
  final bool showTitle;
  final Color backgroundColor;
  final Color titleColor;


  _MainSplashState createState()=>_MainSplashState();
}

class _MainSplashState extends State<MainSplash1> {
late Image mainImage;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainImage = Image.asset(this.widget.logoAssetPath, scale: 0.1,);

  }



  Future<Image> loadImage() async{
    await precacheImage(mainImage.image, context);

    return mainImage;
  }

  @override
  Widget build(BuildContext context) {
    String versionNumber =
        widget.initsplashscreenParam .getFieldByName('appVersionNumber') != null
            ?widget.initsplashscreenParam
                .getFieldByName('appVersionNumber')!
                .getValueAsString()
            : AppConfig.appVersion;


    return FutureBuilder<Image>(
      future: loadImage(),
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.data ==null) {
          return Container();
        } else {
           return Scaffold(
             backgroundColor: widget.backgroundColor,
              body:FadeIn(
               duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOutBack,
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  this.widget.showLogo==true && mainImage!=null ?LayoutBuilder(builder:  (BuildContext context, BoxConstraints constraints){
                    Size screenSize = MediaQuery.of(context).size;



                    return SizedBox(width:screenSize.shortestSide*0.7, child:mainImage);
                  } ):Container(),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      widget.showTitle==true
                          ? LayoutBuilder(builder:  (BuildContext context, BoxConstraints constraints){
                        Size screenSize = MediaQuery.of(context).size;

                            return Text(
                              widget.title,
                              style:

                              TextStyle(
                                  color: widget.titleColor,
                                  fontSize: screenSize.width*0.1,
                                  fontWeight: FontWeight.w800)

                              ,
                            );
                      } )
                          : Container(),
                    ],
                  ),
                  /*Text(
                    'Ver. ' + versionNumber,
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  )*/
                ],
              )));
        }
      },
    );


  }
}
