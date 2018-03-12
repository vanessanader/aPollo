//
//  class.swift
//  aPollo
//
//  Created by Vanessa Nader on 3/5/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct Class {
    var id : String
    
    var courseName : String
    
    var courseNumber : String
    
    var location : String
    
    var sectionNumber : String
    
    var professorEmail : String
    
    var evaluationNumber : Int //period number
    
    var evaluationIsStopped : BooleanLiteralType
    
    var evaluationId : String //guid
    
    var studentsEnrolled : [Student]
    
    var classPolls : [String]
    
    var questionsAsked : [String]
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "CourseName" : courseName, "CourseNumber" : courseNumber, "Location": location, "SectionNumber":sectionNumber, "ProfessorEmail" : professorEmail, "EvaluationNumber":evaluationNumber, "EvaluationIsStopped":evaluationIsStopped, "EvaluationId": evaluationId, "StudentsEnrolled": studentsEnrolled, "ClassPolls" : classPolls, "QuestionAsked":questionsAsked]
    }
    
    
    
}
