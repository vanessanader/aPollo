//
//  EvaluationQuestionStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct EvaluationQuestion{
    
    var evaluationNumber : Int //period number to store under since answers change from a period to another
    
    var courseEvaluationId : String
    
    var questionText : String
    
    var answersByStudents : [String] //tell laura and danny to change
    
    var possibleAnswers : [String]
    
    var isMCQ : BooleanLiteralType
    
    var isRating : BooleanLiteralType // to try stars framework
    
    var id : String //for vanessa storage in database
    
    func toAnyObject() -> NSDictionary {
        return ["EvaluationNumber" : evaluationNumber, "CourseEvaluationId": courseEvaluationId, "QuestionText" : questionText, "PossibleAnswers" : possibleAnswers, "AnswersByStudents": answersByStudents, "IsMCQ" : isMCQ, "IsRating" : isRating, "Id" : id]
    }
}
