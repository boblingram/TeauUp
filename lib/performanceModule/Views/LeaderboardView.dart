import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/utils/Enums.dart';
import 'package:teamup/widgets/ErrorListWidget.dart';

import '../Controllers/PerformanceController.dart';
import '../Model/LeaderboardItemExpansionModel.dart';
import '../Model/LeaderboardListModel.dart';
import '../Utils/CircularContainer.dart';
import 'AccessoryViews/LeaderboardWidget/ExpandedLeaderboardWidgets.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  final PerformanceController performanceController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      uiBuildingIsDone();
    });
  }

  void uiBuildingIsDone() {
    performanceController.fetchLeaderboardList();
    performanceController.fetchGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 1,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 8),
              color: Colors.grey.withOpacity(0.3),
            ),
          Obx(()=>Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
            child: DropdownButtonFormField<dynamic>(
                hint: Text("Select Goal"),
                isExpanded: true,
                focusColor: Colors.grey.shade300,
                value: performanceController.selectedGoal.isEmpty ? null : performanceController.selectedGoal,
                decoration: InputDecoration(
                    labelText: "Select Goal", //label text of field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300)
                    ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade300)
                  ),
                ),
                items: performanceController.goalDropDownList.value,
                onChanged: (var value) async {
                  //Fetch the Data of leaderboard according the list goal id selected
                  print("Selected Value is ${value}");
                  performanceController.fetchLeaderboardList(goalId: value);
                }),
          )),
            Row(
              children: [
                TimeLineWidget(
                  text: "Last 7 Days",
                  onTap: () {
                    performanceController
                        .updateTimelineFilter(TimelineFilter.SEVENDAYS);
                  },
                  value: TimelineFilter.SEVENDAYS,
                ),
                TimeLineWidget(
                  text: "Last 30 Days",
                  onTap: () {
                    performanceController
                        .updateTimelineFilter(TimelineFilter.THIRTYDAYS);
                  },
                  value: TimelineFilter.THIRTYDAYS,
                ),
                TimeLineWidget(
                  text: "All Time",
                  onTap: () {
                    performanceController
                        .updateTimelineFilter(TimelineFilter.ALLTIME);
                  },
                  value: TimelineFilter.ALLTIME,
                ),
              ],
            ),
            Container(
              height: 1,
              margin: EdgeInsets.fromLTRB(0, 5, 0, 8),
              color: Colors.grey.withOpacity(0.3),
            ),
            Obx(() => performanceController.leaderboardNetworkEnum.value ==
                    NetworkCallEnum.Loading
                ? ListLoadingWidget()
                : performanceController.leaderboardNetworkEnum.value ==
                        NetworkCallEnum.Completed
                    ? CompletedLeaderboardList()
                    : ListErrorWidget(
                        text: "Failed to retrieve leaderboard data")),
          ],
        ),
      ),
    );
  }
}

class CompletedLeaderboardList extends StatelessWidget {
  final PerformanceController performanceController = Get.find();

  CompletedLeaderboardList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => performanceController.leaderboardList.value.isEmpty
        ? Text("No Data")
        : RefreshIndicator(
            onRefresh: () async {
              performanceController.refreshLeaderboardList();
              performanceController.fetchGoals();
            },
            color: Colors.red,
            child: GetBuilder<PerformanceController>(
              builder: (performanceController) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: performanceController.leaderboardList.value.length,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    var leaderboard = performanceController
                        .leaderboardList.value
                        .elementAt(position);
                    return LeaderboardListItem(
                        leaderboard: leaderboard,
                        position: position,
                        userId: performanceController.userID);
                  },
                );
              },
            ),
          ));
  }
}

class TimeLineWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final Function onTap;
  final TimelineFilter value;
  final PerformanceController performanceController = Get.find();

  TimeLineWidget({
    Key? key,
    required this.text,
    this.textColor = Colors.black,
    required this.onTap,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
            child: Text(text,
                style: TextStyle(
                    color: performanceController.timelineFilter.value == value
                        ? Colors.red
                        : Colors.black,
                    fontWeight:
                        performanceController.timelineFilter.value == value
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: 12.sp)),
          ),
        ));
  }
}

class LeaderboardListItem extends StatefulWidget {
  final LeaderBoard leaderboard;
  final int position;
  final String userId;

  const LeaderboardListItem(
      {Key? key,
      required this.leaderboard,
      required this.position,
      required this.userId})
      : super(key: key);

  @override
  State<LeaderboardListItem> createState() => _LeaderboardListItemState();
}

class _LeaderboardListItemState extends State<LeaderboardListItem> {
  bool isExpanded = false;
  String? description;
  final PerformanceController performanceController = Get.find();

  LeaderboardItemExpansionModel? leaderboardItemExpansionModel;

