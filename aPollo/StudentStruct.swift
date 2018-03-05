//
//  Users.swift
//  aPollo
//
//  Created by Vanessa Nader on 2/19/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct Student {
    var name: String
    
    var email : String
    
    var isStudent : BooleanLiteralType
    
    var classes : [Class]
    
    var questionsAsked : [String]
    
    func toAnyObject() -> NSDictionary {
        return ["Name": name, "Email" : email, "isStudent" : isStudent, "Classes" : classes, "QuestionsAsked": questionsAsked]
    }
    
    
}
