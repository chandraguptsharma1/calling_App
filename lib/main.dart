import 'package:calling_app/Calling_Management/Home/HomePage.dart';
import 'package:calling_app/Calling_Management/Screens/Calling_Screen.dart';
import 'package:calling_app/Calling_Management/WebSocketClient/websocket_client.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'Calling_Management/Screens/Calling_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon', // Notification icon (set this as per your app icon)
    [
      NotificationChannel(
        channelKey: 'call_channel',
        channelName: 'Calls',
        channelDescription: 'Channel for incoming calls',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        playSound: true,
        channelShowBadge: true,
        defaultPrivacy: NotificationPrivacy.Private,
      )
    ],
  );

  // Setting up listeners for notification taps
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (receivedNotification) async {
      if (receivedNotification.buttonKeyPressed == 'ACCEPT') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => CallingPage()),
        );
      } else if (receivedNotification.buttonKeyPressed == 'DECLINE') {
        await AwesomeNotifications().dismiss(1);
      }
      return Future.value(); // Explicitly return a Future<void>
    },
    onNotificationCreatedMethod: (receivedNotification) async {
      print("Notification created on ${receivedNotification.channelKey}");
      return Future.value(); // Explicitly return a Future<void>
    },
    onNotificationDisplayedMethod: (receivedNotification) async {
      print("Notification displayed on ${receivedNotification.channelKey}");
      return Future.value(); // Explicitly return a Future<void>
    },
    onDismissActionReceivedMethod: (receivedNotification) async {
      print("Notification dismissed on ${receivedNotification.channelKey}");
      return Future.value(); // Explicitly return a Future<void>
    },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String clientId = Uuid().v4(); // Generates a unique client ID

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: HomePage(),
    );
  }
}
