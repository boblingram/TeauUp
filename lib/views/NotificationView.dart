import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/controllers/GoalController.dart';
import 'package:teamup/models/IndividualNotificationModel.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/journey_views/journey_view.dart';
import 'package:teamup/widgets/ErrorListWidget.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../utils/app_colors.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final GoalController goalController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      uiBuildingComplete();
    });
  }

  void uiBuildingComplete() {
    goalController.fetchNotificationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(AppColors.notificationColor),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
              ),
            ),
            Text(
              AppStrings.notificationText,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      body: Container(
        child: GetBuilder<GoalController>(
          builder: (goalController){
            return goalController.notificationList.isEmpty
                ? ErrorListWidget(text: "No Notification Found")
                : ListView.builder(
                itemCount: goalController.notificationList.length,
                itemBuilder: (context, index) {
                  var item = goalController.notificationList.elementAt(index);
                  return IndividualNotificationView(
                    item: item, selectedIndex: index,

                  );
                });
          },
        ),
      ),
    );
  }
}

class IndividualNotificationView extends StatelessWidget {
  final IndividualNotificationModel item;
  final int selectedIndex;

  IndividualNotificationView({super.key, required this.item, required this.selectedIndex});

  final GoalController goalController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                    child: Icon(Icons.notifications_active_outlined),
                  )),
              Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 1.h, 2.w, 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.type.toString(),
                              style: TextStyle(
                                  fontWeight:
                                      item.status.toString().toLowerCase() ==
                                              "new"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: 12.sp),
                            ),
                            Text(timeago.format(
                                DateTime.tryParse(item.createdDt.toString()) ??
                                    goalController.currentTime))
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Text(item.msg.toString())),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  goalController.notificationMutationQuery(NotificationMutationEnum.MarkasRead, item.id, selectedIndex);
                                },
                                paddingButton: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 6),
                                text: AppStrings.defaultMarkasComplete,
                                textStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.sp),
                                boxDecoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(3)),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  goalController.notificationMutationQuery(NotificationMutationEnum.Delete, item.id, selectedIndex);
                                },
                                paddingButton: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 6),
                                text: AppStrings.defaultDelete,
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                                boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.shade300,
            margin: EdgeInsets.fromLTRB(5.w, 1.h, 2.w, 1.h),
          )
        ],
      ),
    );
  }
}
