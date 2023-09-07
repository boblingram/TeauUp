import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamup/controllers/GoalController.dart';
import 'package:teamup/mixins/baseClass.dart';

import '../../utils/PermissionManager.dart';
import '../../utils/app_colors.dart';
import '../../widgets/CreateGoalMetaDataView.dart';
import 'invite_goals_page/group_goals_page.dart';
import 'invite_goals_page/individual_goals_page.dart';


class InviteToGoalPage extends StatefulWidget {
  const InviteToGoalPage({Key? key}) : super(key: key);

  @override
  State<InviteToGoalPage> createState() => _InviteToGoalPageState();
}

class _InviteToGoalPageState extends State<InviteToGoalPage>
    with BaseClass, SingleTickerProviderStateMixin {
  TabController? controller;
  int _selectedTabValue = 0;

  final GoalController goalController = Get.find();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.goalAppBarColor,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CreateGoalMetaDataView(
                        showBack: true,
                          onPressed: () {
                            Get.back();
                          },
                          sliderText: "4/4",
                          sliderValue: 120,
                          goalMetaTitle: "Invite",
                          goalMetaDescription:
                              "Do it alone or do it with a group. Invite\nmentor to guide you or invite friends to\ninspire you."),
                    ],
                  ),
                ),
                expandedHeight: getScreenHeight(context) * 0.45,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          //border: Border.all(color: Colors.white),
                          color: Colors.grey.shade300),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: TabBar(
                        tabs: const [
                          Tab(
                            text: "Group Goals",
                          ),
                          Tab(
                            text: "Individual Goals",
                          ),

                          //  Tab(icon: Icon(Icons.directions_bike)),
                        ],
                        controller: controller,
                        labelStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.transparent,
                        indicator: BoxDecoration(
                            borderRadius: _selectedTabValue == 0
                                ? BorderRadius.circular(5)
                                : BorderRadius.circular(5),
                            color: Colors.white),
                        labelColor: Colors.black,
                        onTap: (value) {
                          setState(() {
                            _selectedTabValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: _selectedTabValue == 0 ? GroupGoalPage() : IndividualGoalPage()),
    );
  }
}
