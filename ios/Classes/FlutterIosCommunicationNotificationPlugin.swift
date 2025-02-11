import Flutter
import UIKit
import UserNotifications


public class FlutterIosCommunicationConstant {
    static public let prefixIdentifier: String = "FlutterIosCommunicationNotification"
    static public let payloadStored: String = "cn#iosCommunicationCode"
    static public let payloadUpdatedAt: String = "dtime#iosCommunicationCode"
}

//public class FlutterIosCommunicationNotificationPlugin: NSObject, FlutterPlugin {
//  public static func register(with registrar: FlutterPluginRegistrar) {
//    let channel = FlutterMethodChannel(name: "flutter_ios_communication_notification", binaryMessenger: registrar.messenger())
//    let instance = FlutterIosCommunicationNotificationPlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
//  }
//
//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    switch call.method {
//    case "getPlatformVersion":
//      result("iOS " + UIDevice.current.systemVersion)
//    default:
//      result(FlutterMethodNotImplemented)
//    }
//  }
//}



public class FlutterIosCommunicationNotificationPlugin: NSObject, FlutterPlugin {
    static public var shared = FlutterIosCommunicationNotificationPlugin()

    public var flutterChannel: FlutterMethodChannel?

    public func onClickNotification(_ userInfo: [AnyHashable : Any]) {
        if (self.flutterChannel != nil) {
            self.flutterChannel?.invokeMethod("onClick", arguments: userInfo)
        } else {
            // Save to local storage - for get initial payload
            let defaults = UserDefaults.standard
            defaults.set(convertDateToString(Date()), forKey: FlutterIosCommunicationConstant.payloadUpdatedAt)
            defaults.set(userInfo["data"], forKey: FlutterIosCommunicationConstant.payloadStored)
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_ios_communication_notification", binaryMessenger: registrar.messenger())
        let instance = FlutterIosCommunicationNotificationPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        FlutterIosCommunicationNotificationPlugin.shared.flutterChannel = channel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "getInitialPayload":
            let defaults = UserDefaults.standard
            let updatedAt = defaults.string(forKey: FlutterIosCommunicationConstant.payloadUpdatedAt)

            if (updatedAt == nil || (Date().timeIntervalSinceReferenceDate -  convertStringToDate(updatedAt!).timeIntervalSinceReferenceDate) <= 5) {
                result(defaults.string(forKey: FlutterIosCommunicationConstant.payloadStored))
            } else {
                defaults.removeObject(forKey: FlutterIosCommunicationConstant.payloadStored)
                defaults.removeObject(forKey: FlutterIosCommunicationConstant.payloadUpdatedAt)
                result(nil)
            }

            break
        case "showNotification":
            let arguments = call.arguments as? [String: Any] ?? [String: Any]()
            let senderName = arguments["senderName"] as? String ?? ""
            let content = arguments["content"] as? String ?? ""
            let avatar = arguments["imageUrl"] as? String ?? ""
            let value = arguments["value"] as? String ?? ""
            CommunicationNotificationPlugin().showNotification(NotificationInfo(senderName: senderName, imageUrl: avatar, content: content, value: value))
            result(true)
            break
        case "isAvailable":
            if #available(iOS 15.0, *) {
                result(true)
            } else {
                result(false)
            }
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    public func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        let result = formatter.string(from: date)
        return result
    }

    public func convertStringToDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        guard let result = formatter.date(from: dateString) else { return Date() }
        return result
    }
}

