import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfielddefinition/vwfielddefinition.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdefinition/vwrowdefinition.dart';
import 'package:uuid/uuid.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

/*
    '400', '4', 'Surat Permintaan Pembayaran (SPP)', '', '0', '1', '0', '1'
'401', '4', 'SPK/Surat Perjanjian Kerja (kontrak)', '', '1', '1', '0', '1'
'402', '4', 'SPMK (Surat Perintah Mulai Pekerjaan)', '', '2', '1', '0', '1'
'403', '4', 'Harga Perkiraan Sendiri (OE)', '', '3', '1', '0', '1'
'404', '4', 'Surat Penawaran', '', '4', '1', '0', '1'
'405', '4', 'Lampiran Surat Penawaran', '', '5', '1', '0', '1'
'406', '4', 'BA Klasifikasi dan Negosiasi Harga', '', '6', '1', '0', '1'
'407', '4', 'SPPBJ/Surat Penunjukkan Penyedia Barang/Jasa', '', '7', '1', '0', '1'
'408', '4', 'BA Evaluasi Dokumen Kualifikasi - SPT Tahunan', '', '8', '1', '0', '1'
'409', '4', 'BA Evaluasi Dokumen Kualifikasi - Pajak 3 Bulan Terakhir', '', '9', '1', '0', '1'
'410', '4', 'BA Evaluasi Dokumen Kualifikasi - NPWP', '', '10', '1', '0', '1'
'411', '4', 'BA Evaluasi Dokumen Kualifikasi - Jaminan/Garansi Bank', '', '11', '1', '0', '1'
'412', '4', 'BA Evaluasi Dokumen Kualifikasi - Dokumen Perusahaan', '', '12', '1', '0', '1'
'413', '4', 'BA Pemeriksaan Hasil Pekerjaan', '', '13', '1', '0', '1'
'414', '4', 'BAST/Berita Acara Serah Terima Pekerjaan', '', '14', '1', '0', '1'
'415', '4', 'Kwitansi', '', '15', '1', '0', '1'
'416', '4', 'Faktur Pajak/SSP', '', '16', '1', '0', '1'
'417', '4', 'Surat Pernyataan Tanggung Jawab Mutlak & Belanja ', '', '17', '1', '0', '1'
'418', '4', 'Kartu Pengawasan Kontrak (Karwas)', '', '18', '1', '0', '1'
'419', '4', 'Number Registrasi Supplier (NRS)', '', '19', '1', '0', '1'
'420', '4', 'CAN (PO)', '', '20', '1', '0', '1'
'421', '4', 'Bukti Tagihan Langganan Daya & Jasa - PLN', '', '21', '0', '0', '1'
'422', '4', 'Bukti Tagihan Langganan Daya & Jasa - Telkom', '', '22', '0', '0', '1'
'423', '4', 'Bukti Tagihan Langganan Daya & Jasa - PAM', '', '23', '0', '0', '1'
'499', '4', 'Bundel Dokumen - LS Pihak Ke-3 (Tiga)', '', '-1', '0', '1', '0'

     */
class RowDefinitionLib {



  static VwRowDefinition getFormPemeriksaanBerkasRowDefinition() {
    VwFieldDefinition field1 = VwFieldDefinition(fieldName: '400');
    VwFieldDefinition field2 = VwFieldDefinition(fieldName: '401');
    VwFieldDefinition field3 = VwFieldDefinition(fieldName: '402');
    VwFieldDefinition field4 = VwFieldDefinition(fieldName: '403');
    VwFieldDefinition field5 = VwFieldDefinition(fieldName: '404');
    VwFieldDefinition field6 = VwFieldDefinition(fieldName: '405');
    VwFieldDefinition field7 = VwFieldDefinition(fieldName: '406');
    VwFieldDefinition field8 = VwFieldDefinition(fieldName: '407');
    VwFieldDefinition field9 = VwFieldDefinition(fieldName: '408');
    VwFieldDefinition field10 = VwFieldDefinition(fieldName: '409');
    VwFieldDefinition field11= VwFieldDefinition(fieldName: '410');
    VwFieldDefinition field12 = VwFieldDefinition(fieldName: '411');
    VwFieldDefinition field13 = VwFieldDefinition(fieldName: '412');
    VwFieldDefinition field14 = VwFieldDefinition(fieldName: '413');
    VwFieldDefinition field15 = VwFieldDefinition(fieldName: '414');
    VwFieldDefinition field16 = VwFieldDefinition(fieldName: '415');
    VwFieldDefinition field17 = VwFieldDefinition(fieldName: '416');
    VwFieldDefinition field18 = VwFieldDefinition(fieldName: '417');
    VwFieldDefinition field19 = VwFieldDefinition(fieldName: '418');
    VwFieldDefinition field20 = VwFieldDefinition(fieldName: '419');
    VwFieldDefinition field21 = VwFieldDefinition(fieldName: '420');
    VwFieldDefinition field22 = VwFieldDefinition(fieldName: '421');
    VwFieldDefinition field23= VwFieldDefinition(fieldName: '422');
    VwFieldDefinition field24 = VwFieldDefinition(fieldName: '423');
    VwFieldDefinition field25 = VwFieldDefinition(fieldName: '499');
    VwFieldDefinition field26 = VwFieldDefinition(fieldName: 'catatan');

    VwRowDefinition returnValue = VwRowDefinition(
        fieldDefinitionList: <VwFieldDefinition>[field1,
          field2,
          field3,
          field4,
          field5,
          field6,
          field7,
          field8,
          field9,
          field10,
          field11,
          field12,
          field13,
          field14,
          field15,
          field16,
          field17,
          field18,
          field19,
          field20,
          field21,
          field22,
          field23,
          field24,
          field25,field26


        ]);

    return returnValue;
  }

