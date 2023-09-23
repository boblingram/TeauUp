import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'enums.dart';

/// Initialize the [FlutterLocalNotificationsPlugin] package.
//late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }

  var payload = notificationResponse.payload;
  try {
    if (payload == null) {
      return;
    }
    var temp = jsonDecode(payload);
    print("Inside On Select Notification ${temp.runtimeType}");
  } catch (onError, stacktrace) {
    print("Json Error on Select Notification Error ${onError}");
    print("StackTrace is ${stacktrace}");
    print("PayLoad ${payload}");
  }
}

class Notification_Service {
  //Singleton pattern
  static final Notification_Service _notificationService =
  Notification_Service._internal();

  Notification_Service._internal();

  factory Notification_Service() {
    return _notificationService;
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('channel ID', 'channel name',
      channelDescription: 'channel description',
      playSound: true,
      priority: Priority.max,
      importance: Importance.max,
      groupKey: "group_teamup");

  static const DarwinNotificationDetails iosNotificationDetails =
  DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    threadIdentifier: "group_teamup",
  );

  static const NotificationDetails platformChannelSpecifics =
  NotificationDetails(
      android: androidNotificationDetails, iOS: iosNotificationDetails);

  void _onSelectNotification(String payload) {
    try {
      var temp = jsonDecode(payload);
      print("Inside On Select Notification ${temp.runtimeType}");

    } catch (onError, stacktrace) {
      print("Json Error on Select Notification Error ${onError}");
      print("StackTrace is ${stacktrace}");
      print("PayLoad ${payload}");
    }
  }

  Future<void> init() async {
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    //Now iOS and MacOS have been combined into one and removed Different
    final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );
    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    //Action Notification is not supported by Firebase show paused
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.payload != null) {
          _onSelectNotification(notificationResponse.payload!);
        }
        /*switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            if(notificationResponse.payload != null){
              _onSelectNotification(notificationResponse.payload!);
            }
            //selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            //Action is not supported as off now
            */ /*if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }*/ /*
            break;
        }*/
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //Android 13 Request Notification Permission
    if (GetPlatform.isAndroid) {
      try {
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.requestPermission();
      } catch (onError) {
        print(
            "Flutter Local Notification Android 13 Request Permission $onError");
      }
    }
    _checkFirebaseInitialMessage();
  }

  void _checkFirebaseInitialMessage() {
    //Firebase Messaging Initial Message Called in Splash Screen
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //This is called from background handler
      print('A new onMessageOpenedApp event was published!');
      if (message.data == null || message.data.isEmpty) {
        return;
      }
      print("Message Received is ${message.data}");
      //Get.to(PushNotificationNewsView(newsSlug: message.data["news_slug"], singleNewsNavigation: SingleNewsNavigation.PushNotification));
    }).onError((handleError) {
      print(
          "MessageOpenError in Opening of Application ${handleError.toString()}");
    });

    //IF Application Notification is Shown in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Push Notification Received");
      //Already Shown
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? iOSNot = message.notification?.apple;
      if (GetPlatform.isAndroid) {
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    groupKey: channel.groupId),
              ),
              payload: jsonEncode(message.data));
        }
      }
      //Shown Automatically
      /*if (notification != null && iOSNot != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(iOS: DarwinNotificationDetails()),
            payload: jsonEncode(message.data));
      }*/
    });
  }
}