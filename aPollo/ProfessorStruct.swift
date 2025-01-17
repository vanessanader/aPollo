//
//  ProfessorStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct Professor{
    var name: String
    
    var email : String
    
    var classes : [String]
    
    func toAnyObject() -> NSDictionary {
        return ["Name": name, "Email" : email, "Classes" : classes]
    }
}
