import Intents
import UIKit
import UserNotifications

public class CommunicationNotificationPlugin {
    func showNotification(_ notificationInfo: NotificationInfo) {
      print("showNotification notificationInfo:\(notificationInfo)")
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings {
            settings in switch settings.authorizationStatus {
            case .authorized:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) {
                    didAllow, _ in
                    if didAllow {
                        self.dispatchNotification(notificationInfo)
                    }
                }
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) {
                    didAllow, _ in
                    if didAllow {
                        self.dispatchNotification(notificationInfo)
                    }
                }
            default: return
            }
        }
    }

   func dispatchNotification(_ notificationInfo: NotificationInfo) {
       if #available(iOS 15.0, *) {

           let uuid = UUID().uuidString
           let currentTime = Date().timeIntervalSince1970
           let identifier = "\(FlutterIosCommunicationConstant.prefixIdentifier):\(uuid):\(currentTime)"

           var content = UNMutableNotificationContent()

           content.title = notificationInfo.senderName
           content.subtitle = ""
           content.body = notificationInfo.content
           content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm"))
           content.categoryIdentifier = identifier
           content.userInfo = ["data": notificationInfo.value]

           var personNameComponents = PersonNameComponents()
           personNameComponents.nickname = notificationInfo.senderName

           guard let imageUrl = URL(string: notificationInfo.imageUrl) else {
               print("Invalid image URL")
               return
           }

           // Download the image asynchronously
           DispatchQueue.global(qos: .background).async {

               let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                                   guard let imageData = data, error == nil else {
                                       print("Failed to download image: \(error?.localizedDescription)")
                                       return
                                   }

                                   let avatar = INImage(imageData: imageData)

                                   let senderPerson = INPerson(
                                       personHandle: INPersonHandle(value: notificationInfo.value, type: .unknown),
                                       nameComponents: personNameComponents,
                                       displayName: notificationInfo.senderName,
                                       image: avatar,
                                       contactIdentifier: nil,
                                       customIdentifier: nil,
                                       isMe: false,
                                       suggestionType: .none
                                   )

                                   let mPerson = INPerson(
                                       personHandle: INPersonHandle(value: "", type: .unknown),
                                       nameComponents: nil,
                                       displayName: nil,
                                       image: nil,
                                       contactIdentifier: nil,
                                       customIdentifier: nil,
                                       isMe: true,
                                       suggestionType: .none
                                   )

                                   let intent = INSendMessageIntent(
                                       recipients: [mPerson],
                                       outgoingMessageType: .outgoingMessageText,
                                       content: notificationInfo.content,
                                       speakableGroupName: INSpeakableString(spokenPhrase: notificationInfo.senderName),
                                       conversationIdentifier: notificationInfo.senderName,
                                       serviceName: nil,
                                       sender: senderPerson,
                                       attachments: nil
                                   )

                                   intent.setImage(avatar, forParameterNamed: \.sender)

                                   let interaction = INInteraction(intent: intent, response: nil)
                                   interaction.direction = .incoming
                                   interaction.donate(completion: nil)

                                   do {
                                       content = try content.updating(from: intent) as! UNMutableNotificationContent
                                   } catch {
                                       print("Error updating notification content: \(error)")
                                   }

                                   // Request from identifier
                                   let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

                                   // Actions
                                   let close = UNNotificationAction(identifier: "close", title: "Close", options: .destructive)
                                   let category = UNNotificationCategory(identifier: identifier, actions: [close], intentIdentifiers: [])

                                   UNUserNotificationCenter.current().setNotificationCategories([category])

                                   // Add notification request
                                   UNUserNotificationCenter.current().add(request)
                               }
                               task.resume()
                           }
       }else {
           // Fallback for iOS 14/13
              let uuid = UUID().uuidString
              let currentTime = Date().timeIntervalSince1970
              let identifier = "\(FlutterIosCommunicationConstant.prefixIdentifier):\(uuid):\(currentTime)"

              let content = UNMutableNotificationContent()
              content.title = notificationInfo.senderName
              content.body = notificationInfo.content
              content.sound = UNNotificationSound.default
              content.userInfo = ["data": notificationInfo.value]

              let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

              UNUserNotificationCenter.current().add(request) { error in
                  if let error = error {
                      print("Error adding notification: \(error)")
                  }
              }
       }
   }

}
