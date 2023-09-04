import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/performanceModule/Views/PerformanceView.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/GoalView.dart';
import 'package:teamup/views/journey_views/journey_view.dart';
import 'package:teamup/views/settings/settings_page.dart';

import '../controllers/GoalController.dart';
import '../utils/app_colors.dart';
import 'NotificationView.dart';
import 'add_goals/set_goals/set_goal_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with BaseClass {
  int _selectedIndex = 0;
  var pageTitle = "Goals".obs;

  GoalController goalController = Get.put(GoalController());
  VEGoalController veGoalController = Get.put(VEGoalController());

  void _onItemTapped(int index) {
    print("Index is $index");
    if(index == 2){
      print("Navigate to Add new goals");
      Get.to(SetGoalPage());
    }else{
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget getBodyHome() {
    switch (_selectedIndex) {
      case 0:
        pageTitle.value = "Goals";
        return GoalView();
      case 1:
        pageTitle.value = "Journey";
        return Journey_View();
      case 3:
        pageTitle.value = "Connect";
        return Container();
      case 4:
        pageTitle.value = "Performance";
        return Sizer(
            builder: (context, orientation, deviceType) {
              return PerformanceView();
            }
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Obx(()=>Text(
          pageTitle.value,
          style: GoogleFonts.roboto(color: AppColors.black),
        )),
        actions: [
          IconButton(
            onPressed: (){
              Get.to(()=>NotificationView());
            },
            icon: Icon(Icons.notifications),
            color: AppColors.greyWithShade900,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        leading: InkWell(
          onTap: () {
            pushToNextScreen(
              context: context,
              destination: SettingsPage(),
            );
          },
          child: const Icon(
            Icons.dehaze_rounded,
            color: AppColors.black,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.red,
          unselectedItemColor: AppColors.black,
          unselectedFontSize: 10,
          selectedFontSize: 12,
          iconSize: 20,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          onTap: _onItemTapped,
          elevation: 5,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.scoreboard_outlined),
                label: AppStrings.goals,
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: AppStrings.journey,
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle_outline_sharp,
                  size: 30,
                ),
                label: '',
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_phone_msg_outlined),
                label: AppStrings.connect,
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: AppStrings.performance,
                backgroundColor: AppColors.white),
          ]),
      body: getBodyHome(),
    );
  }
}
