import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_ios_communication_notification/flutter_ios_communication_notification.dart';
import 'package:flutter_ios_communication_notification/models/notification_info_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _flutterIosCommunicationNotificationPlugin =
      FlutterIosCommunicationNotification();
  Timer? _backgroundTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backgroundTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App goes into background, start a timer
      _backgroundTimer = Timer(const Duration(seconds: 5), () {
        _showNotification();
      });
    } else if (state == AppLifecycleState.resumed) {
      // App is resumed, cancel the timer
      _backgroundTimer?.cancel();
    }
  }

  void _showNotification() async {
    final isAvailableForCommunication =
        await _flutterIosCommunicationNotificationPlugin.isAvailable();
    debugPrint('isAvailableForCommunication: $isAvailableForCommunication');

    if (isAvailableForCommunication) {
      _flutterIosCommunicationNotificationPlugin.showNotification(
        NotificationInfo(
          senderName: "Shivam ",
          imageUrl:
              'https://fastly.picsum.photos/id/368/536/354.jpg?hmac=2b0UU6Y-8XxkiRBhatgBJ-ni3aWJ5CcVVENpX-mEiIA',
          value: "This is payload, will receive when click this notification",
          content:
              "Hello! This notification is triggered after 5 seconds of background time.",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showNotification,
                child: const Text(
                  'Show Notification',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  debugPrint(
                      "Notification will trigger 5 seconds after backgrounding the app.");
                },
                child: const Text(
                  'Trigger Notification After 5 Sec of Background',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
