//
//  AttendanceQuestionStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/11/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct AttendanceQuestion {
    var id : String
    
    var classId: String
    
    var isAvailable : BooleanLiteralType
    
    var questionText : String
    
    var answerText : String
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "ClassId" : classId, "IsAvailable" : isAvailable, "QuestionText" : questionText, "AnswerText" : answerText]
}
}
