//
//  Tracker.swift
//  Tracker-ios
//
//  Created by Iurii on 11.10.23.
//


import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let isPinned: Bool
}

enum WeekDay: String, CaseIterable, Codable  {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    var fullName: String {
        switch self {
        case .monday:
            return NSLocalizedString("mondayFull", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayFull", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayFull", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayFull", comment: "")
        case .friday:
            return NSLocalizedString("fridayFull", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayFull", comment: "")
        case .sunday:
            return NSLocalizedString("sundayFull", comment: "")
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString("mondayShort", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayShort", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayShort", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayShort", comment: "")
        case .friday:
            return NSLocalizedString("fridayShort", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayShort", comment: "")
        case .sunday:
            return NSLocalizedString("sundayShort", comment: "")
        }
    }
    
    var numberOfDay: Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }
}
