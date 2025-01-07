// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vwformdefinition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VwFormDefinition _$VwFormDefinitionFromJson(Map<String, dynamic> json) =>
    VwFormDefinition(
      recordId: json['recordId'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : VwDataFormatTimestamp.fromJson(
              json['timestamp'] as Map<String, dynamic>),
      indexKey: json['indexKey'] as Map<String, dynamic>?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => VwNodeContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      ref: json['ref'] == null
          ? null
          : VwLinkNode.fromJson(json['ref'] as Map<String, dynamic>),
      collectionName: json['collectionName'] as String?,
      formName: json['formName'] as String,
      isCommentEnabled: json['isCommentEnabled'] as bool? ?? false,
      isShowSubmitCommentButton:
          json['isShowSubmitCommentButton'] as bool? ?? false,
      formDescription: json['formDescription'] as String?,
      styleFormParam: json['styleFormParam'] == null
          ? const VwStyleFormParam()
          : VwStyleFormParam.fromJson(
              json['styleFormParam'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>)
          .map((e) =>
              VwSectionFormDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataSource:
          json['dataSource'] as String? ?? VwDataSourceDefinition.smServer,
      rowCollectionDataSource: json['rowCollectionDataSource'] == null
          ? null
          : VwRowCollectionDataSource.fromJson(
              json['rowCollectionDataSource'] as Map<String, dynamic>),
      formResponseSyncCrudMode: json['formResponseSyncCrudMode'] as String? ??
          VwBaseModel.cmCreateOrUpdate,
      formResponseSyncCollectionName:
          json['formResponseSyncCollectionName'] as String,
      initialFormResponse: json['initialFormResponse'] == null
          ? null
          : VwRowData.fromJson(
              json['initialFormResponse'] as Map<String, dynamic>),
      cardParameter: json['cardParameter'] == null
          ? const VwCardParameter()
          : VwCardParameter.fromJson(
              json['cardParameter'] as Map<String, dynamic>),
      isReadOnly: json['isReadOnly'] as bool? ?? true,
      enableDeleteRecord: json['enableDeleteRecord'] as bool? ?? false,
      loadDetailFromServer: json['loadDetailFromServer'] as bool? ?? false,
      localeId: json['localeId'] as String? ?? "id_ID",
      isAllowChildFolder: json['isAllowChildFolder'] as bool? ?? false,
      isAllowChildNodeContentRowData:
          json['isAllowChildNodeContentRowData'] as bool? ?? false,
      isSpecificChildNodeContentRowData:
          json['isSpecificChildNodeContentRowData'] as bool? ?? false,
      childNodeContentRowDataCollectionNameList:
          (json['childNodeContentRowDataCollectionNameList'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      childNodeFormDefinitionList:
          (json['childNodeFormDefinitionList'] as List<dynamic>?)
                  ?.map((e) => VwNode.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
    )
      ..crudMode = json['crudMode'] as String?
      ..rowDataFormat = json['rowDataFormat'] == null
          ? null
          : VwRowData.fromJson(json['rowDataFormat'] as Map<String, dynamic>)
      ..creatorUserId = json['creatorUserId'] as String?
      ..ownerUserId = json['ownerUserId'] as String?
      ..creatorUserLinkNode = json['creatorUserLinkNode'] == null
          ? null
          : VwLinkNode.fromJson(
              json['creatorUserLinkNode'] as Map<String, dynamic>);

Map<String, dynamic> _$VwFormDefinitionToJson(VwFormDefinition instance) =>
    <String, dynamic>{
      'recordId': instance.recordId,
      'timestamp': instance.timestamp,
      'indexKey': instance.indexKey,
      'ref': instance.ref,
      'attachments': instance.attachments,
      'collectionName': instance.collectionName,
      'crudMode': instance.crudMode,
      'rowDataFormat': instance.rowDataFormat,
      'creatorUserId': instance.creatorUserId,
      'ownerUserId': instance.ownerUserId,
      'creatorUserLinkNode': instance.creatorUserLinkNode,
      'formName': instance.formName,
      'isCommentEnabled': instance.isCommentEnabled,
      'isShowSubmitCommentButton': instance.isShowSubmitCommentButton,
      'formDescription': instance.formDescription,
      'styleFormParam': instance.styleFormParam,
      'sections': instance.sections,
      'dataSource': instance.dataSource,
      'isReadOnly': instance.isReadOnly,
      'rowCollectionDataSource': instance.rowCollectionDataSource,
      'formResponseSyncCrudMode': instance.formResponseSyncCrudMode,
      'formResponseSyncCollectionName': instance.formResponseSyncCollectionName,
      'initialFormResponse': instance.initialFormResponse,
      'cardParameter': instance.cardParameter,
      'enableDeleteRecord': instance.enableDeleteRecord,
      'loadDetailFromServer': instance.loadDetailFromServer,
      'localeId': instance.localeId,
      'isAllowChildFolder': instance.isAllowChildFolder,
      'isAllowChildNodeContentRowData': instance.isAllowChildNodeContentRowData,
      'isSpecificChildNodeContentRowData':
          instance.isSpecificChildNodeContentRowData,
      'childNodeContentRowDataCollectionNameList':
          instance.childNodeContentRowDataCollectionNameList,
      'childNodeFormDefinitionList': instance.childNodeFormDefinitionList,
    };
