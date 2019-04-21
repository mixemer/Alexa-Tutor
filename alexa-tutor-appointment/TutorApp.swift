//
//  TutorApp.swift
//  alexa-tutor-appointment
//
//  Created by Mehmet Sahin on 4/20/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import Foundation

struct TutorApp {
    var id : String = ""
    var classCode : String = ""
    var tutorName : String = ""
    var days = [String]()
    var startTime : String = ""
    var endTime : String = ""
    let formatter = DateFormatter()
    var startDate = Date()
    var endDate = Date()
    
    init() {
        formatter.dateFormat = "yyyy/MM/dd"
//        let someDateTime = formatter.date(from: "2016/10/08 22:31")
    }
}
