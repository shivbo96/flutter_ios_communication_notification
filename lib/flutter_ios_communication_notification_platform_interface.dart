import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ios_communication_notification_method_channel.dart';
import 'models/notification_info_model.dart';

abstract class FlutterIosCommunicationNotificationPlatform extends PlatformInterface {
  /// Constructs a FlutterIosCommunicationNotificationPlatform.
  FlutterIosCommunicationNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIosCommunicationNotificationPlatform _instance = MethodChannelFlutterIosCommunicationNotification();

  /// The default instance of [FlutterIosCommunicationNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIosCommunicationNotification].
  static FlutterIosCommunicationNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIosCommunicationNotificationPlatform] when
  /// they register themselves.
  static set instance(FlutterIosCommunicationNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> showNotification(NotificationInfo info) {
    throw UnimplementedError('showNotification() has not been implemented.');
  }

  Future<bool> isAvailable() {
    throw UnimplementedError('isAvailable() has not been implemented.');
  }

  void onClickNotification(Function(String payload) onClick) {
    throw UnimplementedError('onClickNotification() has not been implemented.');
  }

  Future<String?> getInitialPayload() async {
    throw UnimplementedError('getInitialPayload() has not been implemented.');
  }
}
