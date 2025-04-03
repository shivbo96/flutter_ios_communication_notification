import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ios_communication_notification_platform_interface.dart';
import 'models/notification_info_model.dart';

/// An implementation of [FlutterIosCommunicationNotificationPlatform] that uses method channels.
class MethodChannelFlutterIosCommunicationNotification
    extends FlutterIosCommunicationNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('flutter_ios_communication_notification');

  @override
  Future<String?> getInitialPayload() async {
    final String? payload = await methodChannel.invokeMethod<String>(
      "getInitialPayload",
    );

    return payload;
  }

  @override
  void onClickNotification(Function(String payload) onClick) {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "onClick") {
        final String payload = call.arguments['data'];
        onClick(payload);
      }
    });
  }

  @override
  Future<void> showNotification(NotificationInfo info) async {
    await methodChannel.invokeMethod("showNotification", info.toMap());
  }

  @override
  Future<bool> isAvailable() async {
    if (!Platform.isIOS) return false;

    final bool isAvailable =
        await methodChannel.invokeMethod<bool>("isAvailable") ?? false;

    return isAvailable;
  }
}
