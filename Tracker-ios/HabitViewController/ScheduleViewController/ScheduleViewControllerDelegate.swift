//
//  ScheduleViewControllerDelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 21.10.23.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func createSchedule(schedule: [WeekDay])
}
