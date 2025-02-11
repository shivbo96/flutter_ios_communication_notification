import Flutter
import UIKit
import flutter_ios_communication_notification


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 15.0, *) {
            if (notification.request.identifier.starts(with: FlutterIosCommunicationConstant.prefixIdentifier)) {
                completionHandler([.banner, .badge, .sound, .list])
            }
        }

        return super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if #available(iOS 15.0, *) {
            if (response.notification.request.identifier.starts(with: FlutterIosCommunicationConstant.prefixIdentifier)) {
                let userInfo = response.notification.request.content.userInfo

                FlutterIosCommunicationNotificationPlugin.shared.onClickNotification(userInfo)

                completionHandler()
            }
        }

        return super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
}
