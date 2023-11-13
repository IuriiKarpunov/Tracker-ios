//
//  CreatingTrackerViewControllerDelegat.swift
//  Tracker-ios
//
//  Created by Iurii on 26.10.23.
//

import UIKit

protocol CreatingTrackerViewControllerDelegate: AnyObject {
    func createTrackers(tracker: Tracker, categoryName: String)
}
