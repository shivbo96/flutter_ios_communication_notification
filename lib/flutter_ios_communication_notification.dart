import 'flutter_ios_communication_notification_platform_interface.dart';
import 'models/notification_info_model.dart';

class FlutterIosCommunicationNotification {

  Future<void> showNotification(NotificationInfo info) {
    return FlutterIosCommunicationNotificationPlatform.instance.showNotification(info);
  }

  Future<bool> isAvailable() {
    return FlutterIosCommunicationNotificationPlatform.instance.isAvailable();
  }

  void setOnClickNotification(Function(String payload) onClick) {
    return FlutterIosCommunicationNotificationPlatform.instance.onClickNotification(onClick);
  }

  Future<String?> getInitialPayload() async {
    return FlutterIosCommunicationNotificationPlatform.instance.getInitialPayload();
  }
}
