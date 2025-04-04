//
//  Lecture.swift
//  Univ_TimeTable
//
//  Created by 성현주 on 3/20/25.
//

import Foundation
import UIKit

public struct Lecture {
    public let classroomID  : String
    public let name: String
    public let classroom  : String
    public let professor : String
    public let courseDay : Day
    public let startTime : String
    public let endTime   : String
    public let textColor      : UIColor?
    public let backgroundColor: UIColor

    public init(classroomID: String, name: String, classroom: String, professor: String, courseDay: Day,startTime: String, endTime: String, backgroundColor: UIColor) {
        self.classroomID        = classroomID
        self.name            = name
        self.classroom       = classroom
        self.professor       = professor
        self.courseDay       = courseDay
        self.startTime       = startTime
        self.endTime         = endTime
        self.textColor       = UIColor.white
        self.backgroundColor = backgroundColor
    }

}