  Widget getTimeLineFilterWidget(TimelineFilter value, bool isSelected) {
    switch (value) {
      case TimelineFilter.SEVENDAYS:
        return ExpansionSevenLeaderView(
            leaderboardItemExpansionModel: leaderboardItemExpansionModel,
            isYou: isSelected);
      case TimelineFilter.THIRTYDAYS:
        return ExpansionThirtyLeaderView(
            leaderboardItemExpansionModel: leaderboardItemExpansionModel,
            isYou: isSelected);
      case TimelineFilter.ALLTIME:
        return ExpansionAllTimeLeaderView(
            leaderboardItemExpansionModel: leaderboardItemExpansionModel,
            isYou: isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              /*if (!isExpanded) {
                leaderboardItemExpansionModel = await performanceController
                    .fetchExpansionValue(widget.leaderboard.userId);
                String newDescription = "OK Now";
                setState(() {
                  description = newDescription;
                  isExpanded = true;
                });
              } else {
                setState(() {
                  description = null;
                  isExpanded = false;
                });
              }*/
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: isExpanded
                      ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))
                      : BorderRadius.all(Radius.circular(10)),
                  border: widget.leaderboard.userId == widget.userId
                      ? Border.all(color: Colors.amber.shade200)
                      : Border.all(color: Colors.grey[200] ?? Colors.grey),
                  color: widget.leaderboard.userId == widget.userId
                      ? Colors.amber.shade200
                      : Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: IndividualLeaderItem(
                      leaderBoard: widget.leaderboard,
                      position: widget.position + 1,
                      isYou: widget.leaderboard.userId == widget.userId,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  isExpanded
                      ? CircularContainer(
                          imagePath: "",
                          iconData: Icons.arrow_drop_up,
                          iconSize: 10.sp,
                          padding: EdgeInsets.all(1),
                          filledColor: Colors.transparent,
                        )
                      : CircularContainer(
                          imagePath: "",
                          iconData: Icons.arrow_drop_down,
                          iconSize: 10.sp,
                          padding: EdgeInsets.all(1),
                          filledColor: Colors.transparent,
                        ),
                ],
              ),
            ),
          ),
          if (isExpanded && description != null)
            Obx(() => getTimeLineFilterWidget(
                performanceController.timelineFilter.value,
                widget.leaderboard.userId == widget.userId))
        ],
      ),
    );
  }
}

class IndividualLeaderItem extends StatelessWidget {
  final LeaderBoard leaderBoard;
  final int position;
  final bool isYou;
  final PerformanceController performanceController = Get.find();

  IndividualLeaderItem(
      {Key? key,
      required this.leaderBoard,
      required this.position,
      this.isYou = false})
      : super(key: key);

  Color getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade300;
      case 3:
        return Colors.brown.shade400;
      default:
        return Colors.grey;
    }
  }

  int getPosPoints(TimelineFilter value) {
    switch (value) {
      case TimelineFilter.SEVENDAYS:
        return leaderBoard.sevenDayStats[0];
      case TimelineFilter.THIRTYDAYS:
        return leaderBoard.thirtyDayStats[0];
      case TimelineFilter.ALLTIME:
        return leaderBoard.allTimeStats[0];
    }
  }

  int getNegPoints(TimelineFilter value) {
    switch (value) {
      case TimelineFilter.SEVENDAYS:
        return leaderBoard.sevenDayStats[1];
      case TimelineFilter.THIRTYDAYS:
        return leaderBoard.thirtyDayStats[1];
      case TimelineFilter.ALLTIME:
        return leaderBoard.allTimeStats[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///Number Position
        Container(
          width: 10.w,
          height: 10.w,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: getPositionColor(position),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
              child: Text(
            position.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold),
          )),
        ),
        /*Column(
          children: [
            Icon(Icons.arrow_drop_up_rounded),
            Text("1")
          ],
        ),*/
        SizedBox(
          width: 10,
        ),
        Obx(
          () => Expanded(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${leaderBoard.fnln} ${isYou ? "(You)" : ""}"),
                  Row(
                    children: [
                      Text(getPosPoints(
                              performanceController.timelineFilter.value)
                          .toString()),
                      Text("-"),
                      Text(getNegPoints(
                              performanceController.timelineFilter.value)
                          .toString())
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Expanded(
                      flex: getPosPoints(
                          performanceController.timelineFilter.value),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: getNegPoints(performanceController
                                      .timelineFilter.value) !=
                                  0
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3),
                                )
                              : BorderRadius.circular(3),
                        ),
                      )),
                  Expanded(
                      flex: getNegPoints(
                          performanceController.timelineFilter.value),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: getPosPoints(performanceController
                                      .timelineFilter.value) !=
                                  0
                              ? BorderRadius.only(
                                  topRight: Radius.circular(3),
                                  bottomRight: Radius.circular(3),
                                )
                              : BorderRadius.circular(3),
                        ),
                      ))
                ],
              ),
            ],
          )),
        )
      ],
    );
  }
}

//Old Approach
/*
return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomExpansionTile(
                        title: IndividualLeaderItem(
                            leaderBoard: leaderboard, position: position + 1,isYou: leaderboard.userId == userID,),
                        tilePadding: EdgeInsets.zero,
                        tapChildrenBoxDecoration: BoxDecoration(),
                        children: [Text("Show The Text")],
                        trailing: CircularContainer(
                          imagePath: "",
                          iconData: Icons.arrow_drop_up,
                          iconSize: 10.sp,
                          padding: EdgeInsets.all(1),
                          filledColor: Colors.transparent,
                        ),
                        trailing2: CircularContainer(
                          imagePath: "",
                          iconData: Icons.arrow_drop_down,
                          iconSize: 10.sp,
                          padding: EdgeInsets.all(1),
                          filledColor: Colors.transparent,
                        ),
                        mainTitleDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: leaderboard.userId == userID ? Border.all(color: Colors.amber.shade200): Border.all(
                                color: Colors.grey[200] ?? Colors.grey),
                          color: leaderboard.userId == userID ? Colors.amber.shade200 : Colors.white
                        ),
                        mainTitlePadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      ),
                    );
 */
