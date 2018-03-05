//
//  EvaluationQuestionStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct EvaluationQuestion{
    
    var evaluationNumber : String
    
    var questionText : String
    
    var answers : [String]
    
    func toAnyObject() -> NSDictionary {
        return ["EvaluationNumber" : evaluationNumber, "QuestionText" : questionText, "Answers" : answers]
    }
}