  static VwRowDefinition getSearchSpmRowDefinition(){
    VwFieldDefinition field1 = VwFieldDefinition(fieldName: 'filterByUntuk');
    VwFieldDefinition field2 = VwFieldDefinition(fieldName: 'filterByThang');
    VwFieldDefinition field3 = VwFieldDefinition(fieldName: 'filterByKdsatker');
    VwFieldDefinition field4 = VwFieldDefinition(fieldName: 'filterByNmppk');
    VwFieldDefinition field5 = VwFieldDefinition(fieldName: 'filterByNipppk');
    VwFieldDefinition field6 = VwFieldDefinition(fieldName: 'filterByNoSpp');
    VwFieldDefinition field7 = VwFieldDefinition(fieldName: 'filterByNoSp2d');
    VwFieldDefinition field8 = VwFieldDefinition(fieldName: 'filterByKdakun');
    VwFieldDefinition field9 = VwFieldDefinition(fieldName: 'sortFieldName');
    VwFieldDefinition field10 = VwFieldDefinition(fieldName: 'isAscending');
    VwFieldDefinition field11 = VwFieldDefinition(fieldName: "spmWithAttachment");



    VwRowDefinition returnValue = VwRowDefinition(
        fieldDefinitionList: <VwFieldDefinition>[]);

    returnValue.fieldDefinitionList.add(field1);
    returnValue.fieldDefinitionList.add(field2);
    returnValue.fieldDefinitionList.add(field3);
    returnValue.fieldDefinitionList.add(field4);
    returnValue.fieldDefinitionList.add(field5);
    returnValue.fieldDefinitionList.add(field6);
    returnValue.fieldDefinitionList.add(field7);
    returnValue.fieldDefinitionList.add(field8);
    returnValue.fieldDefinitionList.add(field9);
    returnValue.fieldDefinitionList.add(field10);
    returnValue.fieldDefinitionList.add(field11);

    return returnValue;
  }

  static VwRowDefinition getLoginRequestRowDefinition() {
    VwFieldDefinition field1 = VwFieldDefinition(fieldName: 'username');
    VwFieldDefinition field2 = VwFieldDefinition(fieldName: 'password');

    VwRowDefinition returnValue = VwRowDefinition(
        fieldDefinitionList: <VwFieldDefinition>[field1, field2]);

    return returnValue;
  }

  static VwRowDefinition getFormChecklistSpmRowDefinition() {
    VwFieldDefinition field1 = VwFieldDefinition(fieldName: 'checklist1' );
    VwFieldDefinition field2 = VwFieldDefinition(fieldName: 'catatan1');

    VwRowDefinition returnValue = VwRowDefinition(
        fieldDefinitionList: <VwFieldDefinition>[field1, field2]);

    return returnValue;
  }

  static VwRowData convertRowDefinitionToRow({required VwRowDefinition rowDefinition,String? rowId}) {
    List<VwFieldValue> fieldValueList = [];
    for (int la = 0; la < rowDefinition.fieldDefinitionList.length; la++) {
      VwFieldDefinition currrentFieldDefinition =
          rowDefinition.fieldDefinitionList.elementAt(la);
      VwFieldValue currentFieldValue = VwFieldValue(
        fieldName: currrentFieldDefinition.fieldName,
        valueTypeId: currrentFieldDefinition.valueTypeId,
      );
      fieldValueList.add(currentFieldValue);
    }
    VwRowData returnValue = VwRowData(timestamp: VwDateUtil.nowTimestamp(),recordId:rowId==null? Uuid().v4():rowId, fields: fieldValueList);
    return returnValue;
  }
}
