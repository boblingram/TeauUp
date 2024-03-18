import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/PerformanceController.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class EarnedWidget extends StatelessWidget {
  final PerformanceController performanceController = Get.find();
  EarnedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,8,10,8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300] ?? Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              Text("Time Period:",style: TextStyle(fontSize: 14.sp),),
              SizedBox(width: 5),
              Container(margin:EdgeInsets.symmetric(vertical: 8),child: Text("All time",style: TextStyle(fontSize: 12.sp),)),
              /*Obx(()=>DropdownButton(value: performanceController.dropETimePeriodValue.value, items: performanceController.dropETimePeriodList, onChanged: (value){
                performanceController.dropETimePeriodValue.value = value ?? 1;
              }))*/
            ],
          ),
          Text("${performanceController.totalXP.value} XP")
        ],),
          SizedBox(height: 10,),
          Obx(()=>SfCartesianChart(
            // Initialize category axis
              primaryXAxis: CategoryAxis(),

              series: <LineSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  // Bind data source
                    dataSource:  <SalesData>[
                      SalesData('Mon', performanceController.earnedChartStatus.value[0]),
                      SalesData('Tue', performanceController.earnedChartStatus.value[1]),
                      SalesData('Wed', performanceController.earnedChartStatus.value[2]),
                      SalesData('Thr', performanceController.earnedChartStatus.value[3]),
                      SalesData('Fri', performanceController.earnedChartStatus.value[4]),
                      SalesData('Sat', performanceController.earnedChartStatus.value[5]),
                      SalesData('Sun', performanceController.earnedChartStatus.value[6])
                    ],
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales
                )
              ]
          )),
        ],
      ),
    );
  }
}
