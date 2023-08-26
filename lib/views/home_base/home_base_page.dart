import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/mixins/baseClass.dart';
import 'package:teamup/performanceModule/Views/PerformanceView.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/home/home_page.dart';
import 'package:teamup/views/settings/settings_page.dart';

import '../../utils/app_colors.dart';
import '../add_goals/set_goals/set_goal_page.dart';

class HomeBasePage extends StatefulWidget {
  const HomeBasePage({Key? key}) : super(key: key);

  @override
  State<HomeBasePage> createState() => _HomeBasePageState();
}

class _HomeBasePageState extends State<HomeBasePage> with BaseClass {
  int _selectedIndex = 0;
  String pageTitle = "Goals";

  void _onItemTapped(int index) {
    print("Index is $index");
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getBodyHome() {
    switch (_selectedIndex) {
      case 0:
        pageTitle = "Goals";
        return HomePage();
      case 2:
        pageTitle = "Goals";
        return SetGoalPage();
      case 4:
        pageTitle = "Performance";
        return Sizer(
            builder: (context, orientation, deviceType) {
              return PerformanceView();
            }
        );
      case 1:
        pageTitle = "Journey";
        return Container();
      case 3:
        pageTitle = "Connect";
        return Container();
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
        title: Text(
          pageTitle,
          style: GoogleFonts.roboto(color: AppColors.black),
        ),
        actions: [
          Icon(
            Icons.notifications,
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
