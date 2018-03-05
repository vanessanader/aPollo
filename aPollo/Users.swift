//
//  Users.swift
//  aPollo
//
//  Created by Vanessa Nader on 2/19/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct student {
    var name: String
    var email : String
    var isStudent : BooleanLiteralType
    
    
    
    
    
    func toAnyObject() -> NSDictionary {
        return ["Name": name, "Email" : email, "isStudent" : isStudent]
        
        
    }
    
    
}
