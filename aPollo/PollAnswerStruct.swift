//
//  AnswerStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct PollAnswer {
    var studentEmail : String
    
    var answer : String
    
    func toAnyObject() -> NSDictionary {
        return ["StudentEmail": studentEmail, "Answer" : answer]
    }
}
