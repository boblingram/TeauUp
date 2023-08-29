import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../PerformanceConstants.dart';
import '../Controllers/PerformanceController.dart';
import 'LeaderboardView.dart';
import 'MyPerformanceView.dart';

class PerformanceView extends StatefulWidget {
  const PerformanceView({Key? key}) : super(key: key);

  @override
  State<PerformanceView> createState() => _PerformanceViewState();
}

class _PerformanceViewState extends State<PerformanceView> with TickerProviderStateMixin{

  final PerformanceController performanceController = Get.put(PerformanceController());
  late TabController tabController;


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            performanceController.hamburgerPressed();
          }, icon: Icon(Icons.menu,color: HexColor(Constants.PRIMARYCOLOR),),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Performance",style: TextStyle(color: HexColor(Constants.PRIMARYCOLOR)),),
        actions: [
          IconButton(
            onPressed: (){
              performanceController.notificationPressed();
            }, icon: Icon(Icons.notifications,color: HexColor(Constants.PRIMARYCOLOR),),
          )
        ],
      ),*/
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            //Tab -> Leaderboard, My Performance
            SizedBox(
              height: 10.h,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  /*boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],*/
                ),
                margin: EdgeInsets.fromLTRB(30, 20, 30, 5),
                child: TabBar(
                  controller: tabController,
                    tabs: [Tab(text: "Leaderboard",),Tab(text: "My Performance",)],
                  labelColor: Colors.black87,
                  indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                  children: [
                LeaderboardView(),
                MyPerformanceView()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
