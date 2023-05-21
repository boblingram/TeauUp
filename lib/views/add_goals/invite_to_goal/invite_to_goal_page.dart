import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamup/mixins/baseClass.dart';

import '../../../utils/app_colors.dart';
import '../group_goals/group_goals_page.dart';

class InviteToGoalPage extends StatefulWidget {
  const InviteToGoalPage({Key? key}) : super(key: key);

  @override
  State<InviteToGoalPage> createState() => _InviteToGoalPageState();
}

class _InviteToGoalPageState extends State<InviteToGoalPage> with BaseClass, SingleTickerProviderStateMixin {
  TabController? controller;
  int _selectedTabValue = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
    _askPermissions(null);
  }
  Future<void> _askPermissions(String? routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != null) {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return[
            SliverAppBar(
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: true,
              backgroundColor: AppColors.goalAppBarColor,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      color: const Color(0xff589288),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(
                            height: 56,
                          ),

                          Text(
                            "4/4",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Container(
                                width: 120,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Invite",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Do it alone or do it with a group. Invite\nmentor to guide you or invite friends to\ninspire you.",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
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
        }, body: _selectedTabValue==0?GroupGoalPage():Container()
      ),
    );
  }
}
