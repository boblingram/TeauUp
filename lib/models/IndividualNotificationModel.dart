class NotificationDataModel {
  List<IndividualNotificationModel> notificationDataList;

  NotificationDataModel({
    required this.notificationDataList,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationDataModel(
        notificationDataList: List<IndividualNotificationModel>.from(
            json["toUserNotifications"]
                .map((x) => IndividualNotificationModel.fromJson(x))),
      );
}

//TODO Update the IndividualGoal Comment
class IndividualNotificationModel {
  var id;
  var msg;
  var status;
  var type;
  var createdDt;

  IndividualNotificationModel(
      {this.id, this.createdDt, this.msg, this.status, this.type});

  factory IndividualNotificationModel.fromJson(Map<String, dynamic> json) =>
      IndividualNotificationModel(
        id: json["id"],
        createdDt: json["createdDt"],
        msg: json["msg"],
        status: json["status"],
        type: json["type"],
      );
}

/*
 */
