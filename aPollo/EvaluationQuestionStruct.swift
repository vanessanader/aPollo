//
//  EvaluationQuestionStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct EvaluationQuestion{
    
    var evaluationNumber : String //period number to store under since answers change from a period to another
    
    var courseEvaluationId : String
    
    var questionText : String
    
    var answersByStudents : [Answer]
    
    var possibleAnswers : [String]
    
    var isMCQ : BooleanLiteralType
    
    func toAnyObject() -> NSDictionary {
        return ["EvaluationNumber" : evaluationNumber, "CourseEvaluationId": courseEvaluationId, "QuestionText" : questionText, "PossibleAnswers" : possibleAnswers, "AnswersByStudents": answersByStudents, "IsMCQ" : isMCQ]
    }
}
