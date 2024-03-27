import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:teamup/controllers/VEGoalController.dart';
import 'package:teamup/utils/Enums.dart';
import '../../utils/Constants.dart';
import '../../utils/GraphQLService.dart';
import '../../utils/app_strings.dart';
import '../PerformanceConstants.dart';
import '../Model/LeaderboardItemExpansionModel.dart';

import '../Model/LeaderboardListModel.dart';
import '../Model/MyPerformanceModel.dart' as PerformanceModel;
import '../Model/MyPerformanceModel.dart';

enum TimelineFilter{
  SEVENDAYS,
  THIRTYDAYS,
  ALLTIME
}

class PerformanceController extends GetxController{

  //Timeline filter
  var timelineFilter = TimelineFilter.SEVENDAYS.obs;
  var userID = "1";

  //Leaderboard Data
  var leaderboardList = <LeaderBoard>[].obs;

  //My Performance
  var sevenDayStatus = <String>['','','','','','',''].obs;
  var totalXP = STRINGD.obs;
  var currentStreak = STRINGD.obs;
  var longestStreak = STRINGD.obs;
  var earnedChartStatus = <double>[10,5,0,15,5,25,0].obs;
  var totalDay = DOUBLED.obs;
  var days = DOUBLED.obs;
  //This Contains only ID
  var earnedBadges = <String>[].obs;
  //This is in Form of Badges Model
  var totalBadges = [].obs;
  var latestBadgeName = STRINGD.obs;
  var goalChartStatus = <GoalCompare>[].obs;
  var badgesEarnedList = <PerformanceModel.Badge>[].obs;
  var badgesLeftList = <PerformanceModel.Badge>[].obs;

  //Drop Down Fix
  var dropEarnedSelectedValue = 1.obs;
  var dropEarnedDownList = [DropdownMenuItem(child: Text("All Goal1"),value: 1,),DropdownMenuItem(child: Text("All Goal2"),value: 2,),DropdownMenuItem(child: Text("All Goal3"),value: 3,)];

  var dropETimePeriodValue = 1.obs;
  var dropETimePeriodList = [DropdownMenuItem(child: Text("Last 7 Days"),value: 1,),DropdownMenuItem(child: Text("Last 30 Days"),value: 2,),DropdownMenuItem(child: Text("All Time"),value: 3,)];

  var dropCTimePeriodValue = 1.obs;
  var dropCTimePeriodList = [DropdownMenuItem(child: Text("Last 7 Days"),value: 1,),DropdownMenuItem(child: Text("Last 30 Days"),value: 2,),DropdownMenuItem(child: Text("All Time"),value: 3,)];

  var dropStreakSelectedValue = 1.obs;
  var dropStreakDownList = [DropdownMenuItem(child: Text("Practice Math"),value: 1,),DropdownMenuItem(child: Text("Connect With People"),value: 2,),DropdownMenuItem(child: Text("Hobbies Time"),value: 3,)];

  final localStorage = GetStorage();

  final goalDropDownList = <DropdownMenuItem>[].obs;
  final selectedGoal = "";

  @override
  void onInit() {
    super.onInit();
    userID = localStorage.read(AppStrings.localClientIdValue) ?? AppStrings.defaultUserId;
    print("UserId is $userID");
    fetchMyPerformance();
  }

  var leaderboardNetworkEnum = NetworkCallEnum.Loading.obs;

  void updateLeaderboardNetworkEnum(NetworkCallEnum temp){
    leaderboardNetworkEnum.value = temp;
  }

  void refreshLeaderboardList({String goalId = ""}){
    GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    fetchLeaderboardList(goalId: goalId);
  }

  void refreshPerformanceList(){
    GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    fetchMyPerformance();
  }

