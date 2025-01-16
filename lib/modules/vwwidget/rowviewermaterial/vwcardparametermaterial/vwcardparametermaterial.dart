import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfieldfilestorage/vwfieldfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/rowviewermaterial/vwinstagramrowviewermaterial/vwinstagramrowviewermaterial.dart';
import 'package:vwform/modules/vwwidget/rowviewermaterial/vwquestionarticlerowviewermaterial/vwquestionarticlerowviewermaterial.dart';
import 'package:vwutil/modules/util/colurutil.dart';

typedef OnTapRowCardFunction = void Function();

class VwCardParameterMaterial extends StatelessWidget {
  VwCardParameterMaterial({
    required super.key,
    required this.appInstanceParam,
    required this.cardParameter,
    this.title,
    this.subTitle,
    this.description,
    this.dateTime,
    this.selectWidget,
    required this.cardTapper,
    this.trailingWidget,
    this.username,
    this.timestamp,
    this.medialinktitle,
    this.imagetitle,
    this.imagecontent,
    this.htmlcontent,
    this.articletype,
    this.maincategory,
    this.releaseStatus,
    this.showAccountInfo = true,
    this.location,
    this.caption,
    this.urllink,
    this.recordNode,
    this.rowViewerBoxConstraint,
    this.eventDate,
    this.commandToParentFunction,
    this.lastUpdater,
    this.lastUpdateDateTime,
  });

  final VwAppInstanceParam appInstanceParam;
  final VwCardParameter cardParameter;
  final String? title;
  final String? subTitle;
  final String? caption;
  final String? description;
  final String? dateTime;
  final Widget? selectWidget;
  final InkWell cardTapper;
  final Widget? trailingWidget;
  final String? username;
  final VwDataFormatTimestamp? timestamp;

  final String? medialinktitle;
  final VwFieldFileStorage? imagetitle;
  final VwFieldFileStorage? imagecontent;
  final String? htmlcontent;
  final String? articletype;
  final String? maincategory;
  final String? releaseStatus;
  final bool showAccountInfo;
  final VwRowData? location;
  final String? urllink;
  final VwNode? recordNode;
  final BoxConstraints? rowViewerBoxConstraint;
  final DateTime? eventDate;
  final CommandToParentFunction? commandToParentFunction;
  final String? lastUpdater;
  final String? lastUpdateDateTime;

  static const String csmNone = "csmNone";
  static const String csmSingleSelect = "csmSingleSelect";
  static const String csmMultiSelect = "csmMultiSelect";

  bool getIsInitialArticle() {
    bool returnValue = true;
    try {
      if (this
              .recordNode!
              .content
              .rowData!
              .getFieldByName("parentarticlenodeid")!
              .valueString !=
          "response_questionarticleformdefinition") {
        returnValue = false;
      }
    } catch (error) {}
    return returnValue;
  }

