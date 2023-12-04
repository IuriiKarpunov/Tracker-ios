//
//  NewHabitOrEventViewControllerDelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 26.10.23.
//

import UIKit

protocol NewHabitOrEventViewControllerDelegate: AnyObject {
    func createTrackersHabit(tracker: Tracker, categoryName: String)
}
