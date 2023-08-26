import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Controllers/PerformanceController.dart';
import '../../../Model/MyPerformanceModel.dart';

class CompareGoalWidget extends StatelessWidget {
  final PerformanceController performanceController = Get.find();
  CompareGoalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10,8,10,8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300] ?? Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 44.h,child: Column(
      children: [
        Row(children: [
          Text("Time Period:",style: TextStyle(fontSize: 14.sp),),
          SizedBox(width: 5),
          Obx(()=>DropdownButton(value: performanceController.dropCTimePeriodValue.value, items: performanceController.dropCTimePeriodList, onChanged: (value){
            performanceController.dropCTimePeriodValue.value = value ?? 1;
          }))
        ],),
        SizedBox(height:30.h,child: BarChartHorizontal()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HorizontalLegend(iconData: Icons.check_box_rounded, iconDataColor: Colors.blue, text: "Completed"),
            SizedBox(width: 10,),
            HorizontalLegend(iconData: Icons.check_box_rounded, iconDataColor: Colors.deepOrange, text: "Missed"),
          ],),
      ],
    ));
  }
}


//Sub Class
class HorizontalLegend extends StatelessWidget {
  final IconData iconData;
  final Color iconDataColor;
  final String text;
  const HorizontalLegend({Key? key, required this.iconData, required this.iconDataColor, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: iconDataColor,),
        Text(text)
      ],
    );
  }
}

/// Sample ordinal data type.
class GoalData {
  //Goal Name
  final String goalName;
  //Activity Values Contain Both Completed and Missed
  final int actvityValues;

  GoalData(this.goalName, this.actvityValues);
}

class BarChartHorizontal extends StatefulWidget {
  const BarChartHorizontal({Key? key}) : super(key: key);

  @override
  State<BarChartHorizontal> createState() => _BarChartHorizontalState();
}

class _BarChartHorizontalState extends State<BarChartHorizontal> {
  final PerformanceController performanceController = Get.find();

  List<charts.Series<GoalData, String>> seriesList = [];
  List<charts.Series<GoalCompare, String>> goalList = [];
  /// Create series list with multiple series
  static List<charts.Series<GoalData, String>> _createSampleData() {
    final desktopSalesData = [
      new GoalData('2014', 18),
      new GoalData('2015', 5),
      new GoalData('2016', 14),
      new GoalData('2017', 20),
    ];

    final tableSalesData = [
      new GoalData('2014', 2),
      new GoalData('2015', 1),
      new GoalData('2016', 3),
      new GoalData('2017', 0),
    ];

    final mobileSalesData = [
      new GoalData('2014', 10),
      new GoalData('2015', 15),
      new GoalData('2016', 50),
      new GoalData('2017', 45),
    ];

    return [
      new charts.Series<GoalData, String>(
          id: 'Desktop',
          domainFn: (GoalData sales, _) => sales.goalName,
          measureFn: (GoalData sales, _) => sales.actvityValues,
          data: desktopSalesData,
          seriesColor: charts.MaterialPalette.blue.shadeDefault
      ),
      new charts.Series<GoalData, String>(
          id: 'Tablet',
          domainFn: (GoalData sales, _) => sales.goalName,
          measureFn: (GoalData sales, _) => sales.actvityValues,
          data: tableSalesData,
          seriesColor: charts.MaterialPalette.deepOrange.shadeDefault
      ),
      /*new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),*/
    ];
  }

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
  }

  Widget convertList(){
    var activityCompletedList = <GoalData>[];
    var activityNotCompletedList = <GoalData>[];

    performanceController.goalChartStatus.forEach((element) {
      print("Goal Name is ${element.goalName} A ${element.activityCompleted} NA  ${element.activityNotComplete}");
      activityCompletedList.add(GoalData(element.goalName, int.tryParse(element.activityCompleted) ?? 0));
      activityNotCompletedList.add(GoalData(element.goalName, int.tryParse(element.activityNotComplete) ?? 0));
    });

    goalList = [
      new charts.Series<GoalCompare, String>(
        id: 'Desktop',
        domainFn: (GoalCompare sales, _) => sales.goalName,
        measureFn: (GoalCompare sales, _) => int.tryParse(sales.activityCompleted) ?? 0,
        data: performanceController.goalChartStatus.value,
        seriesColor: charts.MaterialPalette.blue.shadeDefault
    ),
      new charts.Series<GoalCompare, String>(
          id: 'Tablet',
          domainFn: (GoalCompare sales, _) => sales.goalName,
          measureFn: (GoalCompare sales, _) => int.tryParse(sales.activityNotComplete) ?? 0,
          data: performanceController.goalChartStatus.value,
          seriesColor: charts.MaterialPalette.deepOrange.shadeDefault
      )
    ];

    return charts.BarChart(
      goalList,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>performanceController.goalChartStatus.isEmpty ? charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.stacked,
      vertical: false,
    ) : convertList());
  }
}
