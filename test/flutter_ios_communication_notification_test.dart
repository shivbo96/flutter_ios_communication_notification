import 'package:flutter_ios_communication_notification/flutter_ios_communication_notification_method_channel.dart';
import 'package:flutter_ios_communication_notification/flutter_ios_communication_notification_platform_interface.dart';
import 'package:flutter_ios_communication_notification/models/notification_info_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIosCommunicationNotificationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterIosCommunicationNotificationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getInitialPayload() {
    return Future.value('');
  }

  @override
  Future<bool> isAvailable() {
    return Future.value(true);
  }

  @override
  void onClickNotification(Function(String payload) onClick) {
    // TODO: implement onClickNotification
  }

  @override
  Future<void> showNotification(NotificationInfo info) {
    return Future.value();
  }
}

void main() {
  final FlutterIosCommunicationNotificationPlatform initialPlatform =
      FlutterIosCommunicationNotificationPlatform.instance;

  test('$MethodChannelFlutterIosCommunicationNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIosCommunicationNotification>());
  });

  // test('getPlatformVersion', () async {
  //   FlutterIosCommunicationNotification flutterIosCommunicationNotificationPlugin =
  //       FlutterIosCommunicationNotification();
  //   MockFlutterIosCommunicationNotificationPlatform fakePlatform = MockFlutterIosCommunicationNotificationPlatform();
  //   FlutterIosCommunicationNotificationPlatform.instance = fakePlatform;
  //
  //   expect(await flutterIosCommunicationNotificationPlugin.getPlatformVersion(), '42');
  // });
}
