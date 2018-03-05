//
//  QuestionStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct StudentQuestion {
    var id : String
    
    var courseNumber : String
    
    var questionText : String
    
    var answerText : String
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "CourseNumber" : courseNumber, "QuestionText" : questionText, "AnswerText" : answerText]
    }
}
