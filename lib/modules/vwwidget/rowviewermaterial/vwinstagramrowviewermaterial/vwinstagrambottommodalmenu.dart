import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';

class VwInstagramBottomModalMenu extends StatefulWidget {
  VwInstagramBottomModalMenu(
      {
        required super.key,
        this.editArticleCardTapper,
        this.enableEdit = false,
      this.rowNode,

      });

  final InkWell? editArticleCardTapper;
  final bool enableEdit;
  final VwNode? rowNode;

  VwInstagramBottomModalMenuState createState() =>
      VwInstagramBottomModalMenuState();
}

class VwInstagramBottomModalMenuState
    extends State<VwInstagramBottomModalMenu> {
  @override
  Widget build(BuildContext context) {
    List<Widget> menuList = [];


    if (this.widget.editArticleCardTapper != null &&
        this.widget.enableEdit == true) {
      //menuList.add(InkWell( onTap: this.widget.editArticleCardTapper!.onTap, child:Row(children:[Icon(Icons.edit ),SizedBox(width: 5,), Text("Edit",style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w400  ),)])));

      Widget editButton = FloatingActionButton.extended(
          label:
              Text('Edit', style: TextStyle(color: Colors.black)), // <-- Text
          backgroundColor: Colors.white,
          icon: Icon(
            // <-- Icon
            Icons.edit,
            size: 24.0,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (this.widget.editArticleCardTapper!.onTap != null) {
              this.widget.editArticleCardTapper!.onTap!();
            }
          });

      menuList.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [editButton],
      ));

      menuList.add(SizedBox(width: 10,));
    }

    //shareButton
    Widget shareButton = widget.rowNode==null? Container():FloatingActionButton.extended(
        label: Text(
          'Share',
          style: TextStyle(color: Colors.black),
        ), // <-- Text
        backgroundColor: Colors.white,
        icon: Icon(


          // <-- Icon
          Icons.share,
          size: 24.0,
          color: Colors.black,
        ),
        onPressed: () async{
          String url=AppConfig.baseUrl+r"?articleId="+ widget.rowNode!.recordId;

          await Clipboard.setData(ClipboardData(
              text: url ));

          Fluttertoast.showToast(
              msg: "Share Link has been copied to Clipboard",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              webBgColor:
              "linear-gradient(to right, #FF6D0A, #FF6D0A)",
              webPosition: "center",
              fontSize: 16.0);
        });
    menuList.add(Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [shareButton],
    ));




    return CupertinoPageScaffold(
      key: widget.key,
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        //middle: Text(book.title),
      ),
      child: SafeArea(

        child:Container(
            height: 100,
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: menuList,
            ),
          ),
        )),
      ),
    );
  }
}
