//
//  PollStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct Poll {
    
    var id : String
    
    var pollTitle : String
    
    var pollQuestions : [PollQuestion]
    
    var classId : String
    
    var isAvailable : BooleanLiteralType //available for the students to see
    
    var isActive : BooleanLiteralType //available for the students to answer
    
    var isAnswered : BooleanLiteralType //to check if students already answered this poll or not to make it old poll
    
    var pollDate : Int
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "PollTitle": pollTitle, "ClassId": classId, "PollQuestions" : pollQuestions, "IsAvailable": isAvailable, "PollDate": pollDate, "IsActive": isActive]
    }
}
