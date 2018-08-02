//
//  AppDelegate.swift
//  Starflight_swift
//
//  Created by ankushkushwaha on 07/31/2018.
//  Copyright (c) 2018 ankushkushwaha. All rights reserved.
//

import UIKit
import UserNotifications
import Starflight_swift

struct PushNotificationConstants {
    static let starFlightClientID = "YOUR_STARFLIGHT_CLIENT_APP_ID" //"85"
    static let starFlightClientSecret = "YOUR_STARFLIGHT_CLIENT_SECRET"//"50ebac70-5926-4066-bdea-2763b1509010"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        configurePushNotification(launchOptions: launchOptions)

        registerForPushNotification(application: application)

        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print(application.applicationState.rawValue)

        if application.applicationState == .background {
            pushNotificationReceived(userInfo, markAsRead: true)
        } else if application.applicationState == .active {
            pushNotificationReceived(userInfo, markAsRead: true)
        }
        else {
            pushNotificationHandler(notification: userInfo)
            pushNotificationReceived(userInfo, markAsRead: true)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        saveDeviceToken(deviceTokenString)

        print(self.deviceToken)

        let time = StarflightTimePreference(timeZone: "Europe/Helsinki",
                                            monday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00"),
                                            tuesday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00"),
                                            wednesday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00"),
                                            thursday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00"),
                                            friday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00"),
                                            saturday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00"),
                                            sunday: StarflightTimePreference.DailyActiveTime(startHour: "01", startMinute: "00", endHour: "23", endMinute: "00")
        )



        let pushClient =  StarflightClient(appId: PushNotificationConstants.starFlightClientID,
                                           clientSecret: PushNotificationConstants.starFlightClientSecret)

        // if no tag and time preferences the pass 'nil' instead
        pushClient.registerWithToken(token: self.deviceToken,
                                     clientUUID: (clientUUID != "" ? clientUUID : nil),
                                     tags: ["tag1", "tag2"],
                                     timePreferences: time.timePrefJson()) { [unowned self] (responseDict, response, error) in
                                        print("Starflight http response Code: \(String(describing: response?.statusCode))")

                                        if error != nil {
                                            // TODO: handle error here
                                        }
                                        self.handleClientUUIDNotification(responseDictionary: responseDict)
        }

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }

    //MARK: - Push Notification Configutation

    func configurePushNotification(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        //configuring the push notification
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            pushNotificationHandler(notification: notification)
            pushNotificationReceived(notification, markAsRead: true)
        }
    }

    func registerForPushNotification(application: UIApplication){

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }

    }

    func pushNotificationReceived (_ notification: [AnyHashable : Any], markAsRead: Bool) {

        if let messageUUID: String = notification["uuid"] as? String {
            if markAsRead {
                let pushClient = StarflightClient(appId: PushNotificationConstants.starFlightClientID,
                                                  clientSecret: PushNotificationConstants.starFlightClientSecret)
                pushClient.openedMessage(token: deviceToken,
                                         messageUuid: messageUUID) { [unowned self] (responseDict, response, error) in
                                            if error != nil {
                                                // TODO: handle error here
                                            }
                }
            }
        }
    }

    var deviceToken: String {
        let prefs = UserDefaults.standard
        if let token = prefs.string(forKey: "deviceToken") {
            return token
        } else {
            return ""
        }
    }

    func saveDeviceToken (_ deviceToken: String) {
        let prefs = UserDefaults.standard
        prefs.set(deviceToken, forKey: "deviceToken")
        prefs.synchronize()
    }

    var clientUUID: String {
        let prefs = UserDefaults.standard
        if let uuid = prefs.string(forKey: "clientUUID") {
            print(uuid)
            return uuid
        } else {
            return ""
        }
    }

    func saveClientUUID (_ clientUUID: String) {
        let prefs = UserDefaults.standard
        prefs.set(clientUUID, forKey: "clientUUID")
        prefs.synchronize()
    }

    private func handleClientUUIDNotification(responseDictionary: [String : Any]?) {
        if let clientUuid = responseDictionary?["clientUuid"] as? String {
            saveClientUUID(clientUuid)
        }
    }

    func pushNotificationHandler(notification: [AnyHashable : Any]) {
        print("pushNotificationHandler")

        // handle Push notificaiton here wh
    }
}

