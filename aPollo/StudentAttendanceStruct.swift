//
//  StudentAttendanceStruct.swift
//  aPollo
//
//  Created by Vanessa Nader on 4/10/18.
//  Copyright © 2018 Vanessa Nader. All rights reserved.
//

import Foundation

struct StudentAttendance {
    var id : String //class id
    
    var absenceCount : Int
    
    var isPresent : BooleanLiteralType
    
    func toAnyObject() -> NSDictionary {
        return ["Id": id, "AbsenceCount" : absenceCount, "IsPresent" : isPresent]
    }
}
