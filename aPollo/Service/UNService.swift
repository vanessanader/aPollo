//
//  UNService.swift
//  Primehop
//
//  Created by Vanessa Nader on 10/25/17.
//  Copyright © 2017 Omar Droubi. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class UNService: NSObject{
    
    private override init(){}
    static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize(){
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "no un authorization error")
            guard granted else {return}
            DispatchQueue.main.async{
                self.configure()
            }
        }
    }
    
    func configure(){
        unCenter.delegate = self
        
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
    }
}

extension UNService: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("un did receive")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("un will present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
