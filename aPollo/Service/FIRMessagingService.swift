//
//  FIRMessagingService.swift
//  Primehop
//
//  Created by Vanessa Nader on 10/25/17.
//  Copyright © 2017 Omar Droubi. All rights reserved.
//

import Foundation
import FirebaseMessaging

class FIRMessagingService{
    private init() {}
    static let shared = FIRMessagingService()
    let messaging = Messaging.messaging()
    
    func subscribe() {
       
    }
    
    func unsubscribe(){
        
    }
    
}
