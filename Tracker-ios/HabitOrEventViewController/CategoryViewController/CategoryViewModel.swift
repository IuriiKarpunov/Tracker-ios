//
//  CategoryViewModel.swift
//  Tracker-ios
//
//  Created by Iurii on 17.11.23.
//

import Foundation

class CategoryViewModel {
    
    // MARK: - Stored properties
    
    weak var delegate: CategoryViewControllerDelegate?
    private var trackerCategoryStore = TrackerCategoryStore.shared
    var categories: [TrackerCategory] = []

    // MARK: - Public Methods
    
    func fetchCategories() {
        categories = trackerCategoryStore.trackerCategory
    }

    func numberOfCategories() -> Int {
        return categories.count
    }

    func category(at index: Int) -> String {
        return categories[index].title
    }

    func addCategory(_ category: TrackerCategory) {
        if !categories.contains(where: { $0.title == category.title }) {
            categories.append(category)
            
        }
    }
}
