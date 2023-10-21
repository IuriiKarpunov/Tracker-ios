//
//  File.swift
//  Tracker-ios
//
//  Created by Iurii on 21.10.23.
//

import Foundation

protocol ScheduleCellDelegate: AnyObject {
    func switchStateChanged(weekDay: WeekDay, isOn: Bool)
}
