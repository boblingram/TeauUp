import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  void refreshLeaderboardList(){
    GraphQLService.tempWAClient.resetStore(refetchQueries: false);
    fetchLeaderboardList();
  }

  void fetchLeaderboardList()async{
    //Graphql
    final query = gql('''query MyQuery {
  leaderBoard(goalId:"1") {
     FNLN
     id
    userId
    allTimeStats
    sevenDayStats
    thirtyDayStats
  }
}''');
    updateLeaderboardNetworkEnum(NetworkCallEnum.Loading);
    var result = await GraphQLService.makeGraphQLRequest(QueryOptions( document: query));
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
    print("Length of List is ${leaderList.leaderBoard.length}");
    updateLeaderboardNetworkEnum(NetworkCallEnum.Completed);

  }


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
    //print("Length Of List 1 is ${badgesEarnedList.length} Length Of List 2 is ${badgesLeftList.length}");
  }

  void updateTimelineFilter(TimelineFilter temp){
    timelineFilter.value = temp;
  }

  void hamburgerPressed() {
    print("Menu Pressed");
  }

  void notificationPressed() {
    print("Notification Pressed");
  }

}