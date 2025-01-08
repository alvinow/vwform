import 'package:flutter/cupertino.dart';
import 'package:vwform/modules/vwwidget/vwexpanderwidget/vwexpanderwidget.dart';


class VwMobileHeaderWidget extends StatefulWidget{

  VwMobileHeaderWidgetState createState()=>VwMobileHeaderWidgetState();
}
class VwMobileHeaderWidgetState extends State<VwMobileHeaderWidget>{

  @override
  Widget build(BuildContext context) {

    Widget logoMedium=Container();

    /*
    Widget logoMedium=
    LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {

          double topMargin=constraints.maxWidth*0.03;
          double rightMargin=constraints.maxWidth*0.03;

          return Container(margin: EdgeInsets.fromLTRB(0, topMargin, rightMargin, 0),   child:SizedBox(width: constraints.maxWidth*0.18, child: AspectRatio(aspectRatio: 1, child: VwExpanderWidget(child:Image.asset(AppConfig.mainLogoPath,fit:BoxFit.contain)),) ));


        }
    );*/






    Widget mainHeader=VwExpanderWidget(child:Image.asset("assets/image/main_header.jpg",fit:BoxFit.contain) );

    Widget subHeader1=Stack(alignment: Alignment.topRight, children: [mainHeader, logoMedium]);

    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
      subHeader1
    ],);
  }
}