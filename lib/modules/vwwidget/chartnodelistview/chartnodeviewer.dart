import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';

class ChartNodeViewer extends NodeRowViewer{

  ChartNodeViewer({
    required super.appInstanceParam,
    super.key,
    required super.rowNode,
    required super.highlightedText,
    super.topRowWidget,
    super.refreshDataOnParentFunction,
    super.collectionListViewDefinition,
    super.updateSelectedState,
    super.selectedList,
    super.selectedIcon,
    super.unselectedIcon
});







  List<ChartData> createChartDataSumTotNilMask({required List<VwRowData> totnilmaskRowDataList}){
    List<ChartData> returnValue=[];
    try {
    for(int la=0;la<totnilmaskRowDataList.length;la++)
      {
       VwRowData currentRowData= totnilmaskRowDataList.elementAt(la);

       ChartData currentChartData=ChartData(xCaption: currentRowData.getFieldByName("name")!.valueString!, y:  currentRowData.getFieldByName("sumValue")!.valueNumber!);
      returnValue.add(currentChartData);
      }
    }
    catch(error)
    {

    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {

    if(rowNode.content.rowData!=null &&  rowNode.content.rowData!.collectionName!=null && rowNode.content.rowData!.collectionName=="statisticticketdefinitionbyid")
    {
      Widget returnValue=Container(child: Text(this.rowNode.recordId),);
      try {
        final List<ChartData> chartDataSpp = [
          ChartData(xCaption: 'PPK Sudah Melengkapi Berkas', y:this.rowNode.content.rowData!.getFieldByName("ppkSudahMelengkapiBerkasSppRecordCount")!.valueNumber!,color: Colors.redAccent),
          ChartData(xCaption: 'PPSPM Sudah Mengapprove Berkas', y:this.rowNode.content.rowData!.getFieldByName("ppspmSudahMengapproveBerkasSppRecordCount")!.valueNumber!,color:Colors.yellowAccent,),
          ChartData(xCaption: 'Berkas SPP Belum Lengkap', y:this.rowNode.content.rowData!.getFieldByName("berkasSppBelumLengkapRecordCount")!.valueNumber!,color:Colors.greenAccent),
          ChartData(xCaption: 'SPI Sudah Menggapprove Berkas', y:this.rowNode.content.rowData!.getFieldByName("spiSudahMenggapproveBerkasSppRecordCount")!.valueNumber!,color:Colors.blue)
        ];

        final List<ChartData> chartDataSpby = [
          ChartData(xCaption: 'PPK Sudah Melengkapi Berkas', y:this.rowNode.content.rowData!.getFieldByName("ppkSudahMelengkapiBerkasSpbyRecordCount")!.valueNumber!,color: Colors.redAccent),
          ChartData(xCaption: 'BPP Sudah Mengapprove Berkas', y:this.rowNode.content.rowData!.getFieldByName("bppSudahMengapproveBerkasSpbyRecordCount")!.valueNumber!,color:Colors.yellowAccent),
          ChartData(xCaption: 'Berkas SPP Belum Lengkap', y:this.rowNode.content.rowData!.getFieldByName("berkasSpbyBelumLengkapRecordCount")!.valueNumber!,color:Colors.greenAccent),
          ChartData(xCaption: 'SPI Sudah Menggapprove Berkas', y:this.rowNode.content.rowData!.getFieldByName("spiSudahMenggapproveBerkasSpbyRecordCount")!.valueNumber!,color:Colors.blue)
        ];


        Widget chartBerkasSpp= SfCircularChart(
          title: ChartTitle(text:"Berkas SPP ("+this.rowNode.content.rowData!.getFieldByName("sppRecordCount")!.valueNumber!.toString()+")"),
            legend: Legend(isVisible: true,position: LegendPosition.auto),
            series: <CircularSeries>[

              // Render pie chart
              PieSeries<ChartData, String>(
                  dataSource: chartDataSpp,
                  pointColorMapper:(ChartData data,  _) => data.color,
                  xValueMapper: (ChartData data, _) => data.xCaption+"("+data.y.toString()+")",
                  yValueMapper: (ChartData data, _) => data.y
              )
            ]
        );

        Widget chartBerkasSpby= SfCircularChart(
            title: ChartTitle(text:"Berkas SPBy ("+this.rowNode.content.rowData!.getFieldByName("spbyRecordCount")!.valueNumber!.toString()+")"),
            legend: Legend(isVisible: true,position: LegendPosition.auto),
            series: <CircularSeries>[

              // Render pie chart
              PieSeries<ChartData, String>(
                  dataSource: chartDataSpby,
                  pointColorMapper:(ChartData data,  _) => data.color,
                  xValueMapper: (ChartData data, _) => data.xCaption+"("+data.y.toString()+")",
                  yValueMapper: (ChartData data, _) => data.y
              )
            ]
        );

        List<ChartData> chartData=[];

        try
        {
          chartData= this.createChartDataSumTotNilMask(totnilmaskRowDataList: rowNode.content.rowData!.getFieldByName("sumtotnilmask")!.valueRowDataList!);

        }
        catch(error)
    {

    }

        Widget chartSumtotnilmask=  SfCartesianChart (
            ////isTransposed: true,
            //legend: Legend(isVisible: true,position: LegendPosition.auto),
        title: ChartTitle(
          text: "Jumlah Nilai Realisasi Berkas Yang Sudah Dilengkapi",

        ),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compactSimpleCurrency(locale: AppConfig.locale)
        ),
        primaryXAxis: CategoryAxis(
labelPlacement: LabelPlacement.betweenTicks,
          maximumLabelWidth: 200,
        ),
        series: <CartesianSeries<ChartData, String>>[
          // Renders column chart
          BarSeries<ChartData, String>(
              dataSource: chartData ,
              //xAxisName: "Regional",
              xValueMapper: (ChartData data, _) => data.xCaption,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelSettings:DataLabelSettings(isVisible : true)
          )
        ]
        );


        return Column(children: [chartBerkasSpp,chartBerkasSpby,chartSumtotnilmask]);

        //ticketCountByStateByTicketDefinition
        //#1  sppRecordCount [e5615ef3-d572-4cb7-9623-1112d470ce28","11c5a47e-5007-4ee2-b576-72d03419fdb5","19558c87-7c5e-4cfa-a4ea-626aca1f288e","19558c87-7c5e-4cfa-a4ea-626aca1f288e"]
        //#1a ppkSudahMelengkapiBerkasSpp      "e5615ef3-d572-4cb7-9623-1112d470ce28"
        //#1b ppspmSudahMengapproveBerkasSpp  "11c5a47e-5007-4ee2-b576-72d03419fdb5"
        //#1c berkasSppBelumLengkap   "19558c87-7c5e-4cfa-a4ea-626aca1f288e"
        //#1d spiSudahMenggapproveBerkasSpp   "1e292daf-adb3-4531-b820-331468d4c84d"

        //#1  spbyRecordCount []
        //#1a ppkSudahMelengkapiBerkasSpby  "c9ae8304-0a0a-48d1-bbdc-16c3e085cddc"
        //#1b bppSudahMengapproveBerkasSpby  "016366d1-7a16-4f75-87bf-badc7c81fe00"
        //#1c berkasSpbyBelumLengkap "63618253-f8f1-41ef-ab33-2063aa7722cb"
        //#1d spiSudahMenggapproveBerkasSpby  "b65c4b85-c834-4e8c-aaf4-4f3100bc70f7"

        returnValue=Column(
          children: [
            Text("SPP",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("sppRecordCount: "+this.rowNode.content.rowData!.getFieldByName("sppRecordCount")!.valueNumber.toString()),
            Text("ppkSudahMelengkapiBerkasSpp: "+this.rowNode.content.rowData!.getFieldByName("ppkSudahMelengkapiBerkasSppRecordCount")!.valueNumber.toString()),
            Text("ppspmSudahMengapproveBerkasSpp: "+this.rowNode.content.rowData!.getFieldByName("ppspmSudahMengapproveBerkasSppRecordCount")!.valueNumber.toString()),
            Text("berkasSppBelumLengkap: "+this.rowNode.content.rowData!.getFieldByName("berkasSppBelumLengkapRecordCount")!.valueNumber.toString()),
            Text("spiSudahMenggapproveBerkasSpp: "+this.rowNode.content.rowData!.getFieldByName("spiSudahMenggapproveBerkasSppRecordCount")!.valueNumber.toString()),
            Text(""),
            Text("SPBY",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("spbyRecordCount: "+this.rowNode.content.rowData!.getFieldByName("spbyRecordCount")!.valueNumber.toString()),
            Text("ppkSudahMelengkapiBerkasSpby: "+this.rowNode.content.rowData!.getFieldByName("ppkSudahMelengkapiBerkasSpbyRecordCount")!.valueNumber.toString()),
            Text("bppSudahMengapproveBerkasSpby: "+this.rowNode.content.rowData!.getFieldByName("bppSudahMengapproveBerkasSpbyRecordCount")!.valueNumber.toString()),
            Text("berkasSpbyBelumLengkap: "+this.rowNode.content.rowData!.getFieldByName("berkasSpbyBelumLengkapRecordCount")!.valueNumber.toString()),
            Text("spiSudahMenggapproveBerkasSpby: "+this.rowNode.content.rowData!.getFieldByName("spiSudahMenggapproveBerkasSpbyRecordCount")!.valueNumber.toString()),

          ],
        );
      }
      catch(error)
    {

    }


      return returnValue;
    }
    else{
      return Text("No record");
    }




  }



}

class ChartData {
  ChartData({required this.xCaption, required this.y,this.color=Colors.grey});

  final String xCaption;
  final double y;
  final Color color;
}