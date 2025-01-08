import 'package:matrixclient2base/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';

class VwOperatorTicketPageDefinition {
  VwOperatorTicketPageDefinition(
      {this.ticketDefinitionCollectionName =
          VwOperatorTicketPageDefinition.vwTicketDefinition,
      this.ticketEventDefinitionCollectionName =
          VwOperatorTicketPageDefinition.vwTicketEventDefinition,
      this.ticketEventResponseCollectionName =
          VwOperatorTicketPageDefinition.vwTicketEventResponse,
      this.ticketEventReponseCollectionName =
          VwOperatorTicketPageDefinition.vwTicketEventResponse,
      this.ticketStateDefinitionCollectionName =
          VwOperatorTicketPageDefinition.vwTicketStateDefinition,
      this.ticketStateStepCollectionName =
          VwOperatorTicketPageDefinition.vwTicketStateStep,
      required this.possibleInitiatorRowCardParameter,
      required this.possibleResponderRowCardParameter});
  final String ticketDefinitionCollectionName;
  final String ticketEventDefinitionCollectionName;
  final String ticketEventResponseCollectionName;
  final String ticketEventReponseCollectionName;
  final String ticketStateDefinitionCollectionName;
  final String ticketStateStepCollectionName;
  final VwCardParameter possibleInitiatorRowCardParameter;
  final VwCardParameter possibleResponderRowCardParameter;

  static const String vwTicket = "vwticket";
  static const String vwTicketDefinition = "vwticketdefinition";
  static const String vwTicketStateStep = "vwticketstatestep";
  static const String vwTicketStateDefinition = "vwticketstatedefinition";
  static const String vwTicketEventDefinition = "vwticketeventdefinition";
  static const String vwTicketEventResponse = "vwticketeventresponse";
  static const String tagTicketEventResponseFormDefinition =
      "tagTicketEventResponseFormDefinition";

  static const String getPossibleTicketInitiatorNodeId =
      "2d91805f-5318-44bf-a7bf-1f50c8e84475";
  static const String getPossibleResponderEventResponseTicketNodeId =
      "473ed861-fdc2-4d69-bf55-9c56a43503ff";
  static const String respondByTicketIdEventDefinitionNodeId =
      "19ed2425-bc8a-4a29-9330-13526289aca6";

  static const String tagInitTicketFormDefinition = "initTicketFormDefinition";
  static const String tagInitTicketFormResponse = "initTicketFormResponse";
  static const String tagTicketEventDefinition = "tagTicketEventDefinition";
  static const String tagLatestFormResponseStateOnTicket =
      "tagLatestFormResponseStateOnTicket";
}
