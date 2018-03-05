//
//  CourseEvaluationStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct CourseEvaluation {
    var id : String
    
    var questions : [EvaluationQuestion]
    
    var participants : [String]
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "Questions" : questions, "Participants" : participants]
    }
    
}
