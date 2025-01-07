import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponse/vwformfieldvalidationresponse.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';

class VwFormValidationResponseUtil{
  static VwFormFieldValidationResponse? getFormFieldValidationResponseByFieldName({required VwFormValidationResponse formValidationResponse,  required String fieldName}){

    if(formValidationResponse.formFieldValidationResponses!=null) {
      for (int la = 0; la <
          formValidationResponse.formFieldValidationResponses!.length; la++) {
        VwFormFieldValidationResponse formFieldValidationResponse = formValidationResponse
            .formFieldValidationResponses!.elementAt(la);

        if (formFieldValidationResponse.fieldValue.fieldName == fieldName) {
          return formFieldValidationResponse;
        }
      }
    }
    return null;
  }
}