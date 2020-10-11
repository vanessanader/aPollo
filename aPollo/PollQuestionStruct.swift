//
//  PollQuestionStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct PollQuestion {
    var id : String
    
    var questionText : String
    
    var possibleAnswers :[String]
    
    var answersByStudents : [Answer]
    
    var isMCQ : BooleanLiteralType
    
    var correctAnswer : String
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "QuestionText" : questionText, "PossibleAnswers" : possibleAnswers, "AnswersByStudents" : answersByStudents, "IsMCQ" : isMCQ , "CorrectAnswer" : correctAnswer]
    }
}
