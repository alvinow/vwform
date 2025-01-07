import 'package:matrixclient/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient/modules/vwcardparameter/vwcardparameter.dart';
import 'package:matrixclient/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwrowcollectiondatasource/vwrowcollectiondatasource.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwstyleformparam/vwstyleformparam.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient2base/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:vwform/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwstyleformparam/vwstyleformparam.dart';
part 'vwformdefinition.g.dart';

@JsonSerializable()
class VwFormDefinition extends VwBaseModel {
  VwFormDefinition(
      {required super.recordId,
      required super.timestamp,
      super.indexKey,
      super.attachments,
      super.ref,
      super.collectionName,
      required this.formName,
        this.isCommentEnabled=false,
        this.isShowSubmitCommentButton=false,
      this.formDescription,
      this.styleFormParam = const VwStyleFormParam(),
      required this.sections,
      this.dataSource = VwDataSourceDefinition.smServer,
      this.rowCollectionDataSource,
      this.formResponseSyncCrudMode = VwBaseModel.cmCreateOrUpdate,
      required this.formResponseSyncCollectionName,
      this.initialFormResponse,
      this.cardParameter = const VwCardParamete(),
      this.isReadOnly = true,
      this.enableDeleteRecord=false,
        this.loadDetailFromServer=false,
        this.localeId="id_ID",
        this.isAllowChildFolder=false,
        this.isAllowChildNodeContentRowData=false,
        this.isSpecificChildNodeContentRowData=false,
        this.childNodeContentRowDataCollectionNameList=const[],
        this.childNodeFormDefinitionList=const[]
      });



  String formName;
  bool? isCommentEnabled;
  bool isShowSubmitCommentButton;
  String? formDescription;
  final VwStyleFormParam styleFormParam;
  final List<VwSectionFormDefinition> sections;
  String dataSource;
  bool isReadOnly;
  VwRowCollectionDataSource? rowCollectionDataSource;
  String formResponseSyncCrudMode;
  String formResponseSyncCollectionName;
  final VwRowData? initialFormResponse;
  final VwCardParameter cardParameter;
  bool enableDeleteRecord;
  bool loadDetailFromServer;
  String localeId;
  final bool isAllowChildFolder;
  final bool isAllowChildNodeContentRowData;
  final bool isSpecificChildNodeContentRowData;
  final List<String> childNodeContentRowDataCollectionNameList;
  final List<VwNode> childNodeFormDefinitionList;

  factory VwFormDefinition.fromJson(Map<String, dynamic> json) =>
      _$VwFormDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$VwFormDefinitionToJson(this);
}
