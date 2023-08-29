import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../PerformanceConstants.dart';
import '../../../Model/LeaderboardItemExpansionModel.dart';

class ExpansionSevenLeaderView extends StatelessWidget {
  List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final LeaderboardItemExpansionModel? leaderboardItemExpansionModel;
  final bool isYou;

  ExpansionSevenLeaderView(
      {Key? key, this.leaderboardItemExpansionModel, this.isYou = false})
      : super(key: key);

  Widget getIconToShow(Summ value) {
    switch (value) {
      case Summ.RED:
        return Icon(
          Icons.stop_circle,
          color: Colors.red,
        );
      case Summ.GREEN:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      default:
        return Icon(
          Icons.circle,
          color: Colors.grey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Days Of Week
        Container(
          //color: Colors.yellow,
          decoration: BoxDecoration(
              border: Border.all(
                color: isYou ? Colors.white : Colors.grey.withOpacity(0.3),
              ),
              color: isYou ? Colors.amber.shade200 : Colors.white),
          height: 6.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: daysOfWeek.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        ///Content
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(
                color: isYou ? Colors.white : Colors.grey.withOpacity(0.3),
              ),
              color: isYou ? Colors.amber.shade200 : Colors.white),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
              leaderboardItemExpansionModel?.userActivitySumm.length ?? 0,
              itemBuilder: (context, index) {
                var item = leaderboardItemExpansionModel?.userActivitySumm
                    .elementAt(index);
                print("Name of 7 Item is ${item?.goalName}");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item?.goalName ?? STRINGD),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < 7; i++)
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              width: 20.0,
                              height: 20.0,
                              child: getIconToShow(
                                  item?.sevenDaySumm.elementAt(i) ?? Summ.GREY),
                            ),
                          ),
                      ],
                    )
                  ],
                );
              }),
        ),

        ///Legend
        ExpansionLegendView(isYou: isYou,)
      ],
    );
  }
}

class ExpansionThirtyLeaderView extends StatelessWidget {
  final LeaderboardItemExpansionModel? leaderboardItemExpansionModel;
  final bool isYou;

  const ExpansionThirtyLeaderView(
      {Key? key, this.leaderboardItemExpansionModel, this.isYou = false})
      : super(key: key);

  Color getIconColor(Summ value) {
    switch (value) {
      case Summ.RED:
        return Colors.red;
      case Summ.GREEN:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
              border: Border.all(
                color: isYou ? Colors.white : Colors.grey.withOpacity(0.3),
              ),
              color: isYou ? Colors.amber.shade200 : Colors.white),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
              leaderboardItemExpansionModel?.userActivitySumm.length ?? 0,
              itemBuilder: (context, index) {
                var item = leaderboardItemExpansionModel?.userActivitySumm
                    .elementAt(index);
                print("Name of 7 Item is ${item?.goalName}");
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(item?.goalName ?? STRINGD),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < 30; i++)
                          Expanded(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getIconColor(
                                    item?.thirtyDaySumm.elementAt(i) ??
                                        Summ.GREY),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                );
              }),
        ),
        ExpansionLegendView(isYou: isYou,)
      ],
    );
  }
}

class ExpansionAllTimeLeaderView extends StatelessWidget {
  final LeaderboardItemExpansionModel? leaderboardItemExpansionModel;
  final bool isYou;

  const ExpansionAllTimeLeaderView(
      {Key? key, this.leaderboardItemExpansionModel, this.isYou = false})
      : super(key: key);

  Color getIconColor(Summ value) {
    print("Sum is ${value}");
    switch (value) {
      case Summ.RED:
        return Colors.red;
      case Summ.GREEN:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(
                color: isYou ? Colors.white : Colors.grey.withOpacity(0.3),
              ),
              color: isYou ? Colors.amber.shade200 : Colors.white),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
              leaderboardItemExpansionModel?.userActivitySumm.length ?? 0,
              itemBuilder: (context, index) {
                var item = leaderboardItemExpansionModel?.userActivitySumm
                    .elementAt(index);
                var listLength = item?.allTimeSumm.length ?? 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(item?.goalName ?? STRINGD),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (listLength / 30).ceil(),
                      itemBuilder: (BuildContext context, int index) {
                        int startIndex = index * 30;
                        int endIndex = (startIndex + 30 < listLength)
                            ? startIndex + 30
                            : listLength;
                        return Wrap(
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            endIndex - startIndex,
                                (i) => Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 1.1, vertical: 2),
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getIconColor(
                                    item?.allTimeSumm.elementAt(i) ??
                                        Summ.GREY),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              }),
        ),
        ExpansionLegendView(isYou: isYou,)
      ],
    );
  }
}

class ExpansionLegendView extends StatelessWidget {
  final bool isYou;
  const ExpansionLegendView({Key? key, this.isYou = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: isYou ? Colors.white : Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: isYou ? Colors.amber.shade200 : Colors.white),
      height: 6.h,
      child: Row(
        children: [
          Expanded(
              child: HorizontalIconText(
                  iconColor: Colors.green,
                  iconData: Icons.check_circle,
                  iconText: "Completed")),
          Expanded(
              child: HorizontalIconText(
                  iconColor: Colors.red,
                  iconData: Icons.stop_circle,
                  iconText: "Missed")),
          Expanded(
              child: HorizontalIconText(
                  iconColor: Colors.grey,
                  iconData: Icons.circle,
                  iconText: "Not Scheduled"))
        ],
      ),
    );
  }
}


class HorizontalIconText extends StatelessWidget {
  final Color iconColor;
  final IconData iconData;
  final String iconText;

  const HorizontalIconText(
      {Key? key,
        required this.iconColor,
        required this.iconData,
        required this.iconText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: iconColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: iconColor,
          ),
          Text(
            iconText,
            style: TextStyle(fontSize: 8.sp),
          )
        ],
      ),
    );
  }
}