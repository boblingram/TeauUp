import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../utils/Constants.dart';

//View and Edit Goal Controller
class VEGoalController extends GetxController{

  String userId = "1";

  void tempFetchQuery()async{
    print("Query is Initiated");
    //Graphql
    final HttpLink httpLink = HttpLink(Constants.BASEURL,
      defaultHeaders: {
        Constants.HEADER_API_KEY: Constants.API_KEY
      },
    );

    final GraphQLClient graphqlClient = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    ///View Goal - Active
    final query = gql('''query MyQuery {
  userGoals(userId: "$userId") {
    activities
    backup
    createdBy
    createdDt
    desc
    id
    members
    mentor
    modifiedBy
    modifiedDt
    name
collabType
type
status
  }
}
''');

    ///View Goal - Inside Active
    /*final query = gql('''query MyQuery {
  goalActivities(goalId: "1") {
    customDay
    desc
    duration
    endDt
    freq
    id
    monthDay
    name
    reminder
    time
    weekDay
  }
}
''');*/

    ///View Goal - Participants
    /*final query = gql('''query MyQuery {
  goalMembers(goalId: "1") {
    createdDt
    deviceId
    fullname
    id
    ph
  }
}
''');*/

    /*///View Journey
    final query = gql('''query viewJourney {
  userJourney(userId: "1") {
    date
    id
    name
    status
    time
  }
}
''');*/



    var result = await graphqlClient.query(QueryOptions(document: query));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    if(result.data == null && result.exception != null){
      //No Data Received from Server;
      parseError(result.exception,"FetchLeaderboardList");
      return;
    }
  }

  void createGoalMutation(String status, String goalName, String goalDescription) async {
    print("Mutation is Initiated");
    //Graphql
    final HttpLink httpLink = HttpLink(Constants.BASEURL,
      defaultHeaders: {
        Constants.HEADER_API_KEY: Constants.API_KEY
      },
    );

    final GraphQLClient graphqlClient = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    String currentDate = DateTime.now().toIso8601String();

    String mutation = """
  mutation MyMutation(\$activities: [ActivityIP] = [], \$members: [UserIP] = []) {
  postGoal(goal: {collabType: "", createdBy: "1", createdDt: "$currentDate", desc: "${goalDescription.trim()}", modifiedBy:"$userId", modifiedDt: "$currentDate", name: "${goalName.trim()}", type: "$status", members: \$members, activities: \$activities, mentor: "", backup: "",status:"ACTIVE"}) {
    id
    name
    desc
    createdDt
    activities
    members
    mentor
    backup
  }
}
""";


    var result = await graphqlClient.mutate(MutationOptions(document: gql(mutation)));
    //var result = await graphqlClient.query(QueryOptions(document: gql(mutation)));
    //It can have exception or data
    log(result.data.toString());
    //json.encode(result.data);
    if(result.data == null && result.exception != null){
      //No Data Received from Server;
      parseError(result.exception,"FetchLeaderboardList");
      return;
    }

  }

  void parseError(OperationException? responseToShow, String apiCallFrom){
    print("Error in $apiCallFrom");
    if (responseToShow != null && responseToShow.graphqlErrors.isNotEmpty){
      print("Error is ${responseToShow.graphqlErrors[0].message}");
    }else{
      log("Exception is $responseToShow");
    }
  }

}