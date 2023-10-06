import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/performanceModule/Views/PerformanceView.dart';
import 'package:teamup/utils/app_Images.dart';
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

  late GoalController goalController;
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
  void initState() {
    try{
      goalController = Get.find();
    }catch(onError){
      print("Failed to find Goal Controller $onError");
      goalController = Get.put(GoalController());
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {postUIBuild();});
  }

  void postUIBuild(){
    //TODO Update FCM This is required because of Testing
    //goalController.mutationNotificationServer(value);
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
          style: GoogleFonts.openSans(color: AppColors.black,textStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 19.sp,letterSpacing: 0.3)),
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
          backgroundColor: Colors.white,
          selectedItemColor: HexColor(AppColors.selectedColor),
          unselectedItemColor: HexColor(AppColors.nonSelectedColor),
          unselectedFontSize: 10,
          selectedFontSize: 12,
          iconSize: 20,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 8.5.sp),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 8.5.sp),
          onTap: _onItemTapped,
          elevation: 5,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0,0,0,5),
                  child: Image.asset(AppImages.unselectedGoalB,height: 5.w,width: 6.w,),
                ),
                activeIcon: Padding(
                padding: EdgeInsets.fromLTRB(0,0,0,4),
                child: Image.asset(AppImages.selectedGoalB,height: 6.5.w,width: 6.5.w,),
                ),
                label: AppStrings.goals,
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Icon(Icons.calendar_month)),
                label: AppStrings.journey,
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Icon(
                    Icons.add_circle_outline_sharp,
                    size: 30,
                  ),
                ),
                label: '',
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Icon(Icons.perm_phone_msg_outlined)),
                label: AppStrings.connect,
                backgroundColor: AppColors.white),
            BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Icon(Icons.bar_chart)),
                label: AppStrings.performance,
                backgroundColor: AppColors.white),
          ]),
      body: getBodyHome(),
    );
  }
}

