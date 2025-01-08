import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';





class VwOperatorTicketDashboard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  VwOperatorTicketDashboard ({Key? key}) : super(key: key);

  @override
  VwOperatorTicketDashboardState createState()=> VwOperatorTicketDashboardState();
}

class VwOperatorTicketDashboardState extends State<VwOperatorTicketDashboard > {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: SingleChildScrollView(child: Container(margin: EdgeInsets.all(20), child:Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Aktivitas Pengguna'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Aktivitas',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings( isVisible: true))
              ]),


        ]))));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}