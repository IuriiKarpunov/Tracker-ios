//
//  NewHabitOrEventViewControllerDelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 26.10.23.
//

import UIKit

protocol NewHabitOrEventViewControllerDelegate: AnyObject {
    func createTrackers(nameCategory: String, schedule: [WeekDay], nameTracker: String, color: UIColor, emoji: String)
}
