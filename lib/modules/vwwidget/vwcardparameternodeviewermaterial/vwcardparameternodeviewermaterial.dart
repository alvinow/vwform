import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfieldfilestorage/vwfieldfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontentutil.dart';
import 'package:matrixclient2base/modules/base/vwuser/vwuser.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameterutil.dart';
import 'package:vwform/modules/vwcardparameter/vwjsonfieldnamecardparameter.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/rowviewermaterial/vwcardparametermaterial/vwcardparametermaterial.dart';
import 'package:vwutil/modules/util/displayformatutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwCardParameterNodeViewerMaterial extends StatelessWidget {
  VwCardParameterNodeViewerMaterial(
      {super.key,
      required this.appInstanceParam,
      required this.cardParameter,
      required this.rowNode,
      this.selectWidget,
      required this.cardTapper,
      this.trailingWidget,
      this.rowViewerBoxConstraint,
      this.commandToParentFunction,
      this.showCardMenu=true
      });
  final VwAppInstanceParam appInstanceParam;
  final VwCardParameter cardParameter;
  final VwNode rowNode;
  final Widget? selectWidget;
  final InkWell cardTapper;
  final Widget? trailingWidget;
  final BoxConstraints? rowViewerBoxConstraint;
  final CommandToParentFunction? commandToParentFunction;
  final bool showCardMenu;

  @override
  Widget build(BuildContext context) {
    bool isRowNodeContentNotNull = rowNode.content != null;
    bool isLinkBasemodelNotNull = rowNode.content.linkbasemodel != null &&
        (rowNode.content.linkbasemodel!.rendered != null ||
            rowNode.content.linkbasemodel!.cache != null);
    bool isLinkRowCollectionNotNull =
        rowNode.content.linkRowCollection != null &&
            (rowNode.content.linkRowCollection!.cache != null ||
                rowNode.content.linkRowCollection!.rendered != null ||
                rowNode.content.linkRowCollection!.sync != null);
    bool isClassEncodedJsonNotNull = rowNode.content.classEncodedJson != null;
    bool isRowDataNotNull = rowNode.content.rowData != null;

    try {
      //VwFormDefinition formParam = VwFormDefinition.fromJson(rowNode.content.linkbasemodel!.rendered!.data);

      String? titleText;
      String? descriptionText;
      String? subtitleText;
      DateTime? recordUpdatedDateTime =
          (NodeUtil.getBaseModelFromContent(rowNode) != null &&
                  NodeUtil.getBaseModelFromContent(rowNode)!.timestamp != null)
              ? NodeUtil.getBaseModelFromContent(rowNode)!.timestamp!.updated
              : null;
      String? recordUpdated = recordUpdatedDateTime == null
          ? null
          : VwDateUtil.indonesianShortFormatLocalTimeZone(
              recordUpdatedDateTime);

      if (cardParameter.fieldNameMode == VwCardParameter.fnmJson) {
        VwFieldValue? titleFieldValue =
            VwCardParameterUtil.renderJsonFieldNameByStringJsonFieldName(
              locale: this.appInstanceParam.locale,
                sourceNode: this.rowNode,
                jsonFieldName: cardParameter.titleFieldName);

        if (titleFieldValue != null) {
          VwJsonFieldNameCardParameter? jsonFieldNameCardParameter =
              VwCardParameterUtil.getJsonFieldNameCardParameterFromString(
                  cardParameter.titleFieldName);

          VwFieldDisplayFormat? fieldDisplayFormat =
              jsonFieldNameCardParameter?.fieldDisplayFormat;

          titleText = VwCardParameterUtil.getStringFormFieldValue(
              locale: this.appInstanceParam.locale,
              fieldValue: titleFieldValue,
              fieldDisplayFormat: fieldDisplayFormat);
        }

        if (cardParameter.subTitleFieldName != null) {
          VwFieldValue? subtitleFieldValue =
              VwCardParameterUtil.renderJsonFieldNameByStringJsonFieldName(
                  locale: this.appInstanceParam.locale,
                  sourceNode: this.rowNode,
                  jsonFieldName: cardParameter.subTitleFieldName!);

          if (subtitleFieldValue != null) {
            VwJsonFieldNameCardParameter? jsonFieldNameCardParameter =
                VwCardParameterUtil.getJsonFieldNameCardParameterFromString(
                    cardParameter.subTitleFieldName!);
            VwFieldDisplayFormat? fieldDisplayFormat =
                jsonFieldNameCardParameter?.fieldDisplayFormat;
            subtitleText = VwCardParameterUtil.getStringFormFieldValue(
                locale: this.appInstanceParam.locale,
                fieldValue: subtitleFieldValue,
                fieldDisplayFormat: fieldDisplayFormat);
          }
        }

        if (cardParameter.descriptionFieldName != null) {
          VwFieldValue? descriptionFieldValue =
              VwCardParameterUtil.renderJsonFieldNameByStringJsonFieldName(
                  locale: this.appInstanceParam.locale,
                  sourceNode: this.rowNode,
                  jsonFieldName: cardParameter.descriptionFieldName!);

          if (descriptionFieldValue != null) {
            VwJsonFieldNameCardParameter? jsonFieldNameCardParameter =
                VwCardParameterUtil.getJsonFieldNameCardParameterFromString(
                    cardParameter.descriptionFieldName!);
            VwFieldDisplayFormat? fieldDisplayFormat =
                jsonFieldNameCardParameter?.fieldDisplayFormat;
            descriptionText = VwCardParameterUtil.getStringFormFieldValue(
                locale: this.appInstanceParam.locale,
                fieldValue: descriptionFieldValue,
                fieldDisplayFormat: fieldDisplayFormat);
          }
        }

        if (cardParameter.dateFieldName != null) {
          VwFieldValue? dateFieldValue =
              VwCardParameterUtil.renderJsonFieldNameByStringJsonFieldName(
                  locale: this.appInstanceParam.locale,
                  sourceNode: this.rowNode,
                  jsonFieldName: cardParameter.dateFieldName!);

          if (dateFieldValue != null) {
            VwJsonFieldNameCardParameter? jsonFieldNameCardParameter =
                VwCardParameterUtil.getJsonFieldNameCardParameterFromString(
                    cardParameter.dateFieldName!);
            VwFieldDisplayFormat? fieldDisplayFormat =
                jsonFieldNameCardParameter?.fieldDisplayFormat;
            recordUpdated = VwCardParameterUtil.getStringFormFieldValue(
                locale: this.appInstanceParam.locale,
                fieldValue: dateFieldValue,
                fieldDisplayFormat: fieldDisplayFormat);
          }
        }
      } else {
        titleText = NodeUtil.getValueFromContentRecordCollection(
            locale: this.appInstanceParam.locale,
            node: rowNode,
            fieldName: cardParameter.titleFieldName,
            fieldDisplayFormat: cardParameter.titleDisplayFormat);

        if (cardParameter.titleFieldName != null &&
            cardParameter.titleSubFieldName != null) {
          titleText = NodeUtil
              .getValueStringFromContentRecordCollectionWithEnabledSubFieldName(
                  rowNode,
                  cardParameter.titleFieldName,
                  cardParameter.titleSubFieldName!);
        }

        descriptionText = NodeUtil.getValueFromContentRecordCollection(
            locale: this.appInstanceParam.locale,
            node: rowNode,
            fieldName: cardParameter.descriptionFieldName.toString(),
            fieldDisplayFormat: cardParameter.descriptionDisplayFormat);

        if (cardParameter.descriptionFieldName != null &&
            cardParameter.descriptionSubFieldName != null) {
          descriptionText = NodeUtil
              .getValueStringFromContentRecordCollectionWithEnabledSubFieldName(
                  rowNode,
                  cardParameter.descriptionFieldName.toString(),
                  cardParameter.descriptionSubFieldName.toString());
        }

        subtitleText = NodeUtil.getValueFromContentRecordCollection(
            locale: this.appInstanceParam.locale,
            node: rowNode,
            fieldName: cardParameter.subTitleFieldName.toString(),
            fieldDisplayFormat: cardParameter.subtitleDisplayFormat);
        if (cardParameter.subTitleFieldName != null &&
            cardParameter.subtitleSubFieldName != null) {
          subtitleText = NodeUtil
              .getValueStringFromContentRecordCollectionWithEnabledSubFieldName(
                  rowNode,
                  cardParameter.subTitleFieldName.toString(),
                  cardParameter.subtitleSubFieldName.toString());
        }

        if (cardParameter.dateFieldName != null) {
          recordUpdated = NodeUtil.getValueFromContentRecordCollection(
              locale: this.appInstanceParam.locale,
              node: rowNode,
              fieldName: cardParameter.dateFieldName.toString(),
              fieldDisplayFormat: cardParameter.dateDisplayFormat);
        }

        if (cardParameter.dateFieldName != null &&
            cardParameter.dateSubFieldName != null) {
          recordUpdated = NodeUtil
              .getValueStringFromContentRecordCollectionWithEnabledSubFieldName(
                  rowNode,
                  cardParameter.dateFieldName.toString(),
                  cardParameter.dateSubFieldName.toString());
        }
      }

      if (titleText == null) {
        titleText = this.rowNode.recordId;
        if(this.rowNode.nodeType==VwNode.ntnFileStorage)
        {
          titleText=this.rowNode.displayName;
          recordUpdated= this.rowNode.timestamp!=null? VwDateUtil.indonesianFormatLocalTimeZone( this.rowNode.timestamp!.updated):null;
        }
      }

      DateTime? eventDate;
      try {
        eventDate =
            rowNode.content.rowData!.getFieldByName("eventdate")!.valueDateTime;
      } catch (error) {}

      String? captionText = NodeUtil.getValueFromContentRecordCollection(
          locale: this.appInstanceParam.locale,
          node: rowNode, fieldName: cardParameter.captionFieldName.toString());

      String? urllink = NodeUtil.getValueFromContentRecordCollection(
          locale: this.appInstanceParam.locale,
          node: rowNode, fieldName: "urllink");

      VwFieldValue subtitleFieldValue = VwFieldValue(
          fieldName: "fieldName1",
          valueTypeId: VwFieldValue.vatString,
          valueString: subtitleText);
      VwFieldValue titleFieldValue = VwFieldValue(
          fieldName: "fieldName1",
          valueTypeId: VwFieldValue.vatString,
          valueString: titleText);
      VwFieldValue descriptionFieldValue = VwFieldValue(
          fieldName: "fieldName1",
          valueTypeId: VwFieldValue.vatString,
          valueString: descriptionText);

      if (cardParameter.titleDisplayFormat != null) {
        titleText = DisplayFormatUtil.renderDisplayFormat(

            cardParameter.titleDisplayFormat!, titleFieldValue,this.appInstanceParam.locale);
      }

      if (cardParameter.subtitleDisplayFormat != null) {
        subtitleText = DisplayFormatUtil.renderDisplayFormat(
            cardParameter.subtitleDisplayFormat!, subtitleFieldValue,this.appInstanceParam.locale);
      }

      if (cardParameter.descriptionDisplayFormat != null) {
        descriptionText = DisplayFormatUtil.renderDisplayFormat(
            cardParameter.descriptionDisplayFormat!, descriptionFieldValue,this.appInstanceParam.locale);
      }

      if (this.cardParameter.titlePrefix != null) {
        titleText =
            this.cardParameter.titlePrefix.toString() + titleText.toString();
      }

      if (this.cardParameter.subtitlePrefix != null) {
        subtitleText = this.cardParameter.subtitlePrefix.toString() +
            subtitleText.toString();
      }

      if (this.cardParameter.descriptionPrefix != null) {
        descriptionText = this.cardParameter.descriptionPrefix.toString() +
            descriptionText.toString();
      }

      if (this.cardParameter.titleSufix != null) {
        titleText =
            titleText.toString() + this.cardParameter.titleSufix.toString();
      }

      if (this.cardParameter.subtitleSufix != null) {
        subtitleText = subtitleText.toString() +
            this.cardParameter.subtitleSufix.toString();
      }

      if (this.cardParameter.descriptionSufix != null) {
        descriptionText = descriptionText.toString() +
            this.cardParameter.descriptionSufix.toString();
      }

      String? medialinktitle;
      try {
        medialinktitle = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.medialinktitle!)!
            .valueString;
      } catch (error) {}

      VwFieldFileStorage? imagetitle;
      try {
        imagetitle = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.imagetitle!)!
            .valueFieldFileStorage;
      } catch (error) {}

      VwFieldFileStorage? imagecontent;
      try {
        imagecontent = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.imagecontent!)!
            .valueFieldFileStorage;
      } catch (error) {}

      String? htmlcontent;
      try {
        htmlcontent = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.htmlcontent!)!
            .valueString;
      } catch (error) {}

      String? articletype;
      try {
        articletype = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.articletype!)!
            .valueString;
      } catch (error) {}

      VwRowData? location;
      try {
        location = NodeUtil.getRowDataFromNodeContentRecordCollection(
            NodeUtil.getNode(
                linkNode: this
                    .rowNode
                    .content
                    .rowData!
                    .getFieldByName(this.cardParameter.location!)!
                    .valueLinkNode!)!);
      } catch (error) {}

      String? maincategory;
      try {
        maincategory = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.maincategory!)!
            .valueString;
      } catch (error) {}

      String? releaseStatus;
      try {
        releaseStatus = this
            .rowNode
            .content
            .rowData!
            .getFieldByName(this.cardParameter.releaseStatus!)!
            .valueString;
      } catch (error) {}

      VwUser? user;

      try {
        user = NodeUtil.getUserClassFromLinkNodeClassEncodedJson(
            linkNode: this.rowNode!.content!.rowData!.creatorUserLinkNode!);
      } catch (error) {}

      String? username;

      try {
        username = user!.displayname;
      } catch (error) {}



      if(this.rowNode.content.classEncodedJson!=null && this.rowNode.content.classEncodedJson!.collectionName=="vwnodeusergroupaccess" )
        {
          try
              {
                if(this.rowNode.content.classEncodedJson!.isCompressed==true)
                  {
                    RemoteApi.decompressClassEncodedJson(this.rowNode.content.classEncodedJson!);
                  }

               VwLinkNode targetGroupUserLinkNode=VwLinkNode.fromJson(this.rowNode.content.classEncodedJson!.data!["targetUserGroup"]);

               VwNode? targetGroupUserNode= NodeUtil.extractNodeFromLinkNode(targetGroupUserLinkNode);

               titleText=targetGroupUserNode!.content.classEncodedJson!.data!["displayname"]+" ("+targetGroupUserNode!.content.classEncodedJson!.data!["username"]+")";

              }
              catch(error)
    {

    }
        }


      String creatorUserName=this.rowNode.creatorUserId.toString();

      if(this.rowNode.creatorUserLinkNode!=null) {


          VwUser? creatorUser= NodeUtil.getUserClassFromLinkNodeClassEncodedJson(linkNode: this.rowNode.creatorUserLinkNode!);

          if(creatorUser!=null)
            {
              creatorUserName=creatorUser!.username;
            }
      }

      return Container(
          key: key,
          child: VwCardParameterMaterial(

            lastUpdateDateTime:this.rowNode.timestamp!=null? VwDateUtil.indonesianFormatLocalTimeZone(this.rowNode.timestamp!.updated):null,
            lastUpdater: creatorUserName,
            eventDate: eventDate,
            rowViewerBoxConstraint: this.rowViewerBoxConstraint,
            key: Key(this.rowNode.recordId),
            recordNode: this.rowNode,
            timestamp: this.rowNode.timestamp,
            appInstanceParam: this.appInstanceParam,
            cardTapper: this.cardTapper,
            selectWidget: this.selectWidget,
            trailingWidget: this.trailingWidget,
            cardParameter: cardParameter,
            urllink: urllink,
            title: titleText,
            subTitle: subtitleText,
            caption: captionText,
            description: descriptionText,
            username: username.toString(),
            dateTime: recordUpdated,
            medialinktitle: medialinktitle,
            imagetitle: imagetitle,
            imagecontent: imagecontent,
            htmlcontent: htmlcontent,
            articletype: articletype,
            location: location,
            maincategory: maincategory,
            releaseStatus: releaseStatus,

            commandToParentFunction: this.commandToParentFunction,
          ));
    } catch (error) {}
    return Container(key: super.key, child: Text(this.rowNode.recordId));
  }
}