  void fetchLeaderboardList({String goalId = ""})async{
    //Graphql
    //Testing userId: "0efcc320-219d-44bb-a5d9-4206bc809c20"
    final query = '''query MyQuery {
  leaderBoard(goalId:"$goalId", userId: "$userID") {
     FNLN
     id
    userId
    allTimeStats
    sevenDayStats
    thirtyDayStats
  }
}''';
    updateLeaderboardNetworkEnum(NetworkCallEnum.Loading);
    //print("Leaderboard Query is ${query}");
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: gql(query)));
    //It can have exception or data
    //log(result.data.toString());
    json.encode(result.data);
    if(result.data == null && result.exception != null){
      //No Data Received from Server;
      parseError(result.exception,"FetchLeaderboardList");
      updateLeaderboardNetworkEnum(NetworkCallEnum.Error);
      return;
    }
    var leaderList = LeardboardListModel.fromJson(result.data!);
    leaderboardList.value = leaderList.leaderBoard;
    //leaderboardList.value = leaderBoards;
    print("Length of List is ${leaderList.leaderBoard.length}");
    updateLeaderboardNetworkEnum(NetworkCallEnum.Completed);
  }

  List<LeaderBoard> leaderBoards = [
    LeaderBoard(
        fnln: "John Doe",
        id: "1",
        allTimeStats: [50, 30, 20],
        sevenDayStats: [10, 10, 10],
        thirtyDayStats: [20, 10, 10],
        userId: "1",
        goalId: "1"),
    LeaderBoard(
        fnln: "Jane Smith",
        id: "2",
        allTimeStats: [60, 20, 10],
        sevenDayStats: [5, 5, 100],
        thirtyDayStats: [15, 5, 5],
        userId: "2",
        goalId: "2"),
    LeaderBoard(
        fnln: "Alice Johnson",
        id: "3",
        allTimeStats: [40, 25, 15],
        sevenDayStats: [18, 8, 70],
        thirtyDayStats: [18, 78, 8],
        userId: "3",
        goalId: "3"),
  ];


  Future<LeaderboardItemExpansionModel?> fetchExpansionValue(String userId) async{
    //Graphql

    final query = gql('''query MyQuery {
  userActivitySumm(userId: "$userId") {
    allTimeSumm
    goalId
    goalName
    id
    sevenDaySumm
    thirtyDaySumm
  }
}''');
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
    //It can have exception or data
    log(result.data.toString());
    if(result.data == null && result.exception != null){
      parseError(result.exception,"FetchExpansionValue");
      return null;
    }
    var leaderExpansion = LeaderboardItemExpansionModel.fromJson(result.data!);
    print("Length of Leaderboard Expansion is ${leaderExpansion.userActivitySumm.length} ");
    return leaderExpansion;
  }

  void parseError(OperationException? responseToShow, String apiCallFrom){
    print("Error in $apiCallFrom");
    if (responseToShow != null && responseToShow.graphqlErrors.isNotEmpty){
      print("Error is ${responseToShow.graphqlErrors[0].message}");
    }else{
      log("Exception is $responseToShow");
    }
  }

  void fetchMyPerformance()async{
    //Graphql

    final query = gql('''query MyQuery {
  userPerformance(userId: "$userID") {
    currentStreak
    earnedBadges
    goalCompare {
      activityCompleted
      activityNotComplete
      goalName
      updatedDt
      userId
      id
    }
    id
    longestStreak
    mainStreak
    sevenDayStatus
    sevenDaysXP
    totalXP
    userId
    weeklyCompare {
      id
      userId
      userTaskSumm {
        activityCompleted
        activityNotComplete
        goalName
        id
        updatedDt
        userId
      }
      week
    }
    badges {
      desc
      icon
      id
      name
    }
    totalDays
  }
}
''');
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
    //It can have exception or data
    //log(result.data.toString());

    if(result.data == null && result.exception != null){
      //No Data Received from Server;
      parseError(result.exception,"FetchMyPerformance");
      return;
    }
    MyPerformanceModel myPerformanceModel = MyPerformanceModel.fromJson(result.data!);
    print("Current Streak is ${myPerformanceModel.userPerformance.currentStreak}");
    totalXP.value = myPerformanceModel.userPerformance.totalXp;
    currentStreak.value = myPerformanceModel.userPerformance.currentStreak;
    longestStreak.value = myPerformanceModel.userPerformance.longestStreak;
    sevenDayStatus.value = myPerformanceModel.userPerformance.sevenDayStatus;
    earnedChartStatus.value = myPerformanceModel.userPerformance.sevenDaysXp;
    totalDay.value = myPerformanceModel.userPerformance.totalDays;
    days.value = myPerformanceModel.userPerformance.mainStreak;

    earnedBadges.value = myPerformanceModel.userPerformance.earnedBadges;
    totalBadges.value = myPerformanceModel.userPerformance.badges;
    goalChartStatus.value = myPerformanceModel.userPerformance.goalCompare;
    updateLatestBadge();
    splitIntoTwo();
  }

  void updateLatestBadge(){
    //It's String
    print("value of Earned badges is ${earnedBadges.value}");
    if(earnedBadges.isEmpty){
      return;
    }
    var latestBadgeId = earnedBadges.value.last;
    var result = totalBadges.firstWhereOrNull((element){
      if(element is PerformanceModel.Badge){
        return (element as PerformanceModel.Badge).id == latestBadgeId.toString();
      }else {
        return false;
      }
    });
    if(result != null && result is PerformanceModel.Badge){
      latestBadgeName.value = (result as PerformanceModel.Badge).name;
    }else{
      latestBadgeName.value = "None";
      print("Update Latest Badge is Nil");
    }
  }

  void splitIntoTwo(){
    //Badge Achieved
    /*PerformanceModel.Badge tempBadge = PerformanceModel.Badge(desc: "",icon: "",id: "5",name: "");
    PerformanceModel.Badge temp2Badge = PerformanceModel.Badge(desc: "",icon: "",id: "6",name: "");
    PerformanceModel.Badge temp3Badge = PerformanceModel.Badge(desc: "",icon: "",id: "3",name: "");
    totalBadges.add(tempBadge);
    totalBadges.add(temp2Badge);
    totalBadges.add(temp3Badge);*/
    badgesEarnedList.clear();
    badgesLeftList.clear();
    totalBadges.forEach((element) {
      if(element is PerformanceModel.Badge){
        var result = earnedBadges.value.contains(element.id);
        if(result){
          badgesEarnedList.add(element);
        }else{
          badgesLeftList.add(element);
        }
      }
    });
    print("Length Of List Earned is ${badgesEarnedList.length} Length Of List empty is ${badgesLeftList.length}");
  }

  void updateTimelineFilter(TimelineFilter temp){
    timelineFilter.value = temp;
    switch(temp){
      case TimelineFilter.SEVENDAYS:
        leaderboardList.value.sort((b, a) => a.sevenDayStats[0].compareTo(b.sevenDayStats[0]));
        print("Leaderboard list ${leaderboardList}");
        update();
        break;
      case TimelineFilter.THIRTYDAYS:
        leaderboardList.value.sort((b, a) => a.thirtyDayStats[0].compareTo(b.thirtyDayStats[0]));
        print("Leaderboard list ${leaderboardList}");
        update();
        break;
      case TimelineFilter.ALLTIME:
        leaderboardList.value.sort((b, a) => a.allTimeStats[0].compareTo(b.allTimeStats[0]));
        print("Leaderboard list ${leaderboardList}");
        update();
        break;
    }
  }

  void hamburgerPressed() {
    print("Menu Pressed");
  }

  void notificationPressed() {
    print("Notification Pressed");
  }

  void fetchGoals() {
    try{
      VEGoalController veGoalController = Get.find();
      //Map the activegoallist to dropdown
      goalDropDownList.clear();
      veGoalController.activeGoalList?.forEach((keyData) {
        goalDropDownList.add(DropdownMenuItem(
          child: Text(
            keyData.goalInfo.name.toString(),
          ),
          value: keyData.goalInfo.id.toString(),
        ));
      });
    }catch(onError, stacktrace){
      print("Fetching Goals in Performance Controller Error $onError, Stacktrace $stacktrace");
    }

  }

}