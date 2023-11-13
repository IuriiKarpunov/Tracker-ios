//
//  NewCategoryViewControllerelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 05.11.23.
//

import Foundation

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategories(category: TrackerCategory)
}