  static Widget applyTitleFieldDisplayFormat({required String locale, required String caption,required   VwFieldDisplayFormat? fieldDisplayFormat}){
    Widget returnValue=Container();
    try
    {
      if(caption!="") {
        VwFieldDisplayFormat currentDisplayFormat = fieldDisplayFormat != null
            ? fieldDisplayFormat
            : VwFieldDisplayFormat(locale: locale);

        String prefixCaption=currentDisplayFormat.prefixCaption==null?"":currentDisplayFormat.prefixCaption!;
        String sufixCaption=currentDisplayFormat.sufixCaption==null?"":currentDisplayFormat.sufixCaption!;




        returnValue = Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            color: ColorUtil.parseColor(
                currentDisplayFormat.backgroundColorHex),
            child: Text(

              prefixCaption+caption+sufixCaption,
              overflow: TextOverflow.ellipsis,
              maxLines: 10,
              textAlign: VwFieldDisplayFormat.getTextAlignFromString(
                  currentDisplayFormat.textAlign),
              style: TextStyle(
                fontWeight: VwFieldDisplayFormat.getFontWeightFromString(currentDisplayFormat.fontWeight),
                  fontStyle: VwFieldDisplayFormat.getFontStyleFromString(
                      currentDisplayFormat.fontStyle),
                  fontSize: currentDisplayFormat.fontSize,
                  color: ColorUtil.parseColor(
                      currentDisplayFormat.textColorHex)),
            ));
      }



    }
    catch(error)
    {

    }
    return returnValue;
  }

  

  static Widget createCardTile({

  Widget? leadingWidget,
  Widget? titleWidget ,
  Widget? subtitleWidget,
    Widget? descriptionWidget,
  Widget? timeUpdatedWidget,
  Widget? updaterInfoWidget,
  Widget? trailingWidget
  })
  {
    Widget returnValue=Container();

    try
    {
      final Widget renderLeadingWidget=leadingWidget==null?Container():leadingWidget;
      final Widget renderCenterWidget=Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
        titleWidget==null?Container():titleWidget,
        subtitleWidget==null? Container():subtitleWidget,
        descriptionWidget==null? Container():descriptionWidget,
        timeUpdatedWidget==null? Container():timeUpdatedWidget,
          updaterInfoWidget==null?Container():updaterInfoWidget
      ],);





      returnValue=Container(margin: EdgeInsets.fromLTRB(0, 8, 0, 8), child:Row(   mainAxisSize: MainAxisSize.min,children: [renderLeadingWidget,Flexible(child: renderCenterWidget),trailingWidget==null?Container():trailingWidget!],));
    }
    catch(error)
    {

    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = title != null && title!.length > 0
        ? Text(title.toString())
        : Container();
    try {
      String iconDefaultColor = cardParameter.iconHexColor; // "ffe28743";

      Color iconColor =
          Color(int.parse(iconDefaultColor.toString(), radix: 16));

      Widget? iconWidget = Icon(
        IconData(
            int.parse(
              cardParameter.iconHexCode,
            ),
            fontFamily: cardParameter.iconFontFamily),
        color: iconColor,
        size: 24,
      );

      String lTitleText = title.toString().trim();



      Widget titleWidget =VwCardParameterMaterial.applyTitleFieldDisplayFormat(locale: this.appInstanceParam.baseAppConfig.generalConfig.locale, caption: lTitleText, fieldDisplayFormat: this.cardParameter.titleDisplayFormat);

      bool hideSubtitle = cardParameter.isShowSubtitle == false  ||
          (
              (this.subTitle==null || this.subTitle=="")
              &&
              cardParameter.subtitleDisplayFormat != null &&
              cardParameter.subtitleDisplayFormat!.hideOnNull == true);




      Widget subtitleWidget  = hideSubtitle==false? VwCardParameterMaterial.applyTitleFieldDisplayFormat(locale:this.appInstanceParam.baseAppConfig.generalConfig.locale, caption: this.subTitle.toString().trim(), fieldDisplayFormat: this.cardParameter.subtitleDisplayFormat):Container();



      Widget timeUpdatedWidget = cardParameter.isShowDate==false? Container():VwCardParameterMaterial.applyTitleFieldDisplayFormat(locale:this.appInstanceParam.baseAppConfig.generalConfig.locale,caption: this.dateTime.toString(), fieldDisplayFormat: this.cardParameter.dateDisplayFormat );






      bool hideDescription = (cardParameter.cardStyle ==
                      VwCardParameter.csOneColumnWithDescription ||
                  cardParameter.cardStyle ==
                      VwCardParameter.csTwoColumnWithDescription) ==
              false ||
          (this.description == null &&
              cardParameter.descriptionDisplayFormat != null &&
              cardParameter.descriptionDisplayFormat!.hideOnNull == true);


      Widget descriptionWidget  = hideDescription==false? VwCardParameterMaterial.applyTitleFieldDisplayFormat (locale:this.appInstanceParam.baseAppConfig.generalConfig.locale, caption: this.description.toString().trim(), fieldDisplayFormat: this.cardParameter.descriptionDisplayFormat):Container();

      //Widget descriptionWidget  = Container();

      Widget updaterInfoWidget=Container();

      if(this.cardParameter.isShowUpdaterInfo)
      {
        updaterInfoWidget=Container(child:Text("Update : "+this.lastUpdateDateTime.toString() +", "+ this.lastUpdater.toString(),overflow: TextOverflow.ellipsis, textAlign:TextAlign.end, style: TextStyle(color:Colors.orangeAccent,  fontSize: 11),));

      }




      //Widget bottomWidget =Container();



      Widget? leadingWidget;



      if (cardParameter.cardStyle == VwCardParameter.csOneColumn ||
          cardParameter.cardStyle ==
              VwCardParameter.csOneColumnWithDescription) {
        iconWidget = null;
      }

      if (selectWidget != null) {
        if (iconWidget != null) {
          leadingWidget = Container(
              height: 100,
              width: 70,
              child: Row(children: [this.selectWidget!, iconWidget!]));
        } else {
          leadingWidget = Container(
              height: 100,
              width: 70,
              child: Row(children: [
                this.selectWidget!,
              ]));
        }
      } else if (iconWidget != null) {
        leadingWidget = Container(
             width: 25, child: Row(children: [iconWidget]));
      } else {
        leadingWidget = null;
      }
      //bottomWidget=InkWell(onTap: this.cardTapper.onTap, child: bottomWidget,);

      if( cardParameter.cardStyle ==VwCardParameter.csTwoColumnWithDescription ||
      cardParameter.cardStyle == VwCardParameter.csTwoColumn ||
      cardParameter.cardStyle == VwCardParameter.csOneColumn ||
      cardParameter.cardStyle == VwCardParameter.csOneColumnWithDescription

      )
        {
          cardWidget =  VwCardParameterMaterial.createCardTile(
            leadingWidget: leadingWidget,
            titleWidget: titleWidget,
            subtitleWidget: subtitleWidget,
            descriptionWidget: descriptionWidget,
            timeUpdatedWidget: timeUpdatedWidget,
            updaterInfoWidget: updaterInfoWidget,
            trailingWidget:  this.trailingWidget != null ? this.trailingWidget! : Container()
          );
        }
       else if (cardParameter.cardStyle == VwCardParameter.csQuestion &&
          this.recordNode != null) {
        return VwQuestionArticleRowViewerMaterial(
          rowNode: this.recordNode!,
          isInitiatorQuestion: this.getIsInitialArticle(),
          key: super.key,
          urllink: this.urllink,
          timestamp: this.timestamp,
          cardTapper: cardTapper,
          appInstanceParam: this.appInstanceParam,
          username: this.username.toString(),
          caption: this.caption,
          title: this.title,
          subTitle: this.subTitle,
          medialinktitle: medialinktitle,
          imagetitle: imagetitle,
          imagecontent: imagecontent,
          htmlcontent: htmlcontent,
          articletype: articletype!,
          location: location,
          maincategory: maincategory.toString(),
          releaseStatus: releaseStatus!,
          showAccountInfo: this.showAccountInfo,
          commandToParentFunction: this.commandToParentFunction,
        );
      } else if (cardParameter.cardStyle == VwCardParameter.csInstagram) {
        return VwInstagramRowViewerMaterial(
          eventDate: this.eventDate,
          boxConstraints: this.rowViewerBoxConstraint,
          rowNode: this.recordNode,
          key: super.key,
          urllink: this.urllink,
          timestamp: this.timestamp,
          cardTapper: cardTapper,
          appInstanceParam: this.appInstanceParam,
          username: this.username.toString(),
          caption: this.caption,
          title: this.title,
          subTitle: this.subTitle,
          medialinktitle: medialinktitle,
          imagetitle: imagetitle,
          imagecontent: imagecontent,
          htmlcontent: htmlcontent,
          articletype: articletype!,
          location: location,
          maincategory: maincategory.toString(),
          releaseStatus: releaseStatus!,
          showAccountInfo: this.showAccountInfo,
          commandToParentFunction: this.commandToParentFunction,
        );
      }
    } catch (error) {
      print("Error Catched on VwCardParameterMaterial.build: " +
          error.toString());
    }

    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
      key: super.key,
      child: InkWell(onTap: this.cardTapper.onTap, child: cardWidget),
    );

    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
        key: super.key,
        child: Row(children: [
          Flexible(
              child: Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 7), color: Colors.lightBlueAccent, child:InkWell(onTap: this.cardTapper.onTap, child: cardWidget))),
          this.trailingWidget != null ? this.trailingWidget! : Container()
        ]));
  }
}
