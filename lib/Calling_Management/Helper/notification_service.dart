// utils/notification_service.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

Future<void> showIncomingCallNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'call_channel',
      title: 'Incoming Call',
      body: 'Chandra Gupt is calling...',
      notificationLayout: NotificationLayout.BigPicture,
      bigPicture: 'asset://assets/call_bg.png', // Set image asset
      wakeUpScreen: true,
      category: NotificationCategory.Call,
      fullScreenIntent: true,
      autoDismissible: false,
      locked: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'ACCEPT',
        label: 'Accept',
        color: Colors.green,
      ),
      NotificationActionButton(
        key: 'DECLINE',
        label: 'Decline',
        color: Colors.red,
        isDangerousOption: true,
      ),
    ],
  );
}
