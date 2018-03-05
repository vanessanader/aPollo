//
//  PollStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct Poll {
    var pollTitle : String
    
    var pollQuestions : [PollQuestion]
    
    func toAnyObject() -> NSDictionary {
        return ["PollTitle": pollTitle, "PollQuestions" : pollQuestions]
    }
}
